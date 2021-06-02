part of google_transl;

class Definition {
  final Map<String, List<String>> definitions;
  final String source;
  final Language targetLanguage;
  final Language sourceLanguage;

  Definition(
    this.definitions, {
    required this.source,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}
