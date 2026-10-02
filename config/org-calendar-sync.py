#!/usr/bin/python3
"""Publish exported Org events through the signed-in desktop calendar service."""
from pathlib import Path
import re
import sys

import gi

gi.require_version("ECal", "2.0")
gi.require_version("EDataServer", "1.2")
gi.require_version("ICalGLib", "3.0")
from gi.repository import ECal, EDataServer, ICalGLib as ICal

MARKER = "Org agenda sync: "
UID_PATTERN = r"(?:SC|DL|TS[1-9][0-9]*)-[^\s]+"
SYSTEM_ZONE = ECal.util_get_system_timezone()


def timestamp(time):
    if time.is_date():
        return "date", time.as_ical_string()
    return "time", time.as_timet_with_zone(time.get_timezone() or SYSTEM_ZONE)


def values(event, kind):
    result = []
    prop = event.get_first_property(kind)
    while prop:
        result.append(prop.get_value_as_string())
        prop = event.get_next_property(kind)
    return tuple(sorted(result))


def fingerprint(event):
    transp = event.get_first_property(ICal.PropertyKind.TRANSP_PROPERTY)
    return (event.get_summary() or "", (event.get_description() or "").strip(),
            event.get_location() or "", values(event, ICal.PropertyKind.CLASS_PROPERTY) or ("PUBLIC",),
            values(event, ICal.PropertyKind.CATEGORIES_PROPERTY),
            timestamp(event.get_dtstart()), timestamp(event.get_dtend()),
            values(event, ICal.PropertyKind.RRULE_PROPERTY),
            transp.get_value_as_string() if transp else "OPAQUE")


def parse_calendar(text):
    if not text.strip().startswith("BEGIN:VCALENDAR") or not text.strip().endswith("END:VCALENDAR"):
        raise ValueError("export must be a complete VCALENDAR")
    try:
        calendar = ICal.Component.new_from_string(text)
    except (TypeError, ValueError) as error:
        raise ValueError("invalid calendar export") from error
    if calendar.isa() != ICal.ComponentKind.VCALENDAR_COMPONENT or calendar.count_errors():
        raise ValueError("calendar export contains parse errors")
    version = calendar.get_first_property(ICal.PropertyKind.VERSION_PROPERTY)
    if not version or version.get_value_as_string() != "2.0":
        raise ValueError("calendar export must declare VERSION:2.0")
    desired = {}
    event = calendar.get_first_component(ICal.ComponentKind.ANY_COMPONENT)
    while event:
        if event.isa() == ICal.ComponentKind.VTIMEZONE_COMPONENT:
            event = calendar.get_next_component(ICal.ComponentKind.ANY_COMPONENT)
            continue
        uid = event.get_uid()
        if event.isa() != ICal.ComponentKind.VEVENT_COMPONENT or not uid or not re.fullmatch(UID_PATTERN, uid):
            raise ValueError("export contains an unexpected component or event UID")
        if uid in desired or event.count_properties(ICal.PropertyKind.UID_PROPERTY) != 1:
            raise ValueError("export contains duplicate event UIDs")
        if event.count_properties(ICal.PropertyKind.DTSTART_PROPERTY) != 1:
            raise ValueError("export event is missing DTSTART")
        for name, kind in (("dtstart", ICal.PropertyKind.DTSTART_PROPERTY),
                           ("dtend", ICal.PropertyKind.DTEND_PROPERTY)):
            time = getattr(event, "get_" + name)()
            if not time.is_valid_time() or event.count_properties(kind) > 1:
                raise ValueError("export contains an invalid event date")
            if not time.is_date() and not time.get_timezone():
                time.set_timezone(SYSTEM_ZONE)
                getattr(event, "set_" + name)(time)
                event.get_first_property(kind).set_parameter_from_string("TZID", SYSTEM_ZONE.get_location())
        if event.get_dtend().is_date() != event.get_dtstart().is_date():
            raise ValueError("event start and end must use the same date type")
        if timestamp(event.get_dtend()) < timestamp(event.get_dtstart()):
            raise ValueError("event ends before it starts")
        description = (event.get_description() or "").strip()
        event.set_description("\n\n".join(filter(None, (description, MARKER + uid))))
        desired[uid] = event.clone()
        event = calendar.get_next_component(ICal.ComponentKind.ANY_COMPONENT)
    return desired


def sync(client, desired):
    if not client.is_online() or client.is_readonly():
        raise RuntimeError("calendar must be online and writable")
    if not client.refresh_sync(None):
        raise RuntimeError("calendar refresh failed")
    ok, events = client.get_object_list_sync("#t", None)
    if not ok:
        raise RuntimeError("could not list calendar events")
    managed = {}
    for event in events:
        match = re.search(r"(?m)^" + re.escape(MARKER) + "(" + UID_PATTERN + r")$",
                          event.get_description() or "")
        if match:
            uid = match.group(1)
            if uid in managed:
                raise RuntimeError("calendar contains duplicate Org sync markers")
            managed[uid] = event
    created = updated = removed = 0
    for uid, event in desired.items():
        old = managed.get(uid)
        if old is None:
            ok, remote_uid = client.create_object_sync(event, ECal.OperationFlags.NONE, None)
            if not ok or not remote_uid:
                raise RuntimeError("calendar event creation failed")
            created += 1
        elif fingerprint(old) != fingerprint(event):
            event = event.clone()
            event.set_uid(old.get_uid())
            if not client.modify_object_sync(event, ECal.ObjModType.ALL, ECal.OperationFlags.NONE, None):
                raise RuntimeError("calendar event update failed")
            updated += 1
    if not client.is_online():
        raise RuntimeError("calendar went offline; keeping stale events")
    for uid in managed.keys() - desired.keys():
        if not client.remove_object_sync(managed[uid].get_uid(), None, ECal.ObjModType.ALL,
                                         ECal.OperationFlags.NONE, None):
            raise RuntimeError("calendar event removal failed")
        removed += 1
    return created, updated, removed


def check():
    class Calendar:
        def __init__(self):
            self.events = {}
            self.fail = False

        def is_online(self):
            return True

        def is_readonly(self):
            return False

        def refresh_sync(self, *_):
            return True

        def get_object_list_sync(self, *_):
            return True, [e.clone() for e in self.events.values()]

        def create_object_sync(self, event, *_):
            if self.fail:
                raise RuntimeError("upsert failed")
            uid = "google-" + event.get_uid()
            event = event.clone()
            event.set_uid(uid)
            self.events[uid] = event
            return True, uid

        def modify_object_sync(self, event, *_):
            if self.fail:
                raise RuntimeError("upsert failed")
            self.events[event.get_uid()] = event.clone()
            return True

        def remove_object_sync(self, uid, *_):
            del self.events[uid]
            return True

    event = ("BEGIN:VEVENT\nUID:SC-a\nSUMMARY:Task\nLOCATION:Office\n"
             "CLASS:PRIVATE\nCATEGORIES:work,important\n"
             "DTSTART;TZID=America/Chicago:20261002T130000\n"
             "DTEND;TZID=America/Chicago:20261002T140000\nEND:VEVENT\n")
    wrap = lambda body: "BEGIN:VCALENDAR\nVERSION:2.0\n" + body + "END:VCALENDAR\n"
    calendar = Calendar()
    assert "TS2-a" in parse_calendar(wrap(event.replace("SC-a", "TS2-a")))
    floating = event.replace(";TZID=America/Chicago", "")
    floating = floating.replace("END:VEVENT", "RRULE:FREQ=WEEKLY\nEND:VEVENT")
    recurring = parse_calendar(wrap(floating))["SC-a"]
    assert recurring.get_dtstart().get_timezone().get_location() == SYSTEM_ZONE.get_location()
    assert "TZID=" + SYSTEM_ZONE.get_location() in recurring.as_ical_string()
    assert "RRULE:FREQ=WEEKLY" in recurring.as_ical_string()
    desired = parse_calendar(wrap(event))
    assert sync(calendar, desired) == (1, 0, 0), "first sync must create the event"
    assert sync(calendar, parse_calendar(wrap(event))) == (0, 0, 0), "sync must be idempotent"
    remote = next(iter(calendar.events.values()))
    remote.set_dtstart(ICal.Time.new_from_string("20261002T180000Z"))
    remote.set_dtend(ICal.Time.new_from_string("20261002T190000Z"))
    assert sync(calendar, parse_calendar(wrap(event))) == (0, 0, 0), "equivalent timezones must compare equal"
    assert sync(calendar, parse_calendar(wrap(event.replace("Task", "Changed")))) == (0, 1, 0)
    moved = event.replace("Task", "Changed").replace("Office", "Home")
    assert sync(calendar, parse_calendar(wrap(moved))) == (0, 1, 0), "location edits must sync"
    calendar.events["manual"] = ICal.Component.new_from_string(event.replace("SC-a", "manual"))
    calendar.fail = True
    try:
        sync(calendar, parse_calendar(wrap(event.replace("SC-a", "DL-b"))))
        raise AssertionError("failed upsert was ignored")
    except RuntimeError:
        assert "google-SC-a" in calendar.events, "failure must prevent stale deletion"
    calendar.fail = False
    assert sync(calendar, parse_calendar(wrap(""))) == (0, 0, 1)
    assert set(calendar.events) == {"manual"}, "unmanaged events must remain untouched"
    for invalid in ("", "not a calendar", wrap(event + event),
                    wrap(event.replace("20261002T130000", "garbage")),
                    wrap(event.replace("DTSTART;TZID=America/Chicago:20261002T130000",
                                       "DTSTART;VALUE=DATE:20261002"))):
        try:
            parse_calendar(invalid)
            raise AssertionError("invalid export was accepted")
        except ValueError:
            pass
    print("org-calendar-sync checks passed")


if __name__ == "__main__":
    if sys.argv[1:] == ["--check"]:
        check()
    else:
        try:
            if len(sys.argv) != 3:
                raise ValueError("usage: org-calendar-sync.py SOURCE_UID ICS_PATH")
            desired = parse_calendar(Path(sys.argv[2]).read_text(encoding="utf-8"))
            registry = EDataServer.SourceRegistry.new_sync(None)
            source = registry.ref_source(sys.argv[1])
            if not source or not source.has_extension(EDataServer.SOURCE_EXTENSION_CALENDAR):
                raise ValueError("calendar source was not found")
            client = ECal.Client.connect_sync(source, ECal.ClientSourceType.EVENTS, 10, None)
            client.set_default_timezone(SYSTEM_ZONE)
            created, updated, removed = sync(client, desired)
            print(f"Org calendar: {created} created, {updated} updated, {removed} removed")
        except Exception as error:
            print(f"Org calendar sync failed: {error}", file=sys.stderr)
            sys.exit(1)
