// 需要拼接字符串的时候尽量改成使用模板字符串
const example = 'example';
const foo = 'this is a' + example;
// 第二种方式
const foo1 = 'this is a ${example}';

// 2 标签模板
let url = oneLine`
www.taobao.com/example/index.html
?foo=${foo}
&bar=${bar}
`
console.log(url);
