import './token_provider_interface.dart';

///
///  This class generates a token passed in google translate api URL
///  with some hard math (based on JS token generator)
///
/// [author] Gabriel N. Pacheco
///

class GoogleTokenGenerator implements TokenProvider {
  /// Generate and return a token
  @override
  String generateToken(String text) {
    return tokenGen(text);
  }

  /// Generate a valid Google Translate request token
  /// [a] is the text to translate
  String tokenGen(dynamic a) {
    var tkk = TKK();
    var b = tkk[0];

    var d = []; //List();

    for (var f = 0; f < a.toString().length; f++) {
      var g = a.toString().codeUnitAt(f);
      if (128 > g) {
        d.add(g);
      } else {
        if (2048 > g) {
          d.add(g >> 6 | 192);
        } else {
          if (55296 == (g & 64512) &&
              f + 1 < a.toString().length &&
              56320 == (a.toString().codeUnitAt(f + 1) & 64512)) {
            g = 65536 +
                ((g & 1023) << 10) +
                (a.toString().codeUnitAt(++f) & 1023);
            d.add(g >> 18 | 240);
            d.add(g >> 12 & 63 | 128);
          } else {
            d.add(g >> 12 | 224);
          }
          d.add(g >> 6 & 63 | 128);
        }
        d.add(g & 63 | 128);
      }
    }
    a = b;
    for (var e = 0; e < d.length; e++) {
      if (a is String) {
        a = int.parse(a) + d[e];
      } else {
        a += d[e];
      }
      a = wr(a, '+-a^+6');
    }
    a = wr(a, '+-3^+b+-f');
    a ^= tkk[1] != null ? tkk[1] + 0 : 0;
    if (0 > a) {
      a = (a & 2147483647) + 2147483648;
    }
    a %= 1E6;
    a = (a as double).round();
    return a.toString() + '.' + (a ^ int.parse(b)).toString();
  }

  List TKK() {
    return ['406398', (561666268 + 1526272306)];
  }

  int wr(dynamic a, dynamic b) {
    var d;
    try {
      for (var c = 0; c < b.toString().length - 2; c += 3) {
        d = b[c + 2];
        d = 'a'.codeUnitAt(0) <= d.toString().codeUnitAt(0)
            ? (d[0].toString().codeUnitAt(0)) - 87
            : int.parse(d);
        d = '+' == b[c + 1] ? unsignedRightShift(a, d) : a << d;
        a = '+' == b[c] ? (a + (d as int) & 4294967295) : a ^ d;
      }
      return a;
    } on Error {
      rethrow;
    }
  }

  int unsignedRightShift(var a, var b) {
    var m;
    if (b >= 32 || b < -32) {
      m = (b / 32) as int;
      b = b - (m * 32);
    }

    if (b < 0) {
      b = 32 + b;
    }

    if (b == 0) {
      return ((a >> 1) & 0x7fffffff) * 2 + ((a >> b) & 1);
    }

    if (a < 0) {
      a = (a >> 1);
      a &= 2147483647;
      a |= 0x40000000;
      a = (a >> (b - 1));
    } else {
      a = (a >> b);
    }
    return a;
  }
}
