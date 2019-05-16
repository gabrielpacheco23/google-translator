import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:translator/src/langs/languages.dart';
import './tokens/token_provider_interface.dart';
import './tokens/google_token_gen.dart';

///
/// This library is a Dart implementation of Free Google Translate API
/// based on JavaScript and PHP Free Google Translate APIs
///
/// [author] Gabriel N. Pacheco.
///
class GoogleTranslator {
  GoogleTranslator();

  var _baseUrl = "https://translate.googleapis.com/translate_a/single";
  TokenProviderInterface tokenProvider;

  String _translatedText;
  String _fromLanguageCode;

  /// Translates texts from specified language to another
  Future<String> translate(String sourceText,
      {String from = 'auto', String to = 'en'}) async {
    /// Assertion for supported language
    [from, to].forEach((language) {
      assert(Languages.isSupported(language),
          "\n\/E:\t\tError -> Not a supported language: '$language'");
    });

    /// New tokenProvider -> uses GoogleTokenGenerator for free API
    tokenProvider = GoogleTokenGenerator();
    try {
      var parameters = {
        'client': 't',
        'sl': from,
        'tl': to,
        'dt': 't',
        'ie': 'UTF-8',
        'oe': 'UTF-8',
        'tk': tokenProvider.generateToken(sourceText),
        'q': sourceText
      };

      /// Append parameters in url
      String str = "";
      parameters.forEach((key, value) {
        if (key == 'q') {
          str += (key + "=" + value);
          return;
        }
        str += (key + "=" + value + "&");
      });

      String url = _baseUrl + '?' + str;

      /// Fetch and parse data from Google Transl. API
      var data = await http.get(url);
      if (data.statusCode != 200) {
        print(data.statusCode);
        return null;
      }
      var t = [];

      /// Separate translated text from data
      var regex = RegExp(r'\B"[^"]*"\B');
      Iterable<Match> matches = regex.allMatches(data.body);
      matches.forEach((match) {
        t.add(match.group(0));
      });

      /// Get source text language ISO Code
      _fromLanguageCode = t[t.length - 1];

      /// Reorganize translated strings
      String res = "";
      int i = 0;
      t.forEach((x) {
        if (i.isEven) res += x;
        i++;
      });

      /// Reformats and returns translated text
      _translatedText = _reformat(res, sourceText, _fromLanguageCode);
      return _translatedText;
    } on Error catch (err) {
      print("Error: " + err.toString() + "\n" + err.stackTrace.toString());
      return null;
    }
  }

  String _reformat(String str, String sourceText, String isoCode) {
    String res = str
        .replaceAll(isoCode, "")
        .replaceAll(r'"', "")
        .replaceAll(r'[[\\(^null$)]', "")
        .replaceAll(r'\n', "\n");
    return res;
  }

  /// Translates and prints directly
  translateAndPrint(String text, {String from = 'auto', String to = 'en'}) {
    translate(text, from: from, to: to).then((s) {
      print(s);
    });
  }

  /// Sets base URL for countries that default url doesn't work
  void set baseUrl(var base) => _baseUrl = base;
}
