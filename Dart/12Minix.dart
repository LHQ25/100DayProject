void main() {
  /* -------------- 使用 Mixin 为类添加功能 --------------*/
  // Mixin 是一种在多重继承中复用某个类中代码的方法模式。
  // 使用 with 关键字并在其后跟上 Mixin 类的名字来使用 Mixin 模式
}

class Musician extends Performer with Musical {
  //....
}

/* -------------- 使用 Mixin 为类添加功能 --------------*/
class Maestro extends Person with Musical, Aggressive, Demented {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}

// 想要实现一个 Mixin，请创建一个继承自 Object 且未声明构造函数的类。
// 除非你想让该类与普通的类一样可以被正常地使用，否则请使用关键字 mixin 替代 class
mixin Musical {
  bool canPlayPoano = false;
  bool canCOmpose = false;
  bool canConduct = false;

  void entertainMe() {
    if (canPlayPoano) {
      print("canPlayPoano");
    } else if (canCOmpose) {
      print("canCOmpose");
    } else {
      print("canConduct");
    }
  }
}

// 可以使用关键字 on 来指定哪些类可以使用该 Mixin 类，比如有 Mixin 类 A，但是 A 只能被 B 类使用，则可以这样定义 A
class MusicianA {}

mixin MusicalPerformer on MusicianA {}

class SingerDancer extends MusicianA with MusicalPerformer {}
