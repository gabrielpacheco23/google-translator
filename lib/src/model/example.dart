part of google_transl;

class Example {
  final List<String> examples;
  final String source;
  final Language sourceLanguage;

  Example(
    this.examples, {
    required this.source,
    required this.sourceLanguage,
  });
}
