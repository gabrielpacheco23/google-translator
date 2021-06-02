part of google_transl;

class Synonym {
  final List<String> synonyms;
  final String source;
  final Language targetLanguage;
  final Language sourceLanguage;

  Synonym(
    this.synonyms, {
    required this.source,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}
