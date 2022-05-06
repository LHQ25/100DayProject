// 数组去重
[...new Set(array)]

// 条件语句优化
// 根据颜色找出对应的水果
function test(color) {
	switch(color){
		case 'red': return ['apple', 'strawberry'];
		case 'yellow': ['bannana', 'pineapple'];
		case 'purple': ['grape', 'plum'];
		default: return [];
	}
}

test('yellow'); // ['banana', 'pineapple']

// good

const fruitColor = {
	red: ['apple', 'strawberry'],
	yellow: ['bannana', 'pineapple'],
	purple: ['grape', 'plum']
}

function test(color){
	return fruitColor(color) || [];
}

// better
const fruitColor = {
       .set(' red', ['apple', 'strawberry'])
       .set('yellow', ['bannana', 'pineapple'])
       .set(' purple', ['grape', 'plum'])
}
function test(color){
        return fruitColor.get(color) || [];
}
