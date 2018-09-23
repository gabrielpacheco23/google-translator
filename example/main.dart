import 'package:translator/translator.dart';
import 'package:translator/google_translate.dart';

void main() {
  GoogleTranslator translator = new GoogleTranslator();

  String input = "Здравствуйте. Ты в порядке?";

  translator.translate(input, to: 'en')
      .then((s) =>  print("Source: " + input + "\n"
      "Translated: " + s + "\n"));


  translator.baseUrl = "https://translate.google.cn/translate_a/single";
  translator.translateAndPrint("This means 'testing' in chinese", to: 'zh-cn'); 
  //prints 这意味着用中文'测试'
  
  print()

}