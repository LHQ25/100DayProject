## 前言

这篇文章主要围绕几个问题展开：

1. block 是什么
2. block 的类型
3. `__block` 是什么，以及它的 `forwarding` 指针的用处
4. block 为什么会造成循环引用
5. block 的拷贝机制
6. block 的运用

## block 是什么

block 的定义：**带有自动变量（局部变量）** 的 **匿名函数**。

主要是弄清楚「带有」、「自动变量」和「匿名函数」是什么，我们就能知道 block 大概是个什么东西了。

> **自动变量** 指的是局部作用域变量，具体来说即是在控制流进入变量作用域时系统自动为其分配存储空间，并在离开作用域时释放空间的一类变量。在许多程序语言中，自动变量与术语局部变量所指的变量实际上是同一种变量，所以通常情况下 “自动变量" 和 "局部变量" 是同义的。

主要意思是自动变量的生命周期由系统控制，当自动变量超过其作用域，会被系统自动释放。在 iOS 说自动变量，可以当做局部变量来理解。

而匿名函数，就是 **没有名称的函数**。C 语言的标准是不允许这样的函数存在的，因为调用函数必须知道函数名。当然也可以使用函数指针来调用，不过在赋值给函数指针的时候，也是需要知道函数名，不然也无法获得该函数的地址。

来看一个简单的 block：

```scss
^() {
    printf("a simple block");
}
复制代码
```

这个函数就是没有名字的。

那什么是「带有」呢？

带有其实就是我们常说的 **捕获**，那为什么一个 block 要去捕获自动变量呢？其实 block 在 OC 中本质上也是一个 OC 对象，它有它的结构，在它结构内部也有 isa 指针，它是一个 **封装了函数调用以及函数调用环境的 OC 对象**。也就是说在你调用这个 block 的时候，它需要保证它的调用环境是可用的，而自动变量的生命周期是由系统控制的，当你调用 block 的时候，很可能其中使用到的自动变量已经被释放了，所以要把自动变量捕获进 block 结构体的内部，才能保证函数的调用环境。捕获的意思指 block 所使用的自动变量值被自动保存到 block 结构体实例中。

那么还会不会捕获其他变量？比如静态变量、全局变量、静态全局变量？其实不会，虽然这些变量的作用域不同，但是在整个程序中，一个变量总保持在一个内存区域，因此，虽然多次使用，但是不管在任何时候以任何状态调用，使用的都是相同的内存区域，同一个变量，所以并不需要捕获这些变量。

## block 的类型

那是不是所有的 block 都会捕获变量呢？也不是，其实只要保证函数调用环境就可以，block 在 OC 中有三种类型：

- 全局 block（`_NSConcreteGlobalBlock`），存在数据区（`.data` 区）
- 堆 block（`_NSConcreteStackBlock`），存在堆区
- 栈 block（`_NSConcreteMallocBlock`），存在栈区

在写全局变量的位置定义 block 的时候，生成的 block 类型是全局 block，因为在使用全局区域的地方不能使用自动变量，所以不存在对自动变量进行捕获。其实还有一种情况，就算 block 在平常定义全局变量的地方定义，使用的类型也是 `_NSConcreteGlobalBlock` 类型，那就是在没有捕获自动变量的时候。所以全局 block 有两种情况：

- 在记述全局变量的地方用 block 时
- block 没有截获自动变量时

除此之外的 block 语法生成的 block 就全是 `_NSConcreteStackBlock` 类型的了，也就是栈 block。还有一个堆 block 是怎么来的呢？其实不是我们创建出来的，是系统根据情况帮我们从栈上复制到堆上的。之所以要复制也是因为作用域的问题，设置在栈上的 block，如果其所属的变量作用域结束，该 block 也会被废弃，所以得拷贝到堆上，除了系统自动生成，我们也可以手动调用 block 的 copy 方法将栈上的 block 拷贝到堆上。

简单列一下栈上的 block 复制到堆上的情况（ARC）：

自动复制：

- block 作为函数返回值时（自动生成复制到堆上的代码）
- 将 block 赋值给附有 `__strong` 修饰符 id 类型的类或 block 类型的成员变量时
- block 作为 Cocoa API 中方法名含有 `usingBlock` 的方法参数时
- block 作为 GCD API 的方法参数时

手动复制：

- 调用 copy 方法

在调用 block 的 copy 实例方法时，如果 block 配置在栈上，那么该 block 会从栈复制到堆。block 作为函数返回值返回时，将 block 赋值给附有 `__strong` 修饰符 id 类型的类或 block 类型的成员变量时，编译器自动的将对象的 block 作为参数并调用 `_Block_copy` 函数，这与调用 block 的 copy 实例方法的效果相同。在方法名中含有 `usingBlock` 的 Cocoa 框架方法或 Grand Central Dispatch 的 API 中传递 block 时，在该方法或函数内部对传递过来的 block 调用 block 的 copy 实例方法或者 `_Block_copy` 函数。

栈 block 也是不是去持有外部对象的，只有堆 block 才会去持有外部对象，栈 block 不捕获是因为它的生命周期大于等于它所使用的自动变量的生命周期。堆 block 对去持有外部对象，也就是捕获自动变量，在堆 block 将被释放的时候，会对它所持有的对象进行一次 `release` 操作。

编译器大多数情况下都能判断出是否需要复制，但是有一种情况是判断不出来的，那就是：

- 向方法或函数的参数传递 block 时

但是如果在方法或函数中适当的复制了传递过来的参数，那么就不必在调用该方法或函数前手动复制了。

要注意一个问题就是，将 block 从栈上复制到堆上是很消耗 CPU 的，所以当 block 设置在栈上就能够满足需求的话，将其复制到堆上是一种资源的浪费。

栈上的 block 调用 copy 会将 block 复制到堆中，那么堆 block 和全局 block 调用 copy 方法又会发生什么呢？列了一个表，如下：

| Block 的类             | 副本源的配置存储域       | 复制效果     |
| ---------------------- | ------------------------ | ------------ |
| _NSConcreteStackBlock  | 栈                       | 从栈复制到堆 |
| _NSConcreteGlobalBlock | 程序的数据区域（全局区） | 什么也不做   |
| _NSConcreteMallocBlock | 堆                       | 引用计数增加 |

前面提到堆 block 将被释放会对所持有的对象进行一次 `release` 操作，来看一下堆 block 对一个自动变量的捕获过程：

1. 调用 block 内部的 `copy` 函数
2. `copy` 函数内部会调用 `_Block_object_assign` 函数
3. `_Block_object_assign` 函数会根据自动变量的修饰符（`__strong`、`__weak`、`__unsafe_unretained`）做出相应操作，类似于 `retain`，形成强引用、弱应用

当 block 从堆上移除：

1. 会调用 block 内部的 `dispose` 函数
2. `dispose` 函数内部会调用 `_Block_object_dispose` 函数
3. `_Block_object_dispose` 函数会自动释放引用的自动变量，类似于 release

其中主要涉及两个函数，`copy` 函数和 `dispose` 函数，当栈上的 block 复制到堆时调用 `copy` 函数，当堆上的 block 被废弃时调用 `dispose` 函数。

来个小结，block 分三种类型，全局 block、堆 block、栈 block，只有堆才会捕获变量，并且只捕获自动变量，也就是局部变量。

## __block

block 有一个现象，那就是无法修改外部变量，如：

```ini
int a = 1;
void (^blk)(void) = ^{
    a = 2;
};
复制代码
```

上面代码会以下错误：

```python
Variable is not assignable (missing __block type specifier)
复制代码
```

提示我们需要使用 `__block` 对变量进行修饰，也就是在 `int a` 前使用 `__block` 来修饰。为什么 block 不能修改外部对象？`__block` 后又可以修改外部对象了？

先来看看它为什么不能修改外部的对象，前面提到 block 可以捕获自动变量，但是 block 只捕获自动变量的值，而并不捕获它的地址，相当于在 block 内部新建了一个属性，存储了所使用的对象的自动变量的 **值**，所以在 block 内部使用的自动变量已经不是之前的那个自动变量，即使你修改也影响不了之前的自动变量。基于这个原因，苹果在编译器编译的过程检测到给截获的自动变量赋值操作时，就会产生一个编译错误。

那为什么加上了 `__block` 作为修饰就可以了呢？其实是因为系统帮我们重新生成了一个新的对象，来看一段代码：

```ini
__block int val = 10;
void (^blk)(void) = ^{ val = 1; };
复制代码
```

该代码编译成 C++ 代码后如下：

```ini
int main()
{
    __Block_byref_val_0 val = {
        0,
        &val,
        0,
        sizeof(__Block_byref_val_0),
        10
    };
    
    blk = &__main_block_impl_0 (
        __main_block_func_0, &__main_block_desc_0_DAT, &val, 0x22000000);
    
    return 0;
}
复制代码
```

也就是之前 `int` 类型的 val 被转变成了 `__Block_byref_val_0` 类型的一种结构体，该结构体的声明如下：

```arduino
struct __Block_byref_val_0 {
    void *__isa;
    __Block_byref_val_0 *__forwarding;
    int __flags;
    int __size;
    int val;
}
复制代码
```

该结构体中最后的成员变量 val 就是之前的 `int val`。

`^{ val = 1; }` 被转成了什么呢？如下：

```rust
static void __main_block_func_0(struct __main_block_impl_0 *__cself)
{
    __Block_byref_val_0 *val = __cself->val;
    (val->__forwarding->val) = 1;
}
复制代码
```

看一下它的查找过程 `(val->__forwarding->val)`，block 的 `__main_block_impl_0` 结构体实例 `__cself` 指向 `__block` 变量的 `__Block_byref_val_0` 结构体的指针，`__Block_byref_val_0` 结构体实例的成员变量 `__forwarding` 持有指向该实例自身的指针，通过成员变量 `__forwarding` 访问成员变量 val。（成员变量 val 是该实例自身持有的变量，它相当于原自动变量。）查找过程如下图：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/25/16b8dd6a96731dcf~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



`__block` 变量的 `__Block_byref_val_0` 结构体并不在 block 内部的结构体中，这样做是为了在多个 block 中使用 `__block` 变量。

那还有一个问题，就是为什么需要有一个 `__forwarding` 指针去指向自己？其实这是为了保证不管 `__block` 变量配置在栈上还是堆上时都能够正确访问 `__block` 变量。怎么说呢？当 block 从栈上被复制到堆时，在栈区的 `__block` 变量也会复制一份到堆中，此时会将 `__block` 的成员变量 `forwarding` 的值替换为复制目标堆上的 `__block` 变量用结构体实例的地址。如下图：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/25/16b8e21dcc4fe5b5~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



那么这样，无论是 block 语法中、block 语法外使用 `__block` 变量，还是 `__block` 变量配置在栈上还是堆上，都可以顺利的访问同一个 `__block` 变量。

## block 的循环引用

如果在 block 中使用附有 `__strong` 修饰符的对象类型自动变量，那么当 block 从栈复制到堆时，该对象为 block 持有，这样容易引起循环引用。

比如：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/27/16b96968329116b5~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



`self` 持有 block，block 持有 `self`，这就形成了循环引用。解决的方式有三种：

- `__weak`
- `__unsafe_unretained`
- `__block`

（1）`__weak` 的方式：

```ini
- (id)init 
{
    self = [super init];
    
    id __weak tmp = self;
    
    blk_ = ^{ NSLog(@"self = %@", tmp); };
    
    return self;
}
复制代码
```

（2）`__unsafe_unretained` 的方式：

```ini
- (id)init
{
    self = [super init];
    
    id __unsafe_unretained tmp = self;
    
    blk = ^{ NSLog(@"self = %@", tmp); };
    
    return self;
}
复制代码
```

`__unsafe_unretained` 与 `__weak` 的区别在于 `__unsafe_unretained` 所指向的对象被回收之后，`__unsafe_unretained` 指针并不会自动置为 nil，此时 `__unsafe_unretained` 指针就是悬垂指针，对悬垂指针进行操作可能会引发崩溃。

（3）那么还有一种 `__block` 来破解循环引用的方式：

```objectivec
typedef void (^blk_t)(void);

@interface MyObject : NSObject
{
    blk_t blk_;
}

@implementation MyObject

- (instancetype)init {
    self = [super init];
    
    __block id tmp = self;
    
    blk_ = ^{
        NSLog(@"self = %@", tmp);
        tmp = nil;
    };
    
    return self;
}

- (void)execBlock {
    blk_();
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end

int main() {
    id o = [[MyObject alloc] init];
    
    [o execBlock];
    
    return 0;
}
复制代码
```

这种方式有一个问题，就是必须要执行 block 才能解除引用链条，因为 `tmp = nil` 是写在 block 内部的。反正就目前来说，99% 情况下使用的都是 `__weak`。还有一种情况是先 `__weak`，然后在 block 内部再使用一个 `__strong` 指针去强引用它，如下：

```ini
__weak typeof(self) weakSelf = self;
blk_ = ^{
    __strong typeof(self) strongSelf = weakSelf;
    NSLog(@"%@",strongSelf);
};
复制代码
```

这样是为了保证 block 内部的代码能够执行完，因为在执行 `NSLog` 之前，self 有可能会被释放，所以对其进行一个强引用。如果出现双层循环或多层循环，要再对 `strongSelf` 进行 `__weak` 然后再 `__strong`。。。这样一层层嵌套。

放一下我项目中用到的 `@weakify` 和 `@strongify` 宏定义：

```less
// 弱引用
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

// 强引用
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif
复制代码
```

## 为 UIButton 添加 block

最后说一个小例子，就是为按钮或者 `UIView` 类型的控件添加 block，大家可以按照这篇 [文章](https://link.juejin.cn?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2F47d60106a4f2) 来实现这个小轮子。我重新再封装了一下，放到了 [github](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FJJCrystalForest%2FFREventBlock) 之中，使用大概是这样子的：

```ini
#import "UIButton+FRButtonEventBlock.h"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.aButton];
    
    self.aButton.fr_touchUpInside = ^{
        NSLog(@"touchUpInside");
    };
    
    self.aButton.fr_touchUpOutside = ^{
        NSLog(@"touchUpOutside");
    };
    
    self.aButton.fr_touchDown = ^{
        NSLog(@"touchDown");
    };
    
    self.aButton.fr_touchCancel = ^{
        NSLog(@"touchCancel");
    };
}
复制代码
```

## 参考文章

[iOS中Block的用法，示例，应用场景，与底层原理解析（这可能是最详细的Block解析）](https://juejin.cn/post/6844903597214285837)

[iOS开发 | 让你的UIButton自带block](https://link.juejin.cn?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2F47d60106a4f2)



作者：_Terry
链接：https://juejin.cn/post/6844903879725826061
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。