# Homies App — Design Rules & Specification

This document is the single source of truth for the app's visual language.
Use it whenever you build a new screen, component, or interaction so it blends
with the existing look & feel. It is derived 1:1 from the code as of
**November 2026** — when the code and this document disagree, fix one of them
in the same change.

Source of truth for tokens: `lib/ui/theme.dart` (colors + typography) and
`lib/ui/components/` (component anatomy).

---

## 1. Design DNA at a glance

- **Friendly, playful, slightly irreverent.** A shared-housing app for
  "homies", not a corporate tool. Rounded shapes, warm yellow, soft shadows,
  cheeky copy.
- **Flat colors + one soft shadow.** No gradients, no glassmorphism, no
  layered elevation. Depth comes from a single subtle drop shadow used
  consistently everywhere.
- **White cards floating on a light-gray background.**
- **Light mode only.** No dark theme exists; do not add one without a
  project-level decision.
- **Yellow is the accent, not the background.** The brand yellow appears as
  the dot after titles, on primary buttons, and on selected states.
- **Every title ends with a yellow dot** (the `HTitle` signature).

---

## 2. Color system

| Token | Hex | Role |
|---|---|---|
| `primary` | `#FFC342` | Homies yellow. Primary buttons, selected nav item, selected calendar day, checked checkbox, the `HTitle` dot. |
| `onPrimary` | `#202020` | Text/icons on primary. |
| `secondary` | `#E5E5E5` | Light gray. Secondary ("quiet") buttons, unselected nav items. |
| `onSecondary` | `#CC202020` | Text/icons on secondary (≈ 80% black). |
| `surface` | `#F6F6F6` | App background, app bar background, bottom sheet background, unselected calendar day cells. |
| `onSurface` | `#202020` | Default text/icons, checkbox borders when checked, shadows (derived, see below). |
| `surfaceContainer` | `#FFFFFF` | Cards, input fields, navbar — anything that "floats" on the background. |
| `error` | `#B94E4E` | Muted red. Error messages, destructive buttons ("Delete", "Leave Home"). |
| `onError` | `#FFFFFF` | Text/icons on error. |

### 2.1 Off-token colors (documented exceptions)

These raw colors exist in code outside the theme. Reuse them for the same
purpose; do not introduce new raw colors.

| Hex | Where | Purpose |
|---|---|---|
| `#E94D4D` | `HOfflineCard.errorBackground` | Brighter red for the offline/error banner (louder than `error` on purpose — it must grab attention). |
| `#AAAAAA` | `HTaskTile` unchecked checkbox border | Disabled/unchecked border tone. |
| `Colors.transparent` | checkbox fill (unchecked), ink overlays | — |
| `Colors.white` | `HOfflineCard` icons/text | Same value as `onError`; write `onError`-style intent as "white on red". |

### 2.2 Opacity conventions (derived from `onSurface` / `onSecondary`)

| Opacity | Used for |
|---|---|
| `onSurface @ 0.25` | Every shadow (see §6). Also the app bar `shadowColor`. |
| `onSurface @ 0.5` (`withValues(alpha: 0.5)`) | Completed-task text + strikethrough color. |
| `onSecondary @ 0.6` | Input hint text. |
| `onSurface @ withAlpha(120)` (≈ 47%) | Bottom-sheet barrier color. |
| `secondary @ withAlpha(120)` | Disabled-feeling cancel button while an operation is in flight (see `LeaveConfirmationModal`). |

### 2.3 Rules

1. **Never hardcode a hex in a widget.** Use `context.colors.<token>` (the
   `ThemeContext` extension from `lib/extensions/theme_extension.dart`). New
   colors go into `theme.dart` first.
2. Text is always `onSurface`, `onPrimary`, `onSecondary`, `onError`, or
   `error` — never `primary` (yellow fails contrast for text; it is a fill
   color, and the `HTitle` dot is its only "text" use).
3. Contrast pairs are fixed: `primary↔onPrimary`, `secondary↔onSecondary`,
   `error↔onError`, white card ↔ `onSurface`.

---

## 3. Typography

**Font: Poppins** — bundled at weights 400 (Regular), 500 (Medium),
600 (SemiBold), 700 (Bold). Declared in `pubspec.yaml`, set globally in
`theme.dart`. Never use another font family, and never a weight outside
400–700.

Access via `context.texts.<style>`; override with `.copyWith(...)` only for
color/decoration, not size.

### 3.1 Scale

| Style | Size / weight | Line height | Role |
|---|---|---|---|
| `displayLarge` | 52 / bold | default | Splash/hero brand title (welcome screen only). |
| `displaySmall` | 20 / w500 | default | **Page subtitle** — the friendly line under every `HTitle`. |
| `headlineLarge` | 42 / bold | 1.0 | **Page main title** (`HTitle` default) and big display values (invite code). |
| `headlineMedium` | 28 / bold | default | Section title inside a page ("Today's Tasks"). |
| `headlineSmall` | 24 / bold | default | Bottom-sheet / modal titles. |
| `titleLarge` | 16 / w500 | default | **App bar title** ("Homies."), user name on settings. |
| `titleMedium` | 16 / bold | default | *(defined, currently unused — reserve for 16px bold inline titles).* |
| `titleSmall` | 14 / w600 | default | **Input labels, inline error messages, banner text.** |
| `bodyLarge` | 16 / w400 | default | **Default body text**, input field content, hints, task text. |
| `bodyMedium` | 14 / w400 | default | *(defined, currently unused — reserve for dense secondary body text).* |
| `labelLarge` | 16 / w600 | default | **Button text** (`HButton`). |
| `labelMedium` | 14 / w600 | default | Small UI labels (calendar day letters). |

### 3.2 Rules

1. A page hierarchy is: `HTitle` (headlineLarge) → subtitle (displaySmall) →
   section titles (headlineMedium) → body (bodyLarge). Do not invent levels.
2. Input hints use `bodyLarge` **with the hint color override** (§2.2), not a
   smaller size.
3. Error messages are always `titleSmall` + `error` color.
4. Buttons are always `labelLarge`; never resize button text.
5. Multi-word H1s break with an explicit `\n` in the string
   ("Welcome\ninto Homies"), not automatic wrapping, so the break is witty.

---

## 4. Iconography

- **Package: `flutter_lucide`** (Lucide set). Icon identifiers are
  **snake_case** (`LucideIcons.list_todo`, `LucideIcons.user_round`).
- Material icons are only for system widgets that draw their own (e.g. the
  progress indicator); never pick a Material icon for UI semantics.
- Sizes: **24** is the default (inputs, buttons, tiles); **20** for compact
  spots (offline card, small icon buttons); **22** for the retry icon.
- Icon color follows the container's `on*` color.
- Icons in use today: `house`, `list_todo`, `calendar`, `wallet` (nav);
  `user_round`, `lock` (auth inputs); `eye` / `eye_closed` (obscure toggle);
  `trash`, `square_pen` (task actions); `plus` (new task); `wifi_off`,
  `cloud_off` (offline); `rotate_cw` (retry); `copy` (invite code).
  Stay within the Lucide style: 2px stroke, rounded caps, no filled icons.

---

## 5. Layout & spacing

**Base unit: 4.** Allowed steps: 4, 8, 12, 16, 24, 32, 36, 48, 80. If a value
isn't on this ladder, reconsider it.

| Distance | Value |
|---|---|
| Screen/page margin | **24** all sides (`EdgeInsets.all(24)`) |
| `HTitle` → subtitle | **12** |
| Subtitle → form/content block | **24** |
| Between input fields | **8** (plus each label's 2px bottom padding) |
| Primary button → secondary button | **12** |
| Between list tiles / cards | **12** |
| Section title → content (home) | **12** |
| H1 → content blocks (home) | **32–48** (roomier at the top of a page) |
| Card inner padding | **16** (offline card), **8** (week calendar), **2+ListTile** (task tile) |
| Bottom-sheet inner padding | `fromLTRB(24, 12, 24, 24)` |
| Icon → adjacent text inside a button | **8** |
| Small icon → text rows (offline card, invite) | **12** |

### 5.1 Page structure conventions

- **Tab pages** (home, todo): `Scaffold` with brand app bar, content
  `Column`, `HNavBar` as `bottomNavigationBar`. Content lists pad 24; the
  horizontal padding may sit on the inner `Column` (todo) or the `ListView`
  (home) — keep 24 either way.
- **Flow pages** (auth, create/join home): `SafeArea → Center →
  SingleChildScrollView(padding: 24) → Column(crossAxisAlignment:
  start, mainAxisAlignment: center)`. The form is vertically centered on
  large screens and scrolls on small ones.
- Full-width stretch: cards and buttons use `width: double.infinity`.

---

## 6. Elevation — the one shadow

Every floating element (buttons, cards, inputs, navbar, app bar) uses the
**same** soft shadow. This is the app's signature depth cue.

```dart
BoxShadow(
  color: context.colors.onSurface.withValues(alpha: 0.25),
  spreadRadius: 0,
  blurRadius: 2,
  offset: Offset(0, 1),
)
```

App bar equivalent:

```dart
AppBar(
  scrolledUnderElevation: 1,
  surfaceTintColor: context.colors.surface, // no M3 tint
  backgroundColor: context.colors.surface,
  shadowColor: context.colors.onSurface.withValues(alpha: 0.25),
)
```

Rules:
1. One shadow per element. No stacked shadows, no elevation numbers beyond
   this recipe.
2. Compact buttons inside another surface (nav items, `NewTaskTile`'s plus,
   sheet action squares) set `shadow: false`.
3. A shadow that gets clipped by rounded corners goes on an outer
   `Container` while the inner widget keeps the tap ripple (see the task
   tile's 2px-padding wrapper trick).

---

## 7. Shape / corner radius

| Radius | Used on |
|---|---|
| **8** | Small & icon buttons, nav item buttons, retry tap target |
| **12** | Calendar day cells |
| **16** | **Default**: cards, inputs, standard buttons, tap targets that wrap content |
| **24** (top corners only) | Bottom sheets: `BorderRadius.vertical(top: Radius.circular(24))` |
| **circle / square** | Checkbox is an 18px circle; avatar eyes are rounded squares (SVG) |

New element? Start at 16. Go to 8 only for compact controls, 24 only for
sheet-style surfaces. The navbar container itself is square (radius 0) — it
spans the screen edge-to-edge.

---

## 8. Component catalog

All shared UI lives in `lib/ui/components/` and is prefixed **`H`** with a
matching `h_*.dart` filename. Reuse these before building anything new.

### 8.1 `HButton` — the only button

Full-width by default (`width: double.infinity`), **48** tall, radius 16,
soft shadow, `TextButton` under the hood.

Key API: `text`, `icon`, `iconSize` (24), `color` *(required — variant is
explicit, not named)*, `textColor`, `width`, `height`, `borderRadius`,
`shadow`, `loading`, `loadingColor`, `onPressed`.

Behavior baked in — preserve it in any variant:
- **Unfocuses the keyboard** (`FocusScope.of(context).unfocus()`) before
  calling `onPressed`.
- `loading: true` swaps content for a 24×24 `CircularProgressIndicator`,
  strokeWidth 3, color `loadingColor ?? onPrimary`.
- Icon + text are centered in a row with an 8px gap.

Variants in use (copy these recipes):

| Variant | color / textColor | Other |
|---|---|---|
| Primary CTA | `primary` / `onPrimary` | defaults |
| Secondary / quiet CTA | `secondary` / `onSecondary` | defaults |
| Destructive CTA | `error` / `onError` | defaults |
| Sheet action square | `secondary` / `onSecondary` | `width: 48` (icon only) |
| Inline compact (e.g. add-task +) | `primary` | `width: 36, height: 36, borderRadius: 8, iconSize: 20, shadow: false` |
| Nav item | selected: `primary`/`onPrimary`, else `secondary`/`onSecondary` | `width: 80, borderRadius: 8, shadow: false`, icon only |

Async CTA pattern: `loading` replaces the button content — the button keeps
its size so the layout never jumps.

### 8.2 `HLabeledInput` — the only labeled text field

Anatomy, top to bottom:
1. Label: `titleSmall`, padding `EdgeInsets.only(left: 12, bottom: 2)` —
   optically aligned with the field's inner left padding.
2. `TextFormField`, min height 48, white fill (`surfaceContainer`), radius 16,
   the standard soft shadow (via `DecoratedInputBorder` wrapping an
   `OutlineInputBorder` with `borderSide: BorderSide.none`).
3. Prefix: Lucide icon, size 24, boxed in a 48×48 area with padding
   `left: 12, top: 12, bottom: 12, right: 4`.
4. Suffix (only when `obscurable`): a 48×48 `InkWell` (radius 16) with
   `eye` / `eye_closed`, shown only when the field has text.
5. Text and hint: `bodyLarge`; hint colored `onSecondary @ 0.6`.
6. Validation error: `titleSmall` + `error`; built-in validator rejects empty
   ("Cannot be empty.").
7. `contentPadding: EdgeInsets.only(left: 12)` and
   `textAlignVertical: TextAlignVertical.center`.

API: `label`, `hint`, `icon`, `controller`, `keyboardType`, `obscurable`.

Rules: use it for every form field; playful hints are part of the style
("Splarpo", "Pa$$w0rd"). For **borderless inline editing inside a card**
(New-task tile, task edit), use a raw `TextField` with `InputBorder.none` and
the same hint styling instead — that's the established pattern.

### 8.3 `HTitle` — the signature title

Bold text + a trailing yellow period, via `RichText`. Default style
`headlineLarge`; override with `style:` (app bar uses `titleLarge`, welcome
hero uses `displayLarge`). Never place a literal yellow dot in a string —
use `HTitle`. Never use a colon after a title.

### 8.4 `HNavBar` — bottom tab bar

- Exactly 4 tabs: Home `/` (`house`), Todo `/todo` (`list_todo`),
  Calendar `/calendar` (`calendar`), Wallet `/wallet` (`wallet`).
  Tab order and icons are fixed.
- White container (`surfaceContainer`) with the soft shadow, padding 12 all
  around, `SafeArea` inside, items spread `spaceEvenly`.
- Each item is an icon-only `HButton` (width 80, radius 8, no shadow);
  selected = `primary`/`onPrimary`, unselected = `secondary`/`onSecondary`.
- Pages pass their own `currentIndex`; navigation via `context.go`.

### 8.5 `HTaskTile` + `TaskSheet` — list item & its bottom sheet

Tile: white card, radius 16, soft shadow (2px outer padding so the ripple
clips correctly), `ListTile` with:
- Leading: 40px-wide tap area containing an **18px circular checkbox**
  (2px border; checked = `primary` fill + `primary` border, unchecked =
  `#AAAAAA` border, transparent fill). Tapping it toggles.
- Title: `bodyLarge`, single line, ellipsis. Completed → strikethrough +
  `onSurface @ 0.5`.
- Trailing: `HAvatar` (size 36) of the task's author.
- Tapping the body opens the **details bottom sheet** (§9.4), which hosts
  view / edit / delete-confirm as internal state of one sheet.

State pattern: toggle is **optimistic** — flip immediately, revert and show a
`SnackBar` on failure (`showTaskError`).

### 8.6 `HAvatar` — procedural face avatars

Renders an inline SVG (80×80 viewBox): colored circle + two rounded-square
eyes + a bezier mouth. Colors arrive from the API as hex strings **without**
`#`. Sizes in use: 36 (task tile), 40 (app bar), 60 (member row), 100
(default), 120 (settings). Fallback: `sadGrayAvatar` (gray `999` bg,
`424242` face, downward mouth) when `avatar` is null.

### 8.7 `HWeekCalendar`

White card, radius 16, soft shadow, padding 8; 7 day cells (M T W T F S S,
Monday-first) sized by `LayoutBuilder` with 8px spacing; selected cell =
`primary` bg + `onPrimary` `labelMedium` text, unselected = `surface` bg +
`onSecondary` text; cell radius 12.

### 8.8 `HOfflineCard` — offline / page-error banner

Red `#E94D4D` card, radius 16, soft shadow, padding 16, shown **under the
app bar** (outer padding `fromLTRB(24, 24, 24, 0)`), containing: leading icon
(20, white), message (`titleSmall`, white, `Expanded`), optional retry icon
(`rotate_cw`, 22, white, 8-radius tap target). Icons: `wifi_off` when the
device is offline, `cloud_off` for fetch errors.

### 8.9 `SettingsAvatarButton`

The user's `HAvatar` (40) as the app bar's only action, right padding 24,
taps to `/settings`. Shows the fallback avatar while loading, empty box on
error (with a `not_authenticated` self-refresh).

### 8.10 Guards (non-visual)

`AuthGuard` (session errors → `/welcome`) and `HomeGuard` (wraps AuthGuard;
`user_not_in_house` → `/create_home`). Wrap page bodies that require a
session/home. They listen and redirect; they don't render UI.

---

## 9. Page templates (recipes)

### 9.1 The brand app bar — every page has it

```dart
AppBar(
  title: HTitle(text: "Homies", style: context.texts.titleLarge),
  actions: const [SettingsAvatarButton()],   // only when logged in
  automaticallyImplyLeading: false,          // when there's no back target
  scrolledUnderElevation: 1,
  surfaceTintColor: context.colors.surface,
  backgroundColor: context.colors.surface,
  shadowColor: context.colors.onSurface.withValues(alpha: 0.25),
)
```

The app bar always says **"Homies."** — page identity lives in the body's
`HTitle`, not the app bar. `Scaffold.backgroundColor` is always `surface`.

### 9.2 Main tab page (home, todo, calendar, wallet)

```
Scaffold
 ├─ brand AppBar (+ avatar action)
 ├─ bottomNavigationBar: HNavBar(currentIndex: n)
 └─ body: Column
     ├─ if (offline || error) HOfflineCard  [padding fromLTRB(24,24,24,0)]
     └─ Expanded(
         RefreshIndicator(
           onRefresh: () => ref.refresh(provider.future),
           child: <content>.when(  // AsyncValue
             data:    ListView with AlwaysScrollableScrollPhysics, padding 24
             loading: Center(CircularProgressIndicator)
             error:   keep area scrollable-but-empty (the card reports it)
           )))
```

Pull-to-refresh must keep working in every state → error/empty bodies are
still scrollable `ListView`s with `AlwaysScrollableScrollPhysics`.

### 9.3 Flow / form page (register, login, create/join home, invite)

```
Scaffold(brand AppBar [+ avatar]) → SafeArea → Center → SingleChildScrollView(padding 24)
 └─ Column(start, center)
     ├─ HTitle(text: "...")            // headlineLarge, may contain \n
     ├─ SizedBox(12)
     ├─ Text(subtitle, displaySmall)
     ├─ SizedBox(24)
     ├─ HLabeledInput ...              // 8 between fields
     ├─ SizedBox(24)
     ├─ async.when(
     │    data:    HButton(primary CTA)
     │    loading: HButton(primary, loading: true)
     │    error:   [red titleSmall message, 24] + HButton("Try Again", primary))
     ├─ SizedBox(12)
     └─ HButton(secondary alternate CTA)   // "I already have an account", "Join a Home", "Cancel"
```

### 9.4 Bottom sheet / modal

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  backgroundColor: context.colors.surface,
  barrierColor: context.colors.onSurface.withAlpha(120),
  builder: (_) => ...,
)
```

Sheet body: `SafeArea → SingleChildScrollView(padding: bottom
viewInsets) → Padding(fromLTRB(24, 12, 24, 24))`. Title is `headlineSmall`.
Actions row: destructive `HButton` first, cancel/secondary second, 12px gaps,
`Expanded` for full-width text buttons.

Confirmation pattern (leave home, delete task): show the question
(`headlineSmall`, `\n` breaks allowed) → supporting line (`bodyLarge`) →
**destructive button on `error`, cancel on `secondary`**. While the async
action runs: swap to loading buttons, keep a faded cancel (`secondary
.withAlpha(120)`, no onTap), and block pop with `PopScope`.

### 9.5 Loading page

`Scaffold(surface bg) → Center → HTitle("Sto Caricando")` or a centered
`CircularProgressIndicator` inside content areas. *(The "Sto Caricando"
string is Italian — see §12.1.)*

---

## 10. State-handling patterns

These are part of the design: every async surface must handle all three
states.

1. **Riverpod `AsyncValue.when(data/loading/error)`** everywhere; pages also
   watch `connectivityProvider`.
2. **Buttons absorb loading**: `HButton(loading: true)` in place of the CTA —
   no separate spinners next to buttons.
3. **Form errors** render as `titleSmall` red text above the CTA, and the CTA
   relabels to **"Try Again"**.
4. **Page-level errors/offline** use the `HOfflineCard` recipe (§8.8); the
   content below stays interactive/scrollable.
5. **Optimistic updates** for snappy toggles (task complete), with revert +
   `SnackBar` on failure.
6. **`PopScope`** blocks back-navigation while a submit is in flight.
7. Redirects on auth/home state changes go through the guards / listeners
   (`ref.listen`), never inside `when(data:)` builders.
8. When a refresh is in flight, ignore the stale error the `AsyncValue`
   still carries (`isLoading ? null : error`).

---

## 11. Motion & feel

- **Bouncing scroll physics on all platforms** (`AppScrollBehavior` in
  `main.dart`). Don't override with clamping physics.
- **Pull-to-refresh everywhere** lists can go stale.
- **Ripples stay inside rounded shapes**: `InkWell`/`ListTile` get a matching
  `borderRadius`; if a shadow-clipped container eats the ripple, apply the
  outer-container wrapper trick (§6, rule 3).
- No animations beyond Material defaults today; if you add one, keep it
  short (≤ 200 ms), ease-out, and offset/opacity only.
- Tapping empty space dismisses the keyboard: pages wrap content in
  `GestureDetector(onTap: () => FocusScope.of(context).unfocus())`, and
  `HButton` unfocuses before firing.

---

## 12. Copy & tone

Language of the UI is **English** (code comments/notes may be Italian).

- Informal, warm, a little cheeky. Human words, not system words.
- Existing examples to match:
  - "You and your homies have never been so organized."
  - "Do you still remember your password?"
  - "First of all, let's choose a name"
  - "Do you know these folks?"
  - "This could be permanent, or it could be not. Who knows."
  - "They use this code to join!"
- **Button labels are Title Case and verb-first**: "Sign In", "Sign Up",
  "Try Again", "Share Link", "Confirm and Leave", "Mark as Incomplete",
  "Leave Home". The personal alternate-CTA buttons are the exception and read
  like a sentence: "I don't have an account", "I already have an account".
- Titles capitalize the major words ("Task's Details", "Today's Tasks",
  "Create a Home"); full questions read as sentences ("Are you sure you
  want to leave …?"). Never ALL CAPS.
- Hints are playful, not literal: "Splarpo", "Pa$$w0rd", "Gli Splarponi",
  "XXXXXX".
- Inline validation: "Cannot be empty."
- Brand is always written "Homies" — and as a title always via `HTitle`
  ("Homies.").

### 12.1 Known copy deviations (fix opportunistically)

- Loading page shows Italian "Sto Caricando".
- `Colors.grey` copy icon on the invite page instead of an `onSecondary`-tone
  token.

---

## 13. Naming & code conventions

- Shared UI components: `H` prefix + `h_snake_case.dart` (`HButton` →
  `h_button.dart`). Page-specific widgets may skip the prefix
  (`NewTaskTile`, `SettingsAvatarButton`, `TaskSheet`, guards).
- Always read theme via the extension: `context.colors`, `context.texts`
  (`lib/extensions/theme_extension.dart`).
- Keep layering per AGENTS.md: `data/ → providers/ → ui/{pages,components}`;
  a new reusable widget goes in `ui/components/` only when used by 2+ pages
  (or when it's clearly a design-system piece like an `H*` widget).
- Semicolon-terminated, brace-heavy style in Go doesn't apply here; match the
  surrounding Dart file.
- Run `flutter analyze` **and** `dart run custom_lint` before considering UI
  work done.

---

## 14. Checklist — adding a new element

Run through this before opening a PR/committing any new UI:

- [ ] Colors only from `context.colors` (new token → `theme.dart` first).
- [ ] Text styles only from `context.texts` (+ `copyWith` for color only).
- [ ] Icons only from `flutter_lucide`, size 24 (20 compact), snake_case.
- [ ] Radii ∈ {8, 12, 16, 24} — default 16.
- [ ] Spacing on the 4/8/12/16/24/32/48 ladder; screen margin 24.
- [ ] Floating surface = `surfaceContainer` + the standard soft shadow.
- [ ] Buttons = `HButton` variants; inputs = `HLabeledInput` / borderless
      `TextField` inside cards.
- [ ] Page: brand app bar "Homies." + `HTitle` in body + `surface` bg.
- [ ] All three async states handled (loading button, error text or
      `HOfflineCard`, data).
- [ ] Copy: playful English, Title Case verb-first buttons (§12).
- [ ] Bouncing physics; pull-to-refresh if the page shows fresh data.
- [ ] Keyboard dismissal on tap-outside / button press.
- [ ] Destructive actions confirm via the bottom-sheet recipe (§9.4).
- [ ] File name & class name follow §13; `flutter analyze` +
      `dart run custom_lint` pass.

---

## 15. Known design debt (do not copy, do not extend)

| Item | Where | Note |
|---|---|---|
| Two reds | `error #B94E4E` vs offline `#E94D4D` | Deliberate (banner is louder), but new destructive UI uses `error`. |
| `Colors.grey` icon | invite page copy icon | Should be an `onSecondary`-ish token. |
| Italian loading string | `loading_page.dart` | Should be English to match UI copy. |
| `titleMedium` / `bodyMedium` unused | `theme.dart` | Reserved; don't repurpose them for something off-scale. |
| Calendar & wallet pages empty | `ui/pages/` | Build them on the tab-page recipe (§9.2). |
| Welcome app bar unstyled | `welcome_page.dart` | Missing the full app bar styling set of §9.1. |

---

*Maintained alongside the code. When you change `theme.dart` or an `H*`
component, update the relevant section here in the same commit.*
