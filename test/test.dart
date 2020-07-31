import "package:test/test.dart";
import 'package:translator/src/langs/language.dart';
import 'package:translator/translator.dart';

void main() {
  test("Conection test: Is Google Translate API working?", () async {
    var translator = GoogleTranslator();
    var t = await translator.translate('test', to: 'pt');
    expect(t.text, 'teste');
  });

  test("Changing the base URL", () async {
    var translator = GoogleTranslator();
    translator.baseUrl = 'translate.google.cn';
    var transl = await translator.translate('friendship', to: 'es');
    expect(transl.toString(), 'amistad');
  });

  test("Get the right auto detected language", () async {
    var translator = GoogleTranslator();
    var translation = await translator.translate('Translation', to: 'es');
    expect(translation.sourceLanguage.code, 'en');
  });

  // this is because sometimes Google Translate doesn't translate well
  test("Get the 'GT buggy' auto detected language", () async {
    var translator = GoogleTranslator();
    var translation = await translator.translate('Translation', to: 'pt');
    expect(translation.sourceLanguage.toString(), 'Automatic');
  });

  test('GTX client', () async {
    var translator = GoogleTranslator(client: ClientType.extensionGT);
    var t = await translator.translate('test', to: 'pt');
    expect('$t', 'teste');
  });

  test('Translation stuff', () async {
    var translator = GoogleTranslator(client: ClientType.extensionGT);
    var t = await translator.translate('perro', to: 'ru');
    expect(t.targetLanguage.name, 'Russian');
    expect(t.text, 'собака');
    expect(t.source, 'perro');
    expect(t.sourceLanguage.name, 'Spanish');
  });

  test('Language stuff', () {
    bool b = LanguageList.contains('kke');
    bool b2 = LanguageList.contains('ja');
    expect(b, false);
    expect(b2, true);
  });
}
