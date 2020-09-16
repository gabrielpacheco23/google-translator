part of google_transl;

class Definition {
  final Map<String, List<String>> definitions;
  final String source;
  final Language targetLanguage;
  final Language sourceLanguage;

  Definition(this.definitions,
      {this.source, this.sourceLanguage, this.targetLanguage});
}
