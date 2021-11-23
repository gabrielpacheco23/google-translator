part of google_transl;

class AlternativeTranslation {
  final List<String> translations;
  final String source;
  final Language targetLanguage;
  final Language sourceLanguage;

  AlternativeTranslation(
    this.translations, {
    required this.source,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}
