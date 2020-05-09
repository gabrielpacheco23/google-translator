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
  /// use memory cache?
  final bool useCache;
  final ClientType client;

  /// null or 0 for cache all strings
  final int maxLengthCache;
  GoogleTranslator({
    this.useCache = true,
    this.maxLengthCache,
    this.client = ClientType.siteGT,
  });

  final _cache = Map<String, String>();
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
    final key = '$from$to$sourceText';
    if (useCache == true && _cache.containsKey('$from$to$sourceText')) {
      return _cache[key];
    }

    /// New tokenProvider -> uses GoogleTokenGenerator for free API
    tokenProvider = GoogleTokenGenerator();
    try {
      var parameters = {
        'client': client == ClientType.siteGT ? 't' : 'gtx',
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
          str += ('$key=${Uri.encodeComponent(value)}');
          return;
        }
        str += ('$key=${Uri.encodeComponent(value)}&');
      });

      final url = '$_baseUrl?$str';

      /// Fetch and parse data from Google Transl. API
      final data = await http.get(url);
      if (data.statusCode != 200) {
        print(data.statusCode);
        return null;
      }

      final jsonData = jsonDecode(data.body);

      final sb = StringBuffer();
      for (var c = 0; c < jsonData[0].length; c++) {
        sb.write(jsonData[0][c][0]);
      }

      final result = sb.toString();
      if (useCache == true &&
          (maxLengthCache == null ||
              maxLengthCache == 0 ||
              result.length <= maxLengthCache)) {
        _cache[key] = result;
      }
      return result;
    } on Error catch (err) {
      print('Error: $err\n${err.stackTrace}');
      return null;
    }
  }

  /// Translates and prints directly
  void translateAndPrint(String text,
      {String from = 'auto', String to = 'en'}) {
    translate(text, from: from, to: to).then((s) {
      print(s);
    });
  }

  /// Sets base URL for countries that default url doesn't work
  void set baseUrl(var base) => _baseUrl = base;
}

enum ClientType {
  /// extension Google Translate
  extensionGT,
  /// site Google Translate
  siteGT,
}
