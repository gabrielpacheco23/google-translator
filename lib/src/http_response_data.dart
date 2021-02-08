part of google_transl;

class HttpResponseData {
  final jsonData;
  final Uri requestUrl;
  final String sourceText;
  final String sourceLanguage;
  final String targetLanguage;

  HttpResponseData({
    this.jsonData,
    this.requestUrl,
    this.sourceText,
    this.sourceLanguage,
    this.targetLanguage,
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
