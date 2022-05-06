//  唯一值
// bad
// 1. 创建属性会被 for-in 或 Object.keys() 枚举出来
// 2. 一些库可能会使用相同的方式，发生冲突
if (element.isMoving) {
	smoothAnimations(element);
}
element.isMoving = true;

//good 
if (element._$jorendorff_animation_library$PLEASE_DO_NOT_UES_THIS_PROPERTY&isMoving__) {
	smoothAnimatoins(element);
}
element._$jorendorff_animation_library$PLEASE_DO_NOT_UES_THIS_PROPERTY&isMovin__ = true;

// better
var isMoving = Sybol("isMoving");
...

if (element[isMoving]) {
	smoothAnimation(element);
}
element[isMoving] = true;

// 魔术字符串
// 魔术字符串是指在代码种多次出现、与代码形成强耦合的某一个具体的字符串或者数值
// 魔术字符串不利于维护和修改，尽量消除魔术字符串，使用含义清晰地变量代替
// bad
const TYPE_AUDIO = 'AUDIO';
const TYPE_VIDEO = 'VIDEO';
const TYPE_IMAGE = 'IMAGE';

// good
const = TYPE_AUDIO = Symbol()
const = TYPE_VIDEO = Symbol()
const = TYPE_IMAGE = Symbol()

function handleFileResource(resource){
	switch(resource.type){
	  case TYPE_AUDIO: playAudio(resource); break;
	  case TYPE_VIDEO: playVideo(resource); break;
	  case TYPE_IMAGE: preview(resource); break;
	  default: throw new Error('error');
	}
}

// 私有变量
// Symbol也可以用于私有变量的实现
const Example = (function() {
	var _private = Symbol('private');

	class Example{
		constructor(){
			this[_private] = 'private';
		}
		getName(){
			return this[_private];
		}
	}
	return Example;
})();

var ext = new Example();
console.log(ex.getName()); // private
conslole.log(ex.name); // undefined
