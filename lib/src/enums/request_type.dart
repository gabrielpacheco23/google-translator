import 'package:translator/src/extensions/enum_extensions.dart';

enum RequestType {
  translation,
  alternativeTranslation,
  synonym,
  definition,
  example,
}

extension RequestTypeExtensions on RequestType {
  String get name => describeEnum(this)!;
}