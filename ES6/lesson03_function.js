// 优先使用箭头函数,不过一下几种情况避免使用

// 1. 使用箭头函数定义对象方法
let foo = {
	value: 1,
	getValue: ()=> console.log(this.value);
}
foo.getValue(); // undefined

// 2. 定义原型方法
function Foo1(){
	this.value = 1
}
Foo1.prototype.getValue = () => console.log(this.value)

let foo1 = new Foo1()
foo1.getValue(); //undefined

// 3. 作为事件的返回函数
const button = document.getElementById('myButton');
button.addEventListener('click', ()=>{
	console.log(this == window);  // => true
	this.innerHTML = 'Clicked button';
});
