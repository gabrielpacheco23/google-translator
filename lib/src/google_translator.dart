library google_transl;

import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import './tokens/google_token_gen.dart';
import './langs/language.dart';

part './model/translation.dart';
part './model/definition.dart';
part './model/synonym.dart';
part './model/example.dart';
part './model/alternative_translation.dart';
part 'exception.dart';
part 'http_response_data.dart';

///
/// This library is a Dart implementation of Google Translate API
///
/// [author] Gabriel N. Pacheco.
///
class GoogleTranslator {
  var _baseUrl = 'translate.googleapis.com'; // faster than translate.google.com
  final _path = '/translate_a/single';
  final _pronouncePath = '/translate_tts';
  final _tokenProvider = GoogleTokenGenerator();
  final _languageList = LanguageList();
  final ClientType client;
  final List<String> _dataTypes = ['ex', 'ss', 'md', 'at', 't'];

  GoogleTranslator({this.client = ClientType.siteGT});

  Future<Translation> translate(String sourceText,
      {String from = 'auto', String to = 'en'}) async {
    final HttpResponseData httpResponseData =
        await _getData(sourceText, from: from, to: to, dataType: 't');

    final jsonData = httpResponseData.jsonData;
    final sb = StringBuffer();

    for (final i in jsonData[0]) {
      sb.write(i[0]);
    }
    final translated = sb.toString();
    return _Translation(
      translated,
      source: sourceText,
      sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  Future<AlternativeTranslation> getAltTranslation(String sourceText,
      {String from = 'auto', String to = 'en'}) async {
    final HttpResponseData httpResponseData =
        await _getData(sourceText, from: from, to: to, dataType: 'at');

    final jsonData = httpResponseData.jsonData;

    final indexedData = jsonData[5][0][2];

    if (indexedData == null) {
      _throwException(5, httpResponseData);
    }

    final List<String> words = [];

    for (final i in indexedData) {
      words.add(i[0]);
    }

    return AlternativeTranslation(
      words,
      source: sourceText,
      sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  Future<Definition> getDefinition(String sourceText,
      {String from = 'auto', String to = 'en'}) async {
    final HttpResponseData httpResponseData =
        await _getData(sourceText, from: from, to: to, dataType: 'md');

    final jsonData = httpResponseData.jsonData;

    if (jsonData.length < 12 || jsonData[12] == null) {
      _throwException(12, httpResponseData);
    }

    final indexedData = jsonData[12];

    Map<String, List<String>> definitionsMap = {};

    for (final i in indexedData) {
      String title = i[0];
      List<String> definitions = [];
      List inList = i[1];
      for (final n in inList) {
        definitions.add(n[0]);
      }
      definitionsMap[title] = definitions;
    }
    return Definition(
      definitionsMap,
      source: sourceText,
      sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  Future<Synonym> getSynonyms(String sourceText,
      {String from = 'auto', String to = 'en'}) async {
    final HttpResponseData httpResponseData =
        await _getData(sourceText, from: from, to: to, dataType: 'ss');

    final jsonData = httpResponseData.jsonData;

    if (jsonData.length < 11) {
      _throwException(11, httpResponseData);
    }

    final indexedData = jsonData[11];

    List<String> filteredData = [];

    for (final i in indexedData) {
      for (final n in i[1]) {
        for (final t in n[0]) {
          filteredData.add(t);
        }
      }
    }
    filteredData.removeRange(5, filteredData.length);
    return Synonym(
      filteredData,
      source: sourceText,
      targetLanguage: _languageList[to],
      sourceLanguage: _languageList[from],
    );
  }

  Future<Example> getExamples(String sourceText,
      {String from = 'auto', String to = 'en'}) async {
    final HttpResponseData httpResponseData =
        await _getData(sourceText, from: from, to: to, dataType: 'ex');

    final jsonData = httpResponseData.jsonData;

    if (jsonData.length < 13) {
      _throwException(13, httpResponseData);
    }

    final indexedData = jsonData[13];

    List<String> list = [];
    for (final i in indexedData[0]) {
      String string = i[0];
      list.add(string);
    }
    return Example(
      list,
      source: sourceText,
      sourceLanguage: _languageList[from],
      targetLanguage: _languageList[to],
    );
  }

  Future<Uri> getPronunciationUrl(String sourceText,
      {String from = 'auto', String to = 'en'}) async {
    final Map<String, String> parameters =
        await _getParameters(sourceText, from: from, to: to);

    final url = Uri.https(_baseUrl, _pronouncePath, parameters);
    return url;
  }

  /// Translates and prints directly
  void translateAndPrint(String text,
      {String from = 'auto', String to = 'en'}) {
    translate(text, from: from, to: to).then(print);
  }

  /// Sets base URL for countries that default URL doesn't work
  void set baseUrl(String url) => _baseUrl = url;

  Future<HttpResponseData> _getData(String sourceText,
      {String from, String to, String dataType}) async {
    final Map<String, String> parameters = await _getParameters(sourceText,
        from: from, to: to, dataType: dataType);

    final url = Uri.https(_baseUrl, _path, parameters);
    final data = await http.get(url);

    if (data.statusCode != 200)
      throw http.ClientException('Error ${data.statusCode}: ${data.body}', url);

    final jsonData = jsonDecode(data.body);

    return HttpResponseData(
      jsonData: jsonData,
      requestUrl: url,
      sourceText: sourceText,
      sourceLanguage: _languageList[from].name,
      targetLanguage: _languageList[to].name,
    );
  }

  Future<Map<String, String>> _getParameters(String sourceText,
      {String from, String to, String dataType}) async {
    for (var each in [from, to]) {
      if (!LanguageList.contains(each)) {
        throw LanguageNotSupportedException(each);
      }
    }

    final Map<String, String> parameters = {
      'client': client == ClientType.siteGT ? 't' : 'gtx',
      'ie': 'UTF-8',
      'q': sourceText,
      'tk': _tokenProvider.generateToken(sourceText),
      'tl': to,
    };

    if (dataType == null) {
      parameters.addAll({
        'total': '1',
        'idx': '0',
        'textlen': '${sourceText.length}',
        'hint': from,
      });
    } else if (_dataTypes.any((element) => element == dataType)) {
      parameters.addAll({
        'sl': from,
        'hl': to,
        'dt': dataType,
        'oe': 'UTF-8',
        'otf': '1',
        'ssel': '0',
        'tsel': '0',
        'kc': '7',
      });
    } else {
      throw UnknownDataTypeException(
        'Passed data type is unknown or incorrect',
      );
    }

    return parameters;
  }

  WrongHttpResponseDataException _throwException(
      int index, HttpResponseData httpResponseData) {
    throw WrongHttpResponseDataException(
      "Wrong HTTP response data at index $index",
      httpResponseData,
    );
  }
}

enum ClientType {
  siteGT, // t
  extensionGT, // gtx (blocking ip sometimes)
}
