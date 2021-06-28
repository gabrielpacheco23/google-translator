part of google_transl;

class Synonym {
  final List<String> synonyms;
  final String source;
  final Language sourceLanguage;

  Synonym(
    this.synonyms, {
    required this.source,
    required this.sourceLanguage,
  });
}
