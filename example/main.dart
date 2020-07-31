import 'package:translator/translator.dart';

void main() async {
  final translator = GoogleTranslator();
  final input = "Здравствуйте. Ты в порядке?";

  // Using the Future API
  translator
      .translate(input, to: 'en')
      .then((result) => print("Source: $input\nTranslated: $result"));

  // Passing the translation to a variable
  var translation = await translator
      .translate("I would buy a car, if I had money.", from: 'en', to: 'it');

  // You can also call the extension method directly on the input
  print('Translated: ${await input.translate(to: 'en')}');

  // For countries that default base URL doesn't work
  translator.baseUrl = "translate.google.cn";
  translator.translateAndPrint("This means 'testing' in chinese", to: 'zh-cn');
  //prints 这意味着用中文'测试'

  print("translation: $translation");
  // prints translation: Vorrei comprare una macchina, se avessi i soldi.
}
