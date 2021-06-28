part of google_transl;

class HttpResponseData {
  final dynamic jsonData;
  final Uri requestUrl;
  final String sourceText;
  final String sourceLanguage;
  final String? targetLanguage;

  HttpResponseData({
    this.jsonData,
    required this.requestUrl,
    required this.sourceText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  @override
  String toString() {
    return "{\n   jsonData: $jsonData,\n"
        "   requestUrl: $requestUrl,\n"
        "   sourceText: $sourceText,\n"
        "   sourceLanguage: $sourceLanguage,\n"
        "   targetLanguage: $targetLanguage,  }";
  }
}
