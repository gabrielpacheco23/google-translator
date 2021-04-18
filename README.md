# translator
Free Google Translate API for Dart

See it in pub: https://pub.dartlang.org/packages/translator \
and GitHub: https://github.com/gabrielpacheco23/google-translator

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Q5Q04C63Q)

# Usage 

```dart
void main() async {
  final translator = GoogleTranslator();

  final input = "Здравствуйте. Ты в порядке?";

  translator.translate(input, from: 'ru', to: 'en').then(print);
  // prints Hello. Are you okay?
  
  var translation = await translator.translate("Dart is very cool!", to: 'pl');
  print(translation);
  // prints Dart jest bardzo fajny!

  print(await "example".translate(to: 'pt'));
  // prints exemplo
}
```
&nbsp;

Using **translate** method passing the args **from** and **to** designates the
language from text you're typing and the language to be translated
``` dart
translator.translate("I love Brazil!", from: 'en', to: 'pt').then((s) {
    print(s);
  }); 
  // prints Eu amo o Brasil!
```
&nbsp;

or you can omit from language and it'll auto-detect the language of source text

```dart
translator.translate("Hello", to: 'es').then(print);
// prints Hola
```
&nbsp;

and also pass the value to a var using ```await```
```dart
var translation = await translator.translate("I would buy a car, if I had money.", from: 'en', to: 'it');
print(translation);
// prints Vorrei comprare una macchina, se avessi i soldi.
```
&nbsp;

The returned value is a ```Translation``` object which holds the translation stuff
```dart
var translation = await translator.translate('Translation', from: 'en', to: 'es');
print('${translation.source} (${translation.sourceLanguage}) == ${translation.text} (${translation.targetLanguage})');

// prints Translation (English) == Traducción (Spanish)
```
&nbsp;

You can use the ***extension method*** directly on the string too
```dart
print(await "example".translate(to: 'pt'));
// prints exemplo
```
&nbsp;

There is **translateAndPrint** method that prints directly
```dart
translator.translateAndPrint("This means 'testing' in chinese", to: 'zh-cn');
// prints 这意味着用中文'测试'
```
&nbsp;

# API
For full API docs take a look at https://pub.dartlang.org/documentation/translator/latest/

# Support my work :)
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Q5Q04C63Q)


# License
MIT License

Copyright © 2021 Gabriel Pacheco


# Disclaimer
This package is developed for educational purposes only. Do not depend on this package as it may break anytime as it is based on crawling the Google Translate website. Consider buying Official Google Translate API for other types of usage.




