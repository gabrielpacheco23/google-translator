class GoogleTranslatorException implements Exception {
  final String message;

  GoogleTranslatorException(this.message);

  @override
  String toString() => message;
}