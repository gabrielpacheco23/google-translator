import "package:test/test.dart";
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'package:translator/src/extension.dart';

void main() {
  test("Conection test: Is Google Translate API working?", () async {
    try {
      final _baseUrl = "https://translate.googleapis.com/translate_a/single";
      String url;
      var parameters = {
        'client': 't',
        'sl': 'pt',
        'tl': 'en',
        'dt': 't',
        'ie': 'UTF-8',
        'oe': 'UTF-8',
        'q': "Teste;"
      };

      String str = "";
      parameters.forEach((key, value) {
        if (key == 'q') {
          str += (key + "=" + value);
          return;
        }
        str += (key + "=" + value + "&");
      });

      url = _baseUrl + '?' + str;
      var data = await http.get(url);
      print(data);
    } on Error catch (err) {
      print("Test failed.");
      return err.stackTrace;
    }
  });

  test("It translates and prints, right? The Future instance, tho.", () {
    var translator = GoogleTranslator();
    var input =
        "Olá meu excellentíssimo amigo. Como você está? Exceções são comuns, né?";
    try {
      translator.translate(input, from: 'es', to: 'ru').then((s) {
        print(s);
      });
      translator.translateAndPrint("Testing", to: 'pt');
    } on Error catch (err) {
      print("Test failed.");
      return err.stackTrace;
    }
  });

  test("Get the translation, man.", () async {
    var input = "The wisest go to the right";
    expect(
        await GoogleTranslator(client: ClientType.siteGT)
            .translate(input, to: 'pt'),
        equals("O mais sábio ir para a direita"));
    expect(
        await GoogleTranslator(client: ClientType.extensionGT)
            .translate(input, to: 'pt'),
        equals("Os mais sábios vão para a direita"));
  });

  test("Get the translation - using the extension method", () async {
    var input = "The wisest go to the right";

    expect(await input.translate(to: 'pt'),
        equals("O mais sábio ir para a direita"));

    expect(await input.translate(to: 'pt', client: ClientType.extensionGT),
        equals("Os mais sábios vão para a direita"));
  });
}
