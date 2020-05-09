import 'package:translator/src/google_translator.dart';

extension StringExtension on String {
  Future<String> translate({
    String from = 'auto',
    String to = 'en',
    bool useCache = true,
    int maxLengthCache,
    ClientType client = ClientType.siteGT,
  }) async =>
      await GoogleTranslator(
              useCache: useCache,
              maxLengthCache: maxLengthCache,
              client: client)
          .translate(this, from: from, to: to);
}
