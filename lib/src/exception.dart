part of google_transl;

class WrongHttpResponseDataException implements Exception {
  final String message;
  final HttpResponseData data;

  WrongHttpResponseDataException(this.message, this.data);

  @override
  String toString() => message;
}

class UnknownDataTypeException implements Exception {
  final String message;

  UnknownDataTypeException(this.message);

  @override
  String toString() => message;
}
