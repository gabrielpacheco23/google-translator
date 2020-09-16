import "package:test/test.dart";
import 'package:translator/translator.dart';

void main() {
  test('Translation', () async {
    var translator = GoogleTranslator();
    var t = await translator.translate('good', to: 'ru');
    expect(t.text, 'хороший');
  });

  test('Alternative translations', () async {
    var translator = GoogleTranslator();
    var t = await translator.getAltTranslation('bad', to: 'ru');
    expect(t.words, ['Плохо', 'плохой']);
  });

  test('Synonyms', () async {
    var translator = GoogleTranslator();
    var t = await translator.getSynonyms('bad', to: 'ru');
    expect(t.synonyms, ['crummy', 'rotten', 'pathetic', 'useless', 'woeful']);
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
