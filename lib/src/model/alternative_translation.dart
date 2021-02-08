part of google_transl;

class AlternativeTranslation {
  final List<String> words;
  final String source;
  final Language targetLanguage;
  final Language sourceLanguage;

  AlternativeTranslation(this.words,
      {this.source, this.sourceLanguage, this.targetLanguage});
}
