/// Configurazione dell'app.
///
/// L'API base URL si può sovrascrivere a compile-time con `--dart-define`:
///
/// ```sh
/// # device fisico sulla stessa rete del PC (default)
/// flutter run
///
/// # emulatore Android
/// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
///
/// # desktop / web
/// flutter run --dart-define=API_BASE_URL=http://localhost:8080
///
/// # production (build release)
/// flutter build apk --release --dart-define=API_BASE_URL=https://homies.sgrodolix.website
/// ```
///
/// Nota: il default è l'IP LAN del dev-server, va aggiornato se il PC
/// cambia indirizzo (vedere `ip addr`).
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.178.107:8080',
  );
}
