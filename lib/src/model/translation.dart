part of google_transl;

/// Translation returned from GoogleTranslator.translate method, containing the translated text, the source text, the translated language and the source language
abstract class Translation {
  final String text;
  final String source;
  final Language targetLanguage;
  final Language sourceLanguage;

  Translation._(
    this.text,
    this.source,
    this.sourceLanguage,
    this.targetLanguage,
  );

  String operator +(other);

  @override
  String toString() => text;
}

class _Translation extends Translation {
  final String text;
  final String source;
  final Language sourceLanguage;
  final Language targetLanguage;

  _Translation(
    this.text, {
    this.sourceLanguage,
    this.targetLanguage,
    this.source,
  }) : super._(text, source, sourceLanguage, targetLanguage);

  String operator +(other) => this.toString() + other.toString();
}
