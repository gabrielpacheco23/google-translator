library google_transl;

import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:translator/src/model/cloud_translation_api_dto.dart';
import './tokens/google_token_gen.dart';
import './langs/language.dart';

part './model/translation.dart';

///
/// This library is a Dart implementation of Google Translate API
///
/// [author] Gabriel N. Pacheco.
///
class GoogleTranslator {
  var _baseUrl = 'translate.googleapis.com'; // faster than translate.google.com
  final _path = '/translate_a/single';
  final _withKeyPath = '/language/translate/v2';
  final _tokenProvider = GoogleTokenGenerator();
  final _languageList = LanguageList();
  final ClientType client;
  String? apiKey;

  GoogleTranslator({this.client = ClientType.siteGT, this.apiKey});

  /// Translates texts from specified language to another
  Future<Translation> translate(String sourceText,
      {String from = 'auto', String to = 'en'}) async {
    for (var each in [from, to]) {
      if (!LanguageList.contains(each)) {
        throw LanguageNotSupportedException(each);
      }
    }
    Translation translation;
    if (apiKey != null) {
      translation = await _translateWithKey(sourceText, to);
    } else {
      translation = await _translateFree(sourceText, from, to);
    }
    return translation;
  }

  Future<Translation> _translateWithKey(String sourceText, String to) async {
    final parameters = {
      'target': to,
      'key': apiKey,
      'q': sourceText,
    };

    var url = Uri.https(_baseUrl, _withKeyPath, parameters);
    final data = await http.get(url);

    if (data.statusCode != 200) {
      throw http.ClientException('Error ${data.statusCode}: ${data.body}', url);
    }
    final jsonData = jsonDecode(data.body);

    if (jsonData == null ||
        jsonData['data'] == null ||
        jsonData['data']['translations'] == null) {
      throw http.ClientException('Error: Can\'t parse json data');
    }
    CloudTranslationApiDto translationApiDto =
        CloudTranslationApiDto.fromJson(jsonData);
    var trans = translationApiDto.data!.translations![0];
    return _Translation(
      trans.translatedText ?? "",
      source: sourceText,
      sourceLanguage: _languageList['en'],
      targetLanguage: trans.detectedSourceLanguage == null
          ? _languageList[to]
          : _languageList[trans.detectedSourceLanguage ?? to],
    );
  }

  Future<Translation> _translateFree(
      String sourceText, String from, String to) async {
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

    var url = Uri.https(_baseUrl, _path, parameters);
    final data = await http.get(url);

    if (data.statusCode != 200) {
      throw http.ClientException('Error ${data.statusCode}: ${data.body}', url);
    }

    final jsonData = jsonDecode(data.body);
    if (jsonData == null) {
      throw http.ClientException('Error: Can\'t parse json data');
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
