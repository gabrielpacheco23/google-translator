import "package:test/test.dart";
import 'package:translator/src/langs/language.dart';
import 'package:translator/translator.dart';

void main() {
  test("Conection test: Is Google Translate API working?", () async {
    var translator = GoogleTranslator();
    var t = await translator.getTranslation('test', to: 'pt');
    expect(t.text, 'teste');
  });

  test("Changing the base URL", () async {
    var translator = GoogleTranslator();
    translator.baseUrl = 'translate.google.cn';
    var transl = await translator.getTranslation('friendship', to: 'es');
    expect(transl.toString(), 'amistad');
  });

  test("Get the right auto detected language", () async {
    var translator = GoogleTranslator();
    var translation = await translator.getTranslation('Translation', to: 'es');
    expect(translation.sourceLanguage.code, 'auto');
  });

  // this is because sometimes Google Translate doesn't translate well
  test("Get the 'GT buggy' auto detected language", () async {
    var translator = GoogleTranslator();
    var translation = await translator.getTranslation('Translation', to: 'pt');
    expect(translation.sourceLanguage.toString(), 'Automatic');
  });

  test('GTX client', () async {
    var translator = GoogleTranslator(client: ClientType.extensionGT);
    var t = await translator.getTranslation('test', to: 'pt');
    expect('$t', 'teste');
  });

  test('Translation stuff', () async {
    var translator = GoogleTranslator(client: ClientType.extensionGT);
    var t = await translator.getTranslation('perro', to: 'ru');
    expect(t.targetLanguage.name, 'Russian');
    expect(t.text, 'собака');
    expect(t.source, 'perro');
    expect(t.sourceLanguage.name, 'Automatic');
  });

  test('Language stuff', () {
    bool b = LanguageList.contains('kke');
    bool b2 = LanguageList.contains('ja');
    expect(b, false);
    expect(b2, true);
  });
  test('Pronounce', () async {
    var translator = GoogleTranslator();
    var t = await translator.getPronunciationUrl('хорошо', to: 'ru');
    print(t);
  });

  test('Translation', () async {
    var translator = GoogleTranslator();
    var t = await translator.getTranslation('good', to: 'ru');
    expect(t.text, 'хороший');
  });

  test('Alternative translations', () async {
    var translator = GoogleTranslator();
    var t = await translator.getAltTranslation('bad', to: 'ru');
    expect(t.words, ['плохой', 'Плохо']);
  });

  test('Synonyms', () async {
    var translator = GoogleTranslator();
    var t = await translator.getSynonyms('bad', to: 'ru');
    expect(t.synonyms, [
      'egregious',
      'substandard',
      'poor',
      'inferior',
      'second-rate',
    ]);
  });

  test('Examples', () async {
    var translator = GoogleTranslator();
    var t = await translator.getExamples('tree', to: 'ru');
    expect(t.examples, ['pear <b>tree</b>']);
  });

  test('Definitions', () async {
    var translator = GoogleTranslator();
    var t = await translator.getDefinition('dad', to: 'ru');
    expect(t.definitions, {
      'имя существительное': ['one\'s father.']
    });
  });
}
