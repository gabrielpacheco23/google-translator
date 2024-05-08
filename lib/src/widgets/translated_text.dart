import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslatedText extends StatefulWidget {
  /// The text to be translated.
  final String text;

  /// The language code to translate from, default is 'auto' which means automatic language detection.
  final String from;

  /// The language code to translate to, default is 'en' which means English.
  final String to;

  /// A text to be displayed while the translation is in progress.
  final String? loadingText;

  /// The style to use for the text.
  final TextStyle? style;

  /// A Text widget that utilizes `GoogleTranslator.translate()` method to use the package directly in the UI as a replacement for `Text` widget.
  const TranslatedText(
    this.text, {
    super.key,
    this.from = 'auto',
    this.to = 'en',
    this.loadingText,
    this.style,
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String? _translatedText;

  @override
  void initState() {
    GoogleTranslator()
        .translate(widget.text, from: widget.from, to: widget.to)
        .then((value) => setState(() => _translatedText = value.text));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _translatedText ?? widget.loadingText ?? widget.text,
      style: widget.style,
    );
  }
}
