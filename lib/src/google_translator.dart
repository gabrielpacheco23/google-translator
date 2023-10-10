library google_transl;

import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'dart:io';
import './tokens/google_token_gen.dart';
import './langs/language.dart';

part './model/translation.dart';

/// This library is a Dart implementation of Google Translate API
///
/// [author] Gabriel N. Pacheco.
class GoogleTranslator {
  var _baseUrl = 'translate.googleapis.com'; // faster than translate.google.com
  final _path = '/translate_a/single';
  final _tokenProvider = GoogleTokenGenerator();
  final _languageList = LanguageList();
  final ClientType client;

  GoogleTranslator({this.client = ClientType.siteGT});

  /// Translates texts from specified language to another
  Future<Translation> translate(String sourceText,
      {String from = 'auto', String to = 'en'}) async {
    for (var each in [from, to]) {
      if (!LanguageList.contains(each)) {
        throw LanguageNotSupportedException(each);
      }
    }

    final parameters = {
      'client': client == ClientType.siteGT ? 't' : 'gtx',
      'sl': from,
      'tl': to,
      'hl': to,
      'dt': 't',
      'ie': 'UTF-8',
      'oe': 'UTF-8',
      'otf': '1',
      'ssel': '0',
      'tsel': '0',
      'kc': '7',
      'tk': _tokenProvider.generateToken(sourceText),
      'q': sourceText
    };

    var _client = HttpClient();

    try {
      var url = Uri.https(_baseUrl, _path, parameters);
      final request = await _client.getUrl(url);
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        throw HttpException('Error ${response.statusCode}: $responseBody',
            uri: url);
      }

      final jsonData = jsonDecode(responseBody);

      if (jsonData == null) {
        throw HttpException('Error: Can\'t parse json data');
      }

      final sb = StringBuffer();

      for (var c = 0; c < jsonData[0].length; c++) {
        sb.write(jsonData[0][c][0]);
      }

      if (from == 'auto' && from != to) {
        from = jsonData[2] ?? from;
        if (from == to) {
          from = 'auto';
        }
      }

      final translated = sb.toString();
      return _Translation(
        translated,
        source: sourceText,
        sourceLanguage: _languageList[from],
        targetLanguage: _languageList[to],
      );
    } finally {
      _client.close();
    }
  }

  /// Translates and prints directly
  void translateAndPrint(String text,
      {String from = 'auto', String to = 'en'}) {
    translate(text, from: from, to: to).then(print);
  }

  /// Sets base URL for countries that default URL doesn't work
  set baseUrl(String url) => _baseUrl = url;
}

enum ClientType {
  siteGT, // t
  extensionGT, // gtx (blocking ip sometimes)
}
