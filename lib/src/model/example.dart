part of google_transl;

class Example {
  final List<String> examples;
  final String source;
  final Language targetLanguage;
  final Language sourceLanguage;

  Example(this.examples,
      {this.source, this.sourceLanguage, this.targetLanguage});
}
