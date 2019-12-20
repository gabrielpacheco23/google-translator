import 'dart:async';
import 'dart:convert' show jsonDecode;
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

  var _baseUrl = 'https://translate.googleapis.com/translate_a/single';
  TokenProviderInterface tokenProvider;

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
      var str = '';
      parameters.forEach((key, value) {
        if (key == 'q') {
          str += (key + '=' + value);
          return;
        }
        str += (key + '=' + value + '&');
      });

      String url = _baseUrl + '?' + str;

      /// Fetch and parse data from Google Transl. API
      final data = await http.get(url);
      if (data.statusCode != 200) {
        print(data.statusCode);
        return null;
      }

      final jsonData = jsonDecode(data.body);

      final sb = StringBuffer();
      for (int c = 0; c < jsonData[0].length; c++) {
        sb.write(jsonData[0][c][0]);
      }

      return sb.toString();
    } on Error catch (err) {
      print("Error: " + err.toString() + "\n" + err.stackTrace.toString());
      return null;
    }
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
