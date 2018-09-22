# google-translator
Free Google Translate API for Dart

# Install
Add this to your pubspec.yaml file:
```
dependencies:
	google-translator: ^0.0.1

```
Enter ``` pub get ``` to get the dependencies

# Usage 

```
void main() {
  GoogleTranslator translator = new GoogleTranslator();

  String input = "Здравствуйте. Ты в порядке?";

  translator.translate(input, from: 'ru', to: 'en').then((s) {
    print(s);
  });
  /// prints 'Hello. Are you okay?'
}
```

Using ** translate ** method passing the args ** from ** and ** to ** designates the
language from text you're typing and the language to be translated
``` 
translator.translate("I love Brazil!", from: 'en' to: 'pt').then((s) {
    print(s);
  }); 
  /// prints Eu amo Brasil!
```

```
or you can omit from language and it'll use ** 'auto' ** keyword
that auto-detect the language of source text
```

```
translator.translate("Hello", to: 'es').then((s) => print(s));
/// prints Hola
```

There is also ** translateAndPrint ** method that prints directly
```
translator.translateAndPrint("This means 'testing' in chinese", to: 'zh-cn');
// prints 这意味着用中文'测试'
```

# API 
## translate(sourceText, {from, to})
#### args
```sourceText``` -> [String]: Text to be translated
```from``` -> [String]: Language of ```sourceText```, default is ```'auto'```
```to``` -> [String]: Language text will be translated to, default is ```'en```

### returns 
```_translatedText``` -> (private) [String]: Translated text returned

## translateAndPrint(sourceText, {from, to})
### args
Same as ```translate(...)```

### returns
prints the translated text directly

# License
MIT License
Copyright © 2018 Gabriel Pacheco

# Disclaimer
This package is developed for educational purposes only. Do not depend on this package as it may break anytime as it is based on crawling the Google Translate website. Consider buying Official Google Translate API for other types of usage.




