import 'package:translator/translator.dart';

void main() async {
  final translator = GoogleTranslator();

  final input = "Здравствуйте. Ты в порядке?";

  translator.translate(input, to: 'en').then((s) => print("Source: " +
      input +
      "\n"
          "Translated: " +
      s +
      "\n"));

  // You can also call the extension method directly on the input
  print('Translated: ${await input.translate(to: 'en')}');

  // For countries that default base URL doesn't work
  translator.baseUrl = "https://translate.google.cn/translate_a/single";
  translator.translateAndPrint("This means 'testing' in chinese", to: 'zh-cn');
  //prints 这意味着用中文'测试'

  var translation = await translator
      .translate("I would buy a car, if I had money.", from: 'en', to: 'it');
  print("translation: " + translation);
  // prints translation: Vorrei comprare una macchina, se avessi i soldi.
}
