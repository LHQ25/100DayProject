// 变量声明
// let和const是JavaScript里相对较新的变量声明方式。 
// let在很多方面与var是相似的。 const是对let的一个增强，它能阻止对一个变量再次赋值。
// 因为TypeScript是JavaScript的超集，所以它本身就支持let和const。 下面我们会详细说明这些新的声明方式以及为什么推荐使用它们来代替 var。

// var 声明
var a = 10;
// 函数内部
function f() {
    var message = "Hello, world!";
    return message;
}
function f2(){
    var a = 10;
    return function g() {
        var b = a + 1;
        return b;
    }
}

var g = f2();
g(); // returns 11;


// 作用域规则
// 对于熟悉其它语言的人来说，var声明有些奇怪的作用域规则
// 变量 x是定义在 if 语句里面，但是我们却可以在语句的外面访问它。 
// 这是因为 var声明可以在包含它的函数，模块，命名空间或全局作用域内部任何位置被访问，
// 包含它的代码块对此没有什么影响。 有些人称此为* var作用域或函数作用域*。 函数参数也使用函数作用域
function f3(shouldInitialize: boolean) {
    if (shouldInitialize) {
        var x = 10;
    }
    return x;
}
f3(true);  // returns '10'
f3(false); // returns 'undefined'

// 作用域规则可能会引发一些错误。 其中之一就是，多次声明同一个变量并不会报错
function sumMatrix(matrix: number[][]) {
    var sum = 0;
    for (var i = 0; i < matrix.length; i++) {
        var currentRow = matrix[i];
        for (var i = 0; i < currentRow.length; i++) {
            sum += currentRow[i];
        }
    }
    return sum;
}

// 捕获变量怪异之处
// 传给setTimeout的每一个函数表达式实际上都引用了相同作用域里的同一个i
// setTimeout在若干毫秒后执行一个函数，并且是在for循环结束后。 for循环结束后，i的值为10。 所以当函数被调用的时候，它会打印出 10
for (var i = 0; i < 10; i++) {
    setTimeout(function() { 
        console.log(i); 
    }, 100 * i);
}
// 解决方法是使用立即执行的函数表达式（IIFE）来捕获每次迭代时i的值
for (var i = 0; i < 10; i++) {
    // capture the current state of 'i'
    // by invoking a function with its current value
    (function(i) {
        setTimeout(function() { console.log(i); }, 100 * i);
    })(i);
}



// let 声明
// 除了名字不同外， let与var的写法一致。
let hello = "Hello!";

// 块作用域
// 当用let声明一个变量，它使用的是词法作用域或块作用域。 不同于使用 var声明的变量那样可以在包含它们的函数外访问，块作用域变量在包含它们的块或for循环之外是不能访问的。
// 拥有块级作用域的变量的另一个特点是，它们不能在被声明之前读或写。 
// 虽然这些变量始终“存在”于它们的作用域里，但在直到声明它的代码之前的区域都属于 暂时性死区
function f4(input: boolean) {
    let a = 100;

    if (input) {
        // Still okay to reference 'a'
        let b = a + 1;
        return b;
    }

    // Error: 'b' doesn't exist here
    return b;
}

// 在catch语句里声明的变量也具有同样的作用域规则。
try {
    throw "oh no!";
}
catch (e) {
    console.log("Oh well.");
}
// Error: 'e' doesn't exist here
console.log(e);

// 仍然可以在一个拥有块作用域变量被声明前获取它。 只是我们不能在变量声明前去调用那个函数
function foo() {
    // okay to capture 'a'
    return aa;
}

// 不能在'a'被声明前调用'foo'
// 运行时应该抛出错误
// foo();
let aa;
foo();


// 重定义及屏蔽
// 使用var声明时，它不在乎你声明多少次；你只会得到1个。
function f5(x) {
    var x;
    var x;

    if (true) {
        var x;
    }
}
// 并不是要求两个均是块级作用域的声明TypeScript才会给出一个错误的警告
function f6(y) {
    let y = 100; // error: interferes with parameter declaration
}
function g7() {
    let y = 100;
    var y = 100; // error: can't have both declarations of 'y'
}

// 并不是说块级作用域变量不能用函数作用域变量来声明。 而是块级作用域变量需要在明显不同的块里声明。
function f7(condition, x) {
    if (condition) {
        let x = 100;
        return x;
    }

    return x;
}

f7(false, 0); // returns 0
f7(true, 0);  // returns 100

// 在一个嵌套作用域里引入一个新名字的行为称做屏蔽。 
// 它是一把双刃剑，它可能会不小心地引入新问题，同时也可能会解决一些错误
function sumMatrix2(matrix: number[][]) {
    let sum = 0;
    for (let i = 0; i < matrix.length; i++) {
        var currentRow = matrix[i];
        for (let i = 0; i < currentRow.length; i++) {
            sum += currentRow[i];
        }
    }

    return sum;
}

// 块级作用域变量的获取
// 最初谈及获取用var声明的变量时，每次进入一个作用域时，它创建了一个变量的 环境。 
// 就算作用域内代码已经执行完毕，这个环境与其捕获的变量依然存在。

function theCityThatAlwaysSleeps() {
    let getCity;

    if (true) {
        let city = "Seattle";
        getCity = function() {
            return city;
        }
    }

    return getCity();
}

// 当let声明出现在循环体里时拥有完全不同的行为。 
// 不仅是在循环里引入了一个新的变量环境，而是针对 每次迭代都会创建这样一个新作用域。 
// 这就是我们在使用立即执行的函数表达式时做的事，所以在 setTimeout例子里我们仅使用let声明就可以了。
for (let i = 0; i < 10 ; i++) {
    setTimeout(function() {console.log(i); }, 100 * i);
}


// const 声明
// const 声明是声明变量的另一种方式。
// 它们与let声明相似，但是就像它的名字所表达的，它们被赋值后不能再改变。 
// 换句话说，它们拥有与 let相同的作用域规则，但是不能对它们重新赋值

// 除非你使用特殊的方法去避免，实际上const变量的内部状态是可修改的。 幸运的是，TypeScript允许你将对象的成员设置成只读的
const numLivesForCat = 9;

const kitty = {
    name: "Aurora",
    numLives: numLivesForCat,
}

// Error
kitty = {
    name: "Danielle",
    numLives: numLivesForCat
};

// all "okay"
kitty.name = "Rory";
kitty.name = "Kitty";
kitty.name = "Cat";
kitty.numLives--;

// let vs. const
// 现在我们有两种作用域相似的声明方式，我们自然会问到底应该使用哪个。 与大多数泛泛的问题一样，答案是：依情况而定。
// 使用最小特权原则，所有变量除了你计划去修改的都应该使用const。 基本原则就是如果一个变量不需要对它写入，那么其它使用这些代码的人也不能够写入它们，并且要思考为什么会需要对这些变量重新赋值。 使用 const也可以让我们更容易的推测数据的流动。
// 跟据你的自己判断，如果合适的话，与团队成员商议一下。
// 这个手册大部分地方都使用了let声明。


// 解构
// 解构数组
// 最简单的解构莫过于数组的解构赋值了：
let input = [1, 2];
let [first, second] = input;
console.log(first); // outputs 1
console.log(second); // outputs 2

// 这创建了2个命名变量 first 和 second。 相当于使用了索引，但更为方便：
first = input[0];
second = input[1];

// 解构作用于已声明的变量会更好：
// swap variables
[first, second] = [second, first];

// 作用于函数参数：
function f8([first, second]: [number, number]) {
    console.log(first);
    console.log(second);
}
f8(input);

// 你可以在数组里使用...语法创建剩余变量：
let [first1, ...rest] = [1, 2, 3, 4];
console.log(first1); // outputs 1
console.log(rest); // outputs [ 2, 3, 4 ]