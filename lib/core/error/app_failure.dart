/// Base sealed class for all application failures.
///
/// Each failure type corresponds to a specific error scenario,
/// allowing the UI layer to render appropriate error states.
sealed class AppFailure {
  const AppFailure();
}

/// Failures originating from network requests.
class NetworkFailure extends AppFailure {
  final String message;
  final int? statusCode;

  const NetworkFailure({required this.message, this.statusCode});

  @override
  String toString() => 'NetworkFailure($statusCode): $message';
}

/// Failures originating from the local database (Drift/SQLite).
class DatabaseFailure extends AppFailure {
  final String message;

  const DatabaseFailure({required this.message});

  @override
  String toString() => 'DatabaseFailure: $message';
}

/// Failures originating from the audio playback system.
class AudioFailure extends AppFailure {
  final String message;

  const AudioFailure({required this.message});

  @override
  String toString() => 'AudioFailure: $message';
}

/// Failures related to file system or storage access.
class StorageFailure extends AppFailure {
  final String message;

  const StorageFailure({required this.message});

  @override
  String toString() => 'StorageFailure: $message';
}

/// Failures related to missing or denied permissions.
class PermissionFailure extends AppFailure {
  final String message;

  const PermissionFailure({required this.message});

  @override
  String toString() => 'PermissionFailure: $message';
}

/// A generic, unexpected failure.
class UnexpectedFailure extends AppFailure {
  final String message;

  const UnexpectedFailure({required this.message});

  @override
  String toString() => 'UnexpectedFailure: $message';
}
