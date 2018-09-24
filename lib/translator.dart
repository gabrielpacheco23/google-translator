library translator;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:translator/langs/languages.dart';
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

  /// [vars] _baseUrl -> API endpoint used to get translations
  /// [vars] _translatedText -> Return string translated source text
  /// [vars] _fromLanguageCode -> Source 'from' language ISO code for reformating response string
  ///
  var _baseUrl = "https://translate.googleapis.com/translate_a/single";
  TokenProviderInterface tokenProvider;

  String _translatedText;
  String _fromLanguageCode;

  /// Main async translate
  /// [method] returns [Future] -> [String] translated text \
  /// [params] sourceText -> Source text to be translated [String] \
  /// [params] {from} -> Language source text from [String] default = 'auto' \
  /// [params] {to} -> Language to be translated to [String] default = 'en' (english)
  ///
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
      /// Parameters appended to url string
      /// sl -> source language
      /// tl -> translate language
      /// tk -> token generated
      /// q -> string to be translated (source text)
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

      /// (GET) Fetch and parse data from Google Transl. API
      var data = await http.get(url);
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
      _translatedText = reformat(res, sourceText, _fromLanguageCode);
      return _translatedText;
    } on Error catch (err) {
      print("Error: " + err.toString() + "\n" + err.stackTrace.toString());
      return null;
    }
  }

  /// Replace not used in translated text regexps
  String reformat(String str, String sourceText, String isoCode) {
    String res = str
        .replaceAll(isoCode, "")
        .replaceAll(r'"', "")
        .replaceAll(r'[[\\(^null$)]', "");
    return res;
  }

  /// Translate and prints source text directly
  translateAndPrint(String text, {String from = 'auto', String to = 'en'}) {
    translate(text, from: from, to: to).then((s) {
      print(s);
    });
  }

  /// Sets base URL for countries that default url doesn't work
  void set baseUrl(var base) => _baseUrl = base;
}
