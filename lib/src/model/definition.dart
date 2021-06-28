part of google_transl;

class Definition {
  final Map<String, List<String>> definitions;
  final String source;
  final Language sourceLanguage;
  final Language targetLanguage;

  Definition(
    this.definitions, {
    required this.source,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}
