---
version: beta
name: "Desktop planner"
description: "A weekly Org agenda and a Google Calendar week grid that read as one Solarized pair on the desktop."
colors:
  canvas: "#002b36"
  surface: "#073642"
  text: "#cad8d9"
  secondary: "#adbcbc"
  muted: "#72898f"
  today: "#41c7b9"
  pending: "#58a3ff"
  done: "#84c747"
  deadline: "#dbb32d"
  waiting: "#af88eb"
  eventRed: "#fa5750"
  eventOrange: "#ed8649"
  eventYellow: "#dbb32d"
  eventGreen: "#75b938"
  eventCyan: "#41c7b9"
  eventBlue: "#4695f7"
  eventViolet: "#af88eb"
  eventMagenta: "#f275be"
typography:
  title: { fontFamily: "SF Pro Display", fontSize: "28px", fontWeight: 600 }
  dayNumber: { fontFamily: "SF Pro Display", fontSize: "23px", fontWeight: 600 }
  body: { fontFamily: "SF Pro Text", fontSize: "16px" }
  utility: { fontFamily: "SF Pro Text", fontSize: "13.6px", fontWeight: 600 }
  event: { fontFamily: "SF Pro Text", fontSize: "13.6px", fontWeight: 500 }
rounded:
  panel: "18px"
  event: "5px"
spacing:
  outerMargin: "48px"
  gutter: "32px"
  contentInset: "24px"
  titleBand: "88px"
components:
  plannerPanel: { backgroundColor: "rgba(0, 43, 54, 0.84)", borderRadius: "18px", border: "1px solid rgba(147, 161, 161, 0.24)" }
  titleBand: { height: "88px", background: "linear-gradient(to right, rgba(65,199,185,0.30) 8%, rgba(7,54,66,0.97) 65%)", rule: "1px rgba(147,161,161,0.14)" }
  todayMarker: { color: "#41c7b9", band: "#073642", label: "Today" }
  eventBlock: { fill: "accent at 22%", bar: "3px solid accent", radius: "5px" }
---

# Desktop Planner Design

## Overview

Two native panels sit on the desktop's bottom layer as one pair: the weekly Org **Agenda** on the left and the Google **Calendar** week grid on the right. Both are quiet Solarized surfaces with SF Pro type. The pair shares one shell, one tinted title band, one type scale and one way of marking today, so they read as a single desk rather than two widgets. Task clarity and dependable clicks come before decoration.

Runtime ownership:
- `~/.config/desktop-planner/panel.css` owns the shell and title band for both GTK viewers.
- The agenda renderer (`~/.emacs.d/config/agenda-desktop-init.el`) owns the agenda's palette, `praharsh-agenda-desktop-colors`, and its text styling.
- `~/.local/bin/gcal-week-desktop` owns the calendar's drawing.
- The GTK viewers own geometry.

This document mirrors those runtime values. When they change, reconcile it in the same change.

## Colors

`canvas` and `surface` are Solarized; text and accents are Selenized.
- `text` is for tasks and event titles, `secondary` for dates, subtitles and completed tasks, and `muted` for hour labels and quiet support.
- `today` marks the current day in both panels, plus the ↗ cue that opens each panel's full app.
- Task states keep their meanings: TODO/TOREAD use `pending`, DONE/READ use `done`, WAIT uses `waiting`, and CANCELED uses `secondary`.
- Deadline text uses `deadline`.

Calendar events take the nearest Selenized event accent to their Google color, by hue. Low-saturation colors use `muted`. The calendar keeps its identity by hue but never introduces a color outside this palette.

## Typography

SF Pro Display carries the panel titles and day numerals. SF Pro Text carries everything else.

| Role | Size |
|---|---|
| Titles | 28 px semibold |
| Day numerals | 23 px semibold, always two digits |
| Weekdays and task text | 16 px (calendar headers 15 px) |
| Subtitles and state chips | 13.6 px |
| Calendar event titles | 13.6 px |
| Event times and hour labels | 12 px |

Interface labels are sentence case ("Today"). Only Org's literal task states are capitals, and they are always shown as text, never as color alone. Meta text is written as words: "Week 40, 28 Sep – 4 Oct 2026", not "28 Sep — 04 Oct 2026 · W40".

## Layout

On a 1920 × 1080 screen with the 32 px bar at the bottom:

| Panel | x | y | Size |
|---|---|---|---|
| Agenda | 48–588 | 48–1000 | 540 × 952 |
| Calendar | 620–1872 | 48–1000 | 1252 × 952 |

The margins are 48 px on every side, including above the bar, with a 32 px gutter between the panels. The calendar is anchored left and right, so it absorbs other screen widths.

Every panel starts with the 88 px title band: the title, then the subtitle, 24 px from the left edge. Content below keeps the same 24 px inset.

**Agenda:**
- One weekly column: the Agenda title and ↗, then the week subtitle, then seven date sections.
- Empty dates stay, to keep the week's structure.
- Long tasks wrap.
- The title and week subtitle stay fixed while the body scrolls with the mouse wheel or trackpad. Saved edits preserve the current entry and wrapped-line position.
- Emacs requests a frame whose text area is the largest character-cell multiple that fits the panel, with 24 px internal borders. GTK shows the image unscaled and top-aligned, so a shorter native Wayland export does not shift the title below its band.

**Calendar:**
- A header row of "01 Thu" day labels, then an hour grid.
- The grid spans 8–20 by default and widens to fit the week's events.
- All-day events sit in lanes under the header.
- Overlapping events share their column's width.

## Elevation & Depth

Both shells are canvas at 84% with a 1 px `rgba(147, 161, 161, 0.24)` border. The title band holds its cyan wash through 8% of the panel width, then fades into `surface` at 65%, with a 1 px hairline. Proportional stops give the wider calendar a longer wash and transition. Exactly `#002b36` is keyed out of the agenda image, so the shell and band show through behind the text. There are no shadows, blur or animation; tonal bands carry the hierarchy.

## Shapes

- Panels have 18 px corners, and the band follows the top corners.
- Agenda date bands and the calendar's today column are rectangular.
- Event blocks have 5 px corners and a 3 px accent bar.
- State chips are compact Org Modern labels.
- The only decorative glyph is the ↗ cue.

## Components

**Agenda:**
- Clicking the title opens the user's interactive Org agenda in normal Emacs.
- Clicking a task toggles its saved state through its Org marker, with the existing habit undo, version and source guards.
- Scroll requests are batched and serialized with task clicks. Clicks wait for the matching rendered image; stale requests retry only after a successful refresh. Scrolling the current image does not rebuild the agenda or sync calendar events.

**Calendar:**
- Every click re-syncs with Google; while that runs, the subtitle reads "syncing…".
- A left click on a day opens that week in Google Calendar.
- The subtitle shows the last sync time, and a small banner reports when the calendar service is unavailable while the last week stays visible.

**Both:** neither panel ever takes keyboard focus.

## Do's and Don'ts

- Do keep the shell and band in `panel.css` only. Both viewers load it.
- Do keep both panels the same height, with edges aligned to the layout table.
- Do mark today only with the `today` color, the surface band or column, and the "Today" label.
- Do preserve `org-hd-marker`, day properties and exact image-to-frame coordinates.
- Don't scale the agenda image, replace Org task semantics, or take keyboard focus.
- Don't introduce colors outside this palette, ALL-CAPS interface labels, or "·" meta separators.
