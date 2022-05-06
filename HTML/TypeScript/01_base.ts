// 布尔
let isDone: boolean = false;

// 数字
let decLiteral: number = 6;         //十进制
let hexLiteral: number = 0xf00d;    // 十六进制
let binaryLiteral: number = 0b1010; //二进制
let octalLiteral: number = 0o744;   // 八进制

// 字符串
var str: string = "bob";
str = 'smith';

// 模版字符串，它可以定义多行文本和内嵌表达式。 
// 这种字符串是被反引号包围（ `），
// 并且以${ expr }这种形式嵌入表达式
let name1: string = `Gene`;
let age: number = 37;
let sentence: string = `Hello, my name is ${ name1 }.
                        I'll be ${ age + 1 } years old next month.`;
// 同这种写法
let sentence1: string = "Hello, my name is " + name1 + ".\n\n" +
    "I'll be " + (age + 1) + " years old next month.";

// 数组
let list: number[] = [1, 2, 3];
// 数组 泛型
let list2: Array<number> = [1, 2, 3];

// 元组 声明(元素的类型不必相同)
let x: [string, number];
// 初始化
x = ['hello', 10]; // OK
// Initialize it incorrectly
// x = [10, 'hello']; // Error
// 访问
console.log(x[0].substr(1)); // OK
//console.log(x[1].substr(1)); // Error, 'number' does not have 'substr'
// 越界处理 -> 使用联合类型替代
x[3] = 'world'; // OK, 字符串可以赋值给(string | number)类型
console.log(x[5].toString()); // OK, 'string' 和 'number' 都有 toString
x[6] = true; // Error, 布尔不是(string | number)类型

// 枚举
enum Color {Red, Green, Blue}
let c: Color = Color.Green;
// 默认情况下，从0开始为元素编号。 也可以手动的指定成员的数值,改成从 1开始编号
enum Color2 {Red = 1, Green, Blue}
// 全部都采用手动赋值
enum Color3 {Red = 1, Green = 2, Blue = 4}
// 枚举类型提供的一个便利是你可以由枚举的值得到它的名字
let colorName: string = Color[2];
console.log(colorName);  // 显示'Green'因为上面代码里它的值是2


// Any
// 不清楚类型的变量指定一个类型。 值可能来自于动态的内容，
// 比如来自用户输入或第三方代码库。 这种情况下，我们不希望类型检查器对这些值进行检查而是直接让它们通过编译阶段的检查。 
// 可以使用 any类型来标记这些变量
let notSure: any = 4;
notSure = "maybe a string instead";
notSure = false; // okay, definitely a boolean

// 在对现有代码进行改写的时候，any类型是十分有用的，它允许你在编译时可选择地包含或移除类型检查。 
// 你可能认为 Object有相似的作用，就像它在其它语言中那样。 
// 但是 Object类型的变量只是允许你给它赋任意值 - 但是却不能够在它上面调用任意的方法，即便它真的有这些方法
let notSure2: any = 4;
notSure.ifItExists(); // okay, ifItExists might exist at runtime
notSure.toFixed(); // okay, toFixed exists (but the compiler doesn't check)

let prettySure: Object = 4;
// prettySure.toFixed(); // Error: Property 'toFixed' doesn't exist on type 'Object'.

// 只知道一部分数据的类型时，any类型也是有用的。 比如，你有一个数组，它包含了不同的类型的数据
let list3: any[] = [1, true, "free"];
list3[1] = 100;


// Void
// 某种程度上来说，void类型像是与any类型相反，
// 它表示没有任何类型。 当一个函数没有返回值时，你通常会见到其返回值类型是 void
function warnUser(): void {
    console.log("This is my warning message");
}
//声明一个void类型的变量没有什么大用，因为你只能为它赋予undefined和null：
let unusable: void = undefined;


// Null 和 Undefined
// TypeScript里，undefined和null两者各自有自己的类型分别叫做undefined和null。 和 void相似，它们的本身的类型用处不是很大：

// Not much else we can assign to these variables!
let u: undefined = undefined;
let n: null = null;
// 默认情况下null和undefined是所有类型的子类型。 就是说可以把 null和undefined赋值给number类型的变量


// Never
// never类型表示的是那些永不存在的值的类型。 
// 例如， never类型是那些总是会抛出异常或根本就不会有返回值的函数表达式或箭头函数表达式的返回值类型； 
// 变量也可能是 never类型，当它们被永不为真的类型保护所约束时。
// never类型是任何类型的子类型，也可以赋值给任何类型；然而，没有类型是never的子类型或可以赋值给never类型（除了never本身之外）。 
// 即使 any也不可以赋值给never。
// 返回never的函数必须存在无法达到的终点
function error(message: string): never {
    throw new Error(message);
}


// Object
// object表示非原始类型，也就是除number，string，boolean，symbol，null或undefined之外的类型。
// 使用object类型，就可以更好的表示像Object.create这样的API
declare function create(o: object | null): void;
create({ prop: 0 }); // OK
create(null); // OK

// create(42); // Error
// create("string"); // Error
// create(false); // Error
// create(undefined); // Error


// 类型断言
// 有时候你会遇到这样的情况，你会比TypeScript更了解某个值的详细信息。 通常这会发生在你清楚地知道一个实体具有比它现有类型更确切的类型。
// 通过类型断言这种方式可以告诉编译器，“相信我，我知道自己在干什么”。
// 类型断言好比其它语言里的类型转换，但是不进行特殊的数据检查和解构。 它没有运行时的影响，只是在编译阶段起作用。 
// TypeScript会假设你，程序员，已经进行了必须的检查。
// 类型断言有两种形式。 其一是“尖括号”语法
let someValue: any = "this is a string";
let strLength: number = (<string>someValue).length;
// 另一个为as语法
let someValue1: any = "this is a string";
let strLength1: number = (someValue as string).length;