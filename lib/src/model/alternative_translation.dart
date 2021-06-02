part of google_transl;

class AlternativeTranslation {
  final List<String> words;
  final String source;
  final Language targetLanguage;
  final Language sourceLanguage;

  AlternativeTranslation(
    this.words, {
    required this.source,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}
