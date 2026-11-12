# AGENTS.md — homies-app

Flutter client for the Homies app. Backend lives in the sibling repo `../homies-api` (Go + PostgreSQL, run with `docker compose up -d --build`); auth logic is there, not in `../homies-auth`. Remote: `zibbadies/homies-app`. No CI, no git tags, no codegen (no build_runner — Riverpod providers are hand-written).

## Commands

- `flutter pub get`, then `flutter analyze` and `dart run custom_lint` — the `custom_lint` plugin is enabled in `analysis_options.yaml`, so `flutter analyze` alone does not run all rules.
- `flutter test` currently **fails**: `test/widget_test.dart` is the stale default counter test and doesn't match the app (no `ProviderScope`, no counter). Known broken — don't debug it as a regression; fix or ignore deliberately.
- Run against different backends via `--dart-define`:
  - Android emulator: `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080`
  - Desktop/web: `flutter run --dart-define=API_BASE_URL=http://localhost:8080`
  - Release: `flutter build apk --release --dart-define=API_BASE_URL=https://homies.sgrodolix.website`
- Default (no define) is a hardcoded LAN IP in `lib/services/app_config.dart` — update it if the dev PC's address changes.
- Cleartext HTTP is allowed only in debug builds via `android/app/src/debug/AndroidManifest.xml` (`usesCleartextTraffic`); release builds must use HTTPS.

## Structure & conventions

- Entry: `lib/main.dart` → `ProviderScope` + `MaterialApp.router` (go_router config in `lib/providers/router_provider.dart`, guards in `lib/ui/components/{auth_guard,home_guard}.dart`).
- Layers under `lib/`: `data/sources` (raw Dio API calls) → `data/repos` → `providers` (Riverpod) → `ui/{pages,components}`; plus `services/`, `utils/`, `extensions/`. Keep new code in the matching layer.
- All API calls go through the shared Dio client (`lib/services/dio_client.dart` / `providers/dio_provider.dart`) and errors are normalized via `handleDioRequest` (`lib/utils/handle_request.dart`) into `ErrorWithCode` — follow this pattern instead of catching `DioException` ad hoc.
- Tokens live in `flutter_secure_storage` (`lib/services/storage_service.dart`).
- Custom widgets are prefixed `h_` (`h_button.dart`, `h_navbar.dart`, ...); app theme in `lib/ui/theme.dart` with the Poppins font.
- `doc.md` is the Italian API contract for the lists/items endpoints — keep it in sync when `homies-api` routes change. Much project documentation is in Italian; matching that language in docs/comments is fine.
- `build/` is generated output; never edit or commit it.
