//MARK: - 1. ES6新增了let命令，用来声明变量。它的用法类似于var，但是所声明的变量，只在let命令所在的代码块内有效
{
    let a = 10;
    var b = 1;
}
console.log(a); // ReferenceError: a is not defined.
console.log(b); // 1

//MARK: - 2. 不存在变量提升
console.log(foo); // 输出undefined
console.log(bar); // 报错ReferenceError
var foo = 2;
let bar = 2;

//MARK: - 3. 暂时性死区
var tmp = 123;
if (true) {
    tmp = 'abc'; // ReferenceError
    // 只要块级作用域内存在let命令，它所声明的变量就“绑定”（binding）这个区域，不再受外部的影响
    let tmp;
}

//MARK: - 4. 不允许重复声明
// 报错
function fun1 () {
    // let不允许在相同作用域内，重复声明同一个变量
    let a = 10;
    var a = 1;
}

//MARK: - 5. ES6的块级作用域
function f1() {

    // let实际上为JavaScript新增了块级作用域
    let n = 5;
    if (true) {
        let n = 10;
    }
    console.log(n); // 5
}
// 上面的函数有两个代码块，都声明了变量n，运行后输出5。
// 这表示外层代码块不受内层代码块的影响。如果使用var定义变量n，最后输出的值就是10

// MARK: 6. 块级作用域与函数声明
// 函数能不能在块级作用域之中声明，是一个相当令人混淆的问题。
// ES5规定，函数只能在顶层作用域和函数作用域之中声明，不能在块级作用域声明。
// ES6 引入了块级作用域，明确允许在块级作用域之中声明函数。
// ES6 规定，块级作用域之中，函数声明语句的行为类似于let，在块级作用域之外不可引用
// ES6严格模式
'use strict';
if (true) {
    // 不报错
    function f() {}
}

//MARK: - 7. 块级作用域可以变为表达式，也就是说可以返回值，办法就是在块级作用域之前加上do，使它变为do表达式。

let x = do {
    let t = f();
    t * t + 1;
};
// 上面代码中，变量x会得到整个块级作用域的返回值

// MARK: - 8. const命令
// const声明一个只读的常量。一旦声明，常量的值就不能改变。
// const声明的变量不得改变值，这意味着，const一旦声明变量，就必须立即初始化，不能留到以后赋值
const PI = 3.1415;
PI // 3.1415
// PI = 3; TypeError: Assignment to constant variable.

// const的作用域与let命令相同：只在声明所在的块级作用域内有效
// const命令声明的常量也是不提升，同样存在暂时性死区，只能在声明的位置后面使用
// const声明的常量，也与let一样不可重复声明

// 对于复合类型的变量，变量名不指向数据，而是指向数据所在的地址。
// const命令只是保证变量名指向的地址不变，并不保证该地址的数据不变，所以将一个对象声明为常量必须非常小心

//MARK: - 9. 顶层对象的属性
// 顶层对象，在浏览器环境指的是window对象，在Node指的是global对象。ES5之中，顶层对象的属性与全局变量是等价的。

window.c = 1;
c // 1

var d = 2;
window.d // 2
// 上面代码中，顶层对象的属性赋值与全局变量的赋值，是同一件事

// ES6为了改变这一点，一方面规定，为了保持兼容性，
// var命令和function命令声明的全局变量，依旧是顶层对象的属性；
// 另一方面规定，let命令、const命令、class命令声明的全局变量，不属于顶层对象的属性。
// 也就是说，从ES6开始，全局变量将逐步与顶层对象的属性脱钩。

var a = 1;
// 如果在Node的REPL环境，可以写成global.a
// 或者采用通用方法，写成this.a
window.a // 1

let b = 1;
window.b // undefined
// 上面代码中，全局变量a由var命令声明，所以它是顶层对象的属性；全局变量b由let命令声明，所以它不是顶层对象的属性，返回undefined

//MARK: - 10. global 对象
// 在语言标准的层面，引入global作为顶层对象。也就是说，在所有环境下，global都是存在的，都可以从它拿到顶层对象。
// 垫片库system.global模拟了这个提案，可以在所有环境拿到global。

// CommonJS的写法
require('system.global/shim')();

// ES6模块的写法
import shim from 'system.global/shim'; shim();
// 上面代码可以保证各种环境里面，global对象都是存在的。

// CommonJS的写法
var global = require('system.global')();

// ES6模块的写法
import getGlobal from 'system.global';
const global = getGlobal();
// 上面代码将顶层对象放入变量global