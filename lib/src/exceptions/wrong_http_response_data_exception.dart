import '../http_response_data.dart';
import 'google_translator_exception.dart';

class WrongHttpResponseDataException extends GoogleTranslatorException {
  final HttpResponseData data;

  WrongHttpResponseDataException(String message, this.data) : super(message);
}
