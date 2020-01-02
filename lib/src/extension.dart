import 'package:translator/src/google_translator.dart';

extension StringExtension on String {

    Future<String> translate({String from = 'auto', String to = 'en'}) async => await GoogleTranslator().translate(this, from: from, to: to);

}