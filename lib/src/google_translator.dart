library google_transl;

import 'dart:async';
import 'dart:convert' show jsonDecode, jsonEncode, utf8;
import 'dart:io';

import './langs/language.dart';
import './tokens/google_token_generator.dart';
import 'enums/client_type.dart';
import 'enums/request_type.dart';
import 'exceptions/google_translator_exception.dart';
import 'exceptions/wrong_http_response_data_exception.dart';
import 'http_response_data.dart';

part './model/alternative_translation.dart';

part './model/definition.dart';

part './model/example.dart';

part './model/synonym.dart';

part './model/translation.dart';

///
/// This library is a Dart implementation of Google Translate API
///
/// [authors] Gabriel N. Pacheco
///
class GoogleTranslator {
  // faster than translate.google.com
  static const String defaultServerHost = 'translate.googleapis.com';
  static const String alternativeServerHost = 'translate.google.com';

  static const String autoLanguage = 'auto';

  final String serverHost;
  final ClientType clientType;

  static const _map = {
    RequestType.translation: 0,
    RequestType.alternativeTranslation: 5,
    RequestType.synonym: 11,
    RequestType.definition: 12,
    RequestType.example: 13,
  };

  static const String _translationUrlPath = '/translate_a/single';
  static const _pronounceUrlPath = '/translate_tts';
  static const List<String> _dataTypes = ['ex', 'ss', 'md', 'at', 't'];

  final _tokenProvider = GoogleTokenGenerator();
  final _languageList = LanguageList();

  /// allow to set base URL since for countries the default URL doesn't work
  GoogleTranslator({
    this.serverHost = defaultServerHost,
    this.clientType = ClientType.siteGT,
  });

  Future<Translation> getTranslation(
    String sourceText, {
    String from = autoLanguage,
    required String to,
  }) async {
    final HttpResponseData httpResponseData =
        await _getData(sourceText, from, to: to, dataType: 't');

    final jsonData = httpResponseData.jsonData;
    final sb = StringBuffer();
    try {
      final indexedData = jsonData[_map[RequestType.translation]];
      for (final i in indexedData) {
        sb.write(i[0]);
      }
    } catch (e) {
      _throwBadDataException(
        RequestType.translation,
        httpResponseData,
        innerException: e,
      );
    }
    final translated = sb.toString();
    return _Translation(
      translated,
      source: sourceText,
      sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  Future<AlternativeTranslation> getAltTranslation(
    String sourceText, {
    String from = autoLanguage,
    required String to,
  }) async {
    final HttpResponseData httpResponseData =
        await _getData(sourceText, from, to: to, dataType: 'at');
    final jsonData = httpResponseData.jsonData;
    final List<String> translations = [];
    try {
      final indexedData =
          jsonData[_map[RequestType.alternativeTranslation]][0][2];
      for (final i in indexedData) {
        final translation = i[0] as String;
        if (!translations.contains(translation)) translations.add(translation);
      }
    } catch (e) {
      _throwBadDataException(
        RequestType.alternativeTranslation,
        httpResponseData,
        innerException: e,
      );
    }

    return AlternativeTranslation(
      translations,
      source: sourceText,
      sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  Future<Definition> getDefinition(
    String sourceText, {
    String from = autoLanguage,
    String to = autoLanguage,
  }) async {
    final HttpResponseData httpResponseData = await _getData(
      sourceText,
      from,
      to: to,
      dataType: 'md',
    );

    final jsonData = httpResponseData.jsonData;
    final Map<String, List<String>> definitionsMap = <String, List<String>>{};
    try {
      final indexedData = jsonData[_map[RequestType.definition]];
      for (final i in indexedData) {
        final String title = i[0] as String;
        final List<String> definitions = [];
        final List inList = i[1] as List;
        for (final n in inList) {
          definitions.add(n[0] as String);
        }
        definitionsMap[title] = definitions;
      }
    } catch (e) {
      _throwBadDataException(
        RequestType.definition,
        httpResponseData,
        innerException: e,
      );
    }
    return Definition(
      definitionsMap,
      source: sourceText,
      sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  Future<Synonym> getSynonyms(
    String sourceText, {
    String from = autoLanguage,
  }) async {
    final HttpResponseData httpResponseData =
        await _getData(sourceText, from, dataType: 'ss');

    final jsonData = httpResponseData.jsonData;
    final List<String> filteredData = [];
    try {
      final indexedData = jsonData[_map[RequestType.synonym]];
      for (final i in indexedData) {
        for (final n in i[1]) {
          for (final t in n[0]) {
            filteredData.add(t as String);
          }
        }
      }
    } catch (e) {
      _throwBadDataException(
        RequestType.synonym,
        httpResponseData,
        innerException: e,
      );
    }
    filteredData.removeRange(5, filteredData.length);
    return Synonym(
      filteredData,
      source: sourceText,
      sourceLanguage: _languageList[from],
    );
  }

  Future<Example> getExamples(
    String sourceText, {
    String from = autoLanguage,
  }) async {
    final HttpResponseData httpResponseData =
        await _getData(sourceText, from, dataType: 'ex');

    final jsonData = httpResponseData.jsonData;
    final List<String> list = [];
    try {
      final indexedData = jsonData[_map[RequestType.example]];
      for (final i in indexedData[0]) {
        final String string = i[0] as String;
        list.add(string);
      }
    } catch (e) {
      _throwBadDataException(
        RequestType.example,
        httpResponseData,
        innerException: e,
      );
    }
    return Example(
      list,
      source: sourceText,
      sourceLanguage: _languageList[from],
    );
  }

  Future<Uri> getPronunciationUrl(
    String sourceText, {
    String from = autoLanguage,
    required String to,
  }) async =>
      Uri.https(
        serverHost,
        _pronounceUrlPath,
        await _getParameters(sourceText, from, to: to),
      );

  Future<HttpResponseData> _getData(
    String sourceText,
    String from, {
    String? to,
    String? dataType,
  }) async =>
      _call(
        'GET',
        (String responseBody, Uri uri) => HttpResponseData(
          jsonData: jsonDecode(responseBody),
          requestUrl: uri,
          sourceText: sourceText,
          sourceLanguage: _languageList[from].name,
          targetLanguage: to == null ? null : _languageList[to].name,
        ),
        urlPath: _translationUrlPath,
        queryParameters: await _getParameters(
          sourceText,
          from,
          to: to,
          dataType: dataType,
        ),
      );

  Future<Map<String, String>> _getParameters(
    String sourceText,
    String from, {
    String? to,
    String? dataType,
  }) async {
    if (!LanguageList.contains(from)) {
      throw LanguageNotSupportedException(from);
    }

    if (to != null && !LanguageList.contains(to)) {
      throw LanguageNotSupportedException(to);
    }

    final Map<String, String> parameters = {
      'client': clientType == ClientType.siteGT ? 't' : 'gtx',
      'ie': 'UTF-8',
      'q': sourceText,
      'tk': _tokenProvider.generateToken(sourceText),
      if (to != null) 'tl': to,
    };

    if (dataType == null) {
      parameters.addAll({
        'total': '1',
        'idx': '0',
        'textlen': '${sourceText.length}',
        'hint': from,
      });
    } else if (_dataTypes.any((dt) => dt == dataType)) {
      parameters.addAll({
        'sl': from,
        if (to != null) 'hl': to,
        'dt': dataType,
        'oe': 'UTF-8',
        'otf': '1',
        'ssel': '0',
        'tsel': '0',
        'kc': '7',
      });
    } else {
      throw GoogleTranslatorException(
        "Passed data type '$dataType' is unknown or"
        ' incorrect\n${StackTrace.current}',
      );
    }

    return parameters;
  }

  Future<T> _call<T>(
    String method,
    T Function(String, Uri) convert, {
    required String urlPath,
    Object? payLoad,
    Map<String, String>? queryParameters,
  }) async {
    final client = HttpClient();

    queryParameters?.removeWhere((key, value) => value == 'null');

    final uri = Uri.https(serverHost, urlPath, queryParameters);
    print('$uri');
    return client.openUrl(method, uri).then((request) {
      if (payLoad != null) request.write(jsonEncode(payLoad));

      return request.close();
    }).then((response) {
      switch (response.statusCode) {
        case 200:
          final completer = Completer<String>();
          final contents = StringBuffer();
          response.transform(utf8.decoder).listen(
              (data) => contents.write(data),
              onDone: () => completer.complete(contents.toString()));
          return completer.future;
        default:
          print('$uri: ${response.statusCode} ${response.reasonPhrase}');
          throw GoogleTranslatorException(
              '$serverHost returned ${response.statusCode} ${response.reasonPhrase}');
      }
    }).then((responseBody) => convert(responseBody, uri));
  }

  void _throwBadDataException(
    RequestType requestType,
    HttpResponseData httpResponseData, {
    dynamic innerException,
  }) =>
      throw WrongHttpResponseDataException(
        "Wrong HTTP response on ${requestType.name} request\n"
        "$innerException\n",
        httpResponseData,
      );
}
