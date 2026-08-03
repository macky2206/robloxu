# robloxu

A Roblox mobile-style menu UI built with Lua.

## Files

- `main.lua` — runtime logic (dragging, toggles, dropdown behavior, open/close flow)
- `menu.lua` — UI construction and menu layout/theme

## How to Use

### Option A: Roblox Studio (recommended for development)

1. Create a `LocalScript`.
2. Put `main.lua` code into that `LocalScript`.
3. Add `menu.lua` as a `ModuleScript` named `menu`:
   - either as a child of the `LocalScript`
   - or as a sibling
   - or under `ReplicatedStorage`
4. Play test.

### Option B: loadstring (single-line execution)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/macky2206/robloxu/refs/heads/copilot/make-design-like-sent-images/main.lua"))()
```

`main.lua` now tries local module locations first, then falls back to downloading `menu.lua` from GitHub if needed.

## Current Features

- Open floating menu button
- Draggable open button
- Draggable menu window (header drag)
- Close/open menu behavior
- Toggle rows with animated switch + glow state
- Dropdown rows with open/close and option selection
- Theme styling (colors, borders, rounded corners)
- Existing menu rows for:
  - Menu Behavior section
  - Behavior section
  - Open/Close animation dropdowns
  - Always on Top / Click-Through / Remember Position toggles

## Add or Edit Features

All content rows are defined in `menu.lua` inside `MenuDesign.build`.

### Add a new toggle

Add another `makeToggleRow(...)` call near the bottom of `menu.lua`:

- `title` (name shown in UI)
- `subtitle` (description text)
- `enabled` (`true`/`false` default)

No extra handler wiring is required for click state animation: `main.lua` loops all `ui.toggles` automatically.

### Add a new dropdown

Add another `makeDropdownRow(...)` call:

- title
- options table
- selected index

No extra open/close wiring is required: `main.lua` loops all `ui.dropdowns` automatically.

### Add a new section label

Use `makeSection("SECTION NAME")`.

### Add custom behavior for toggles/dropdowns

If you want toggles to control game logic (not just UI state), add your behavior in `main.lua` inside:

- toggle `.Activated` connection loop
- dropdown option `.Activated` loop

## Troubleshooting

### `attempt to index nil with 'WaitForChild'` on line 8

This usually means an older `main.lua` version is still being executed (the old line 8 required `script.Parent:WaitForChild("menu")` directly).

Checklist:

1. Confirm your URL points to the updated branch/version.
2. Re-run with the same updated URL after replacing old script text.
3. In Studio/module setup mode, ensure `menu` exists in one of:
   - child of script
   - sibling of script
   - `ReplicatedStorage`
4. For executors that cache remote scripts, restart/rejoin and run again.

### Menu does not open

- Verify `Players.LocalPlayer` exists (must run as LocalScript/client context).
- Check if `PerfectMobileMenu` is created under `PlayerGui`.

## Notes

- Running repeatedly is supported; old `PerfectMobileMenu` is replaced on rebuild.
- The UI sliders shown are currently visual rows unless you wire additional behavior in `main.lua`.