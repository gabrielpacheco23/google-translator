# google-translator
Free Google Translate API for Dart

See it in pub: https://pub.dartlang.org/packages/translator

and in GitHub: https://github.com/gabrielpacheco23/google-translator

# Usage 

```dart
void main() {
  GoogleTranslator translator = new GoogleTranslator();

  String input = "Здравствуйте. Ты в порядке?";

  translator.translate(input, from: 'ru', to: 'en').then((s) {
    print(s);
  });
  /// prints Hello. Are you okay?
}
```

Using **translate** method passing the args **from** and **to** designates the
language from text you're typing and the language to be translated
``` dart
translator.translate("I love Brazil!", from: 'en' to: 'pt').then((s) {
    print(s);
  }); 
  /// prints Eu amo Brasil!
```

or you can omit from language and it'll use ```auto``` keyword
that auto-detect the language of source text

```dart
translator.translate("Hello", to: 'es').then((s) => print(s));
/// prints Hola
```

There is also **translateAndPrint** method that prints directly
```dart
translator.translateAndPrint("This means 'testing' in chinese", to: 'zh-cn');
// prints 这意味着用中文'测试'
```

# API
For full API docs take a look at https://pub.dartlang.org/documentation/translator/latest/
## translate(sourceText, {from, to})
### args
-	sourceText -> [*String*]: Text to be translated.
-	from -> [*String*]: Language of ```sourceText```, *default* is ```'auto'```.
-	to -> [*String*]: Language text will be translated to, *default* is ```'en```.

### returns 
- 	```_translatedText``` -> (*private*) [*String*]: Translated text returned


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




