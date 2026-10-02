---
version: alpha
name: "Native desktop agenda"
description: "A quiet weekly Org planner on the desktop, with SF Pro typography and Solarized surfaces."
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
typography:
  title: { fontFamily: "SF Pro Display", fontSize: "24pt", fontWeight: 600 }
  dayNumber: { fontFamily: "SF Pro Display", fontSize: "17.4pt", fontWeight: 600 }
  body: { fontFamily: "SF Pro Text", fontSize: "12pt" }
  utility: { fontFamily: "SF Pro Text", fontSize: "10.2pt", fontWeight: 600 }
rounded:
  panel: "18px"
spacing:
  panelPadding: "10px"
  rendererBorder: "22px"
components:
  agendaPanel: { backgroundColor: "rgba(0, 43, 54, 0.84)", borderRadius: "18px", padding: "10px" }
  todayHeader: { backgroundColor: "#073642", color: "#41c7b9" }
  stateLabel: { backgroundColor: "#073642", fontFamily: "SF Pro Text", fontWeight: 600 }
---

# Native Desktop Agenda Design

## Overview

This contract applies only to the native desktop agenda, not the main Emacs theme. Its reference is a compact weekly desk planner: large date numerals, readable task lines, and a quiet highlighted current day. The audience is the owner of this Linux desktop; English interface labels accompany the user's original Org task text. Task clarity and dependable completion take priority over decoration.

The [renderer](/home/praharsh/.emacs.d/config/agenda-desktop-init.el) owns the palette in `praharsh-agenda-desktop-colors`. `praharsh-agenda-desktop-color` feeds native faces through `praharsh-agenda-desktop-style-frame` and `praharsh-agenda-desktop-style-buffer`, then Emacs exports the PNG. This document mirrors those accepted runtime values; it does not generate tokens. The [GTK viewer](/home/praharsh/.local/bin/emacs-agenda-desktop) owns shell geometry and alpha. When runtime values change, reconcile this document in the same change.

## Colors

Solarized `canvas` and `surface` support Selenized text and semantic accents. Use `text` for tasks, `secondary` for dates and completed task text, and `muted` sparingly for quiet support. `today` identifies the current day and the header's opening cue; `pending`, `done`, `deadline`, and `waiting` retain their task meanings.

TODO/TOREAD labels use `pending`; DONE/READ use `done`; WAIT uses `waiting`; CANCELED uses `secondary`. Deadline text uses `deadline`. Every state keeps its literal text: color supplements TODO, DONE, and WAIT rather than replacing them. Status labels use `surface` with inverse video disabled. Today alone receives a full-width `surface` band.

## Typography

SF Pro Display carries the Agenda title and day numerals; SF Pro Text carries task names, weekday names, date ranges, and state labels. Installed OTF variants supply regular, medium, and semibold weights. Body text is 12pt (`:height 120`), title 2.0× body, day numerals 1.45×, and labels/date-range text 0.85×. Weekday names use medium weight; state labels use semibold and normal width. Keep original task wording and rely on Emacs font fallback for unsupported glyphs.

## Layout

The native frame requests a 476×776px body with 22px internal borders; Emacs may round the resulting frame to font metrics. GTK displays the exact exported pixel dimensions without scaling and adds 10px padding and a 1px border. The bottom-layer panel anchors 24px from the left and 72px from the top, reserves no screen space, and accepts no keyboard focus by explicit user preference.

Present one weekly column: Agenda/open cue, actual displayed date range and week number, then seven date sections. Large day numerals and smaller weekday names define each section; TODAY stays explicit. Keep empty dates to preserve the week structure. Long task titles wrap naturally. Native header/task line spacing is 0.4; compact blank separators use height 0.55 and spacing 0.1. Preserve source markers while styling or changing header text.

## Elevation & Depth

GTK's `canvas` shell uses alpha 0.84 with a 1px `rgba(147, 161, 161, 0.24)` border. Exactly `#002b36` becomes transparent in the PNG, exposing the shell and wallpaper; other native colors remain opaque. Keep the renderer base, transparency key, and shell base synchronized. Tonal bands provide hierarchy without shadows, blur, or animation.

## Shapes

The outer GTK panel has an 18px radius. Native day bands remain rectangular; compact Org Modern labels provide state grouping without introducing separate cards or controls. Keep the title's ↗ cue and literal state names; avoid decorative icons that obscure task meaning.

## Components

Clicking Agenda opens the user's configured, interactive Org agenda in normal Emacs. Clicking a task uses its native Org marker and toggles the saved task state. Completed habits remain visible as DONE for today; another click restores the recorded previous entry only when its saved text still matches. Native Org completion retains repeat and timestamp behavior.

PNG version checks reject stale coordinates; source guards reject unsaved, locked, or externally changed files. The viewer suppresses duplicate/pending clicks, reloads after replies, and reports failures through existing desktop notifications. Loading uses the existing waiting label. Keep the desktop panel free of keyboard focus; normal Emacs remains the full editing and keyboard interface.

## Do's and Don'ts

- Do preserve `org-hd-marker`, day properties, and exact native PNG-to-frame coordinates.
- Do retain SF Pro, explicit task states, and the subdued Solarized/Selenized hierarchy.
- Don't scale the PNG, replace Org task semantics, or steal keyboard focus from desktop work.
- Don't add web layouts, alternate token generators, or ornamental controls to this native surface.
