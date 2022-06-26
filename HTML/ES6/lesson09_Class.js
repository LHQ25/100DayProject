//MARK: - 1. 声明一个类
class Point {

  // 实例的属性除非显式定义在其本身（即定义在this对象上），否则都是定义在原型上（即定义在class上）
  constructor(x, y) {
    this.x = x
    this.y = y
  }

  toString() {
    return `Point {x: ${this.x} y: ${this.y}}`
  }

  toValue() {}

}

// 类的数据类型就是函数
const Point_type = typeof Point // "function"
// 类本身就指向构造函数
let res = Point === Point.prototype.constructor // true

// 使用，与构造函数的用法一致
const p = new Point(10,10);
console.log(p.toString());

res = p.constructor === Point.prototype.constructor
console.log(`对象的构造方法就是原型的构造方法 ${ res }`)
// 类的方法都是定义在 prototype 对象上面，所以类的新方法都是添加在 prototype 对象上面

// prototype 对象 constructor 熟悉，直接指向类的本身
const _ = Point.prototype.constructor === Point // true

// 类内部定义的方法，都是不可枚举的
Object.keys(Point.prototype)  // []
Object.getOwnPropertyNames(Point.prototype) // ['constructor', 'toString', 'toValue']

// ES5 写法 toString 就是可枚举的
Point.prototype.toString = function () {
  return `Point {x: ${this.x} y: ${this.y}}`
}

Object.keys(Point.prototype)  // ['toString']
Object.getOwnPropertyNames(Point.prototype) // ['constructor', 'toString', 'toValue']

// MARK: - 2. constructor
// constructor 是类的默认构造方法， 通过 new 生成对象实例， 一个类必须有构造方法，如果没有显式定义，一个空的 constructor 方法会被默认生成
class Foo {
    constructor () {
        return Object.create(null);
    }
}

const foo = new Foo();
res = foo instanceof Foo // false

//MARK: - 3. 实例对象

const p2 = new Point(10, 20);
p2.toString()
Point.hasOwnProperty('x'); // true
Point.hasOwnProperty('y'); // true
Point.hasOwnProperty('toString'); // false
Point.__proto__.hasOwnProperty('toString'); // true
// x 和 y 都是实例对象 p2 自身的属性(定义在this变量上)，所以 hasOwnProperty 返回true； toString 是原型对象的属性，定义在 Point 上面(类方法？？？)，所以返回false

// 类的所有实例对象 共享 一个原型对象 Point.proroType, 所以 __proto__ 属性是相等的 (原型对象是否可以理解为 类似于 类对象的一个东西， 但是方法和属性却是对象的，并非类对象的，怪)

// 因为它们的原型都是Point.prototype，所以__proto__属性是相等的。
// 这也意味着，可以通过实例的__proto__属性为 Class 添加方法(实际是添加对象上面了)
const p3 = new Point(1,2);
p3.__proto__.printName = function() {
    return "Point_cus";
}
p2.printName(); // Point_cus
p3.printName(); // Point_cus


//MARK: - 4. 不存在变量提升， 类在使用前，必须先定义，子类必须在父类之后

//MARK: - 5. Class 表达式
// 使用表达式定义了一个类。这个类的名字是MyClass而不是Me，Me只在Class的内部代码可用，指代当前类
const myClass = class Me {
    getClassName() {
        return Me.name;
    }
}

const inst = new myClass();
inst.getClassName(); // Me
// Me.name; //error

// 如果内部没有使用 Me ， 可以省略 Me（匿名类？）
//const myClass = class {
//    getClassName() {
//        return Me.name;
//    }
//}

// 使用 Class 表达式；可以写出立即执行的 class
const person = new class {
    constructor(name){
        this.name = name;
    }
    sayName() {
        console.log(this.name);
    }
}('lisi');

person.sayName(); // 'lisi'


//MARK: - 6. 私有方法 ES6未提供，只能通过变通方法来实现，可以说是约定俗成的规矩

// 1. 命名的区别
class Widget {
    // 公有
    foo(baz){
        this._bar = baz
    }
    
    // 私有方法; _ 代表内部使用的私有方法，其实在类的外部依旧可以调用
    _baz(baz) {
        return this.snaf = baz;
    }
    
    foo2(baz) {
        bar.cal(this, baz);
    }
}

// 2. 私有方法移除模块，模块内部的方法都是对外可见的

function bar(baz) {
    return this.sanf = baz;
}


//MARK: - 7. this 指向
// 类的方法内部如果含有this，它默认指向类的实例。但是，一旦单独使用该方法，很可能报错
class Logger{
    printName(name = 'there') {
        this.print(`hello ${name}`);
    }
    
    print(text) {
        console.log(text);
    }
}

const { printName, print } = new Logger();
// printName(); // error  原因： 内部调用时 this 指向当前类的实例对象， 直接调用 指向当前运行的环境，找不到对应的 print 方法
print('当前this是 window: cc');

// 解决方法 1 ，在构造函数中绑定 this
class Logger2 {
    constructor(){
        this.printName = this.printName.bind(this);
    }
    
    printName(name = 'there') {
        this.print(`hello ${name}`);
    }
    
    print(text) {
        console.log(text);
    }
}
const { printName: printName2 } = new Logger2();
printName2('xxx');

// 解决方法 2 ，箭头函数

class Logger3 {
    constructor(){
        this.printName = (name = 'there')=> {
            this.print(`hello ${name}`);
        }
    }
    print(text) {
        console.log(text);
    }
}
const { printName: printName3 } = new Logger3();
printName3('xxxxxx');

// 解决方法 3 ，Proxy. 获取方法时 自动绑定 this
function selfish (target) {
  const cache = new WeakMap();
  const handler = {
    get (target, key) {
      const value = Reflect.get(target, key);
      if (typeof value !== 'function') {
        return value;
      }
      if (!cache.has(value)) {
        cache.set(value, value.bind(target));
      }
      return cache.get(value);
    }
  };
  const proxy = new Proxy(target, handler);
  return proxy;
}

const { printName: printName4 } = selfish(new Logger());
printName4('yyyyyyy');

//MARK: - 8. 严格模式

//类和模块的内部，默认就是严格模式，所以不需要使用use strict指定运行模式。只要你的代码写在类或模块之中，就只有严格模式可用


//MARK: - 9. name属性
//由于本质上，ES6的类只是ES5的构造函数的一层包装，所以函数的许多特性都被Class继承，包括name属性。
console.log(Point.name); // "Point"


//MARK: - 10. Class的继承： extends

// 继承了Point类的所有属性和方法
class ColorPoint extends Point {
    constructor(x, y, color) {
        super(x, y); // 调用父类的constructor(x, y), 只有调用super之后，才可以使用this关键字; 类似于其它语言的正常写法;
        this.color = color;
    }

    toString() {
      return this.color + ' ' + super.toString(); // 调用父类的toString()
    }
}
console.log(new ColorPoint(20, 30, '#fff'));  // ColorPoint { x: 20, y: 30, color: '#fff' }

//MARK: - 11. 类的prototype属性和__proto__属性

//大多数浏览器的ES5实现之中，每一个对象都有__proto__属性，指向对应的构造函数的prototype属性。Class作为构造函数的语法糖，同时有prototype属性和__proto__属性，因此同时存在两条继承链。
//（1）子类的__proto__属性，表示构造函数的继承，总是指向父类。
//（2）子类的prototype属性的__proto__属性，表示方法的继承，总是指向父类的prototype属性。
class A {}
class B extends A {}

console.log(`B.__proto__: ${B.__proto__}, A: ${ A } `);  // B.__proto__: class A {}, A: class A {}
console.log(B.__proto__ === A); // true
console.log(`B.prototype.__proto__: ${B.prototype.__proto__}, A.prototype: ${ A.prototype } `);   // B.prototype.__proto__: [object Object], A.prototype: [object Object]
console.log(B.prototype.__proto__ === A.prototype); // true

function Temp(a) {
    this.a = a;
}

const t = new Temp(6);

Temp.prototype.b = 10;
t.__proto__.d = 13;

console.log(`t: ${ t.b }`);
Temp.__proto__.c = 11;

//t.prototype.e = 14;   // Cannot set properties of undefined (setting 'e')
//t.prototype.__proto__.f = 15;  // Cannot read properties of undefined (reading '__proto__')

console.log(t, Temp.prototype, Temp.__proto__);
console.log(t.a, t.b, t.c, Temp.c);

//// MARK: - 12. Extends 的继承目标
//
//// extends关键字后面可以跟多种类型的值
//class D {}
//class C extends D {}
//// 上面代码的D，只要是一个有prototype属性的函数，就能被C继承。由于函数都有prototype属性（除了Function.prototype函数），因此D可以是任意函数
//
//// 特殊情况1 子类继承 Object 类
//class E extends Object {}
//E.__proto__ === Object; // true
//E.prototype.__proto__ = Object.prototype; // true
//// E 其实就是构造函数 Object 的复制， E的实例就是 Object 的实例
//
//// 特殊情况2 不存在任何继承
//class F {}
//F.__proto__ === Function.prototype // true
//F.prototype.__proto__ === Object.prototype // true
//// F 就是基类，也是一个普通函数， 所以直接经常 Function.prototype, F调用后返回一个空对象，
