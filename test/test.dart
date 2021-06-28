import 'dart:io';

import 'package:collection/collection.dart';
import "package:test/test.dart";
import 'package:translator/translator.dart';

void main() {
  GoogleTranslator translator = GoogleTranslator();

  setUp(() {
    translator = GoogleTranslator();
  });

  test("Allow to pass a custom translator URL", () async {
    translator = GoogleTranslator(baseUrl: 'translate.google.cn');
    final t = await translator.getTranslation('friendship', to: 'es');
    expect(t.toString(), 'amistad');
  });

  test("If no FROM language then sourceLanguage will be AUTO", () async {
    final translation =
        await translator.getTranslation('Translation', to: 'es');
    expect(translation.sourceLanguage.code, GoogleTranslator.autoLanguage);
  });

  // this is because sometimes Google Translate doesn't translate well
  test("Get the GT (GTX client) 'buggy' auto detected language", () async {
    translator = GoogleTranslator(clientType: ClientType.extensionGT);
    final t = await translator.getTranslation('perro', to: 'ru');

    expect(t.targetLanguage.name, 'Russian');
    expect(t.text, 'собака');
    expect(t.source, 'perro');
    expect(t.sourceLanguage.name, 'Automatic');
  });

  test('Pronounce from Auto to Russian and English', () async {
    final client = HttpClient();

    Future run(Uri uri, {int expectedHttpCode = 200}) async {
      print(uri);

      final response =
          await client.openUrl('GET', uri).then((request) => request.close());

      expect(response.statusCode, expectedHttpCode);
    }

    await run(await translator.getPronunciationUrl('хорошо', to: 'en'));
    await run(
        await translator.getPronunciationUrl('хорошо', from: 'ru', to: 'en'));
    await run(
      await translator.getPronunciationUrl(
        'хорошо',
        to: GoogleTranslator.autoLanguage,
      ),
      expectedHttpCode: 400,
    );
  });

  test('Translation from English to Russian, from AUTO to Russian', () async {
    const expected = 'хорошо';

    final englishToRussian =
        await translator.getTranslation('good', from: 'en', to: 'ru');
    expect(englishToRussian.text, expected);

    final autoToRussian = await translator.getTranslation('good', to: 'ru');
    expect(autoToRussian.text, expected);
  });

  test('Alternative translations from English to Russian, from AUTO to Russian',
      () async {
    final expected = ['Плохо', 'плохой', 'неудача'];

    final englishToRussian =
        await translator.getAltTranslation('bad', from: 'en', to: 'ru');
    expect(englishToRussian.words, expected);

    final autoToRussian = await translator.getAltTranslation('bad', to: 'ru');
    expect(autoToRussian.words, expected);
  });

  test('Synonyms from AUTO, from English ', () async {
    final expected = [
      'egregious',
      'substandard',
      'poor',
      'inferior',
      'second-rate',
    ];

    final auto = await translator.getSynonyms('bad');
    expect(auto.synonyms, expected);

    final english = await translator.getSynonyms('bad', from: 'en');
    expect(english.synonyms, expected);
  });

  test('Examples from English and from AUTO', () async {
    final expected = [
      'there is widespread <b>discrimination</b> against women',
      '<b>discrimination</b> learning',
      'victims of racial <b>discrimination</b>',
      '<b>discrimination</b> between right and wrong',
      'those who could afford to buy showed little taste or <b>discrimination</b>'
    ];

    const unorderedCollectionEquality = DeepCollectionEquality.unordered();

    final englishResponse =
        await translator.getExamples('discrimination', from: 'en');
    expect(
        unorderedCollectionEquality.equals(englishResponse.examples, expected),
        true);

    final autoResponse = await translator.getExamples('discrimination');
    expect(unorderedCollectionEquality.equals(autoResponse.examples, expected),
        true);
  });

  test('Definitions from English to English, AUTO to English, AUTO to AUTO',
      () async {
    final expected = {
      'noun': ["one's father."]
    };
    final englishToEnglish =
        await translator.getDefinition('dad', from: 'en', to: 'en');
    expect(englishToEnglish.definitions, expected);

    final autoToAuto = await translator.getDefinition('dad');
    expect(autoToAuto.definitions, expected);

    final autoToEnglish = await translator.getDefinition('dad', to: 'en');
    expect(autoToEnglish.definitions, expected);

    final englishToAuto = await translator.getDefinition('dad', from: 'en');
    expect(englishToAuto.definitions, expected);
  });

  test('Definitions from AUTO to English, from AUTO to AUTO', () async {
    final expected = {
      'noun': ["one's father."]
    };

    final autoToEnglish = await translator.getDefinition('dad', to: 'en');
    expect(autoToEnglish.definitions, expected);

    final autoToAuto = await translator.getDefinition('dad');
    expect(autoToAuto.definitions, expected);
  });

  test('Definitions from English to Russian, from AUTO to Russian', () async {
    final expected = {
      'имя существительное': ["one's father."]
    };
    final englishToRussian =
        await translator.getDefinition('dad', from: 'en', to: 'ru');
    expect(englishToRussian.definitions, expected);

    final autoToRussian = await translator.getDefinition('dad', to: 'ru');
    expect(autoToRussian.definitions, expected);
  });
}
