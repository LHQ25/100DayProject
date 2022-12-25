## 前言

这篇文章起源于很古老的一个面试题，为什么一个类的 `[self class]` 和 `[super class]` 的输出是相同的，今天从源码的角度去分析一下。

场景再现：

```objc
@interface Animal : NSObject

@end

@implementation Animal

@end

@interface Cat : Animal

@end

@implementation Cat

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"%@", [self class]);
        NSLog(@"%@", [super class]);
    }
    return self;
} 

@end
复制代码
```

输出：

```c
Cat
Cat
复制代码
```

## 源码

既然都是调用的 `class` 方法，我们就先看一下 `class` 方法的实现是什么：

```c
- (Class)class {
    return object_getClass(self);
}

Class object_getClass(id obj)
{
    if (obj) return obj->getIsa();
    else return Nil;
}
复制代码
```

可以发现，`class` 方法其实就是传入一个对象（实例或类），然后输出这个对象的 `isa`，那么关键就在于，`[self class]` 和 `[super class]` 所传入的对象分别是什么。

将 `Cat` 放到一个 `.m` 文件中，进入到它所在的文件夹，执行 `clang -rewrite-objc Cat.m`，得到一个 `Cat.cpp` 文件，这是 Clang 编译 `Cat.m` 的输出文件，打开这个文件，直接搜索 `Cat_init`，就能定位到我们在 `Cat.m` 中编写的 `init` 方法。

去掉干扰项后，`[self class]` 和 `[super class]` 的源码如下：

```c
// [self class]
((Class (*)(id, SEL))(void *)objc_msgSend)(
    (id)self,  // Cat
    sel_registerName("class") // class 方法
)

// [super class]
((Class (*)(__rw_objc_super *, SEL))(void *)objc_msgSendSuper)(
    (__rw_objc_super) {
        (id)self,  // Cat
        (id)class_getSuperclass(objc_getClass("Cat")) // Animal
        },
    sel_registerName("class") // class 方法
 )
复制代码
```

可以看到它们的不同在于，`[self class]` 调用的是 `objc_msgSend`，第一个参数为 `(id)self`，而 `[super class]` 调用的是 `objc_msgSendSuper`，第一个参数是 `__rw_objc_super`，两者的第二个参数都是一样的，都是方法名，我们先忽略，只看不同的部分。

`__rw_objc_super` 的构造如下：

```c
struct __rw_objc_super { 
	struct objc_object *object; 
	struct objc_object *superClass; 
	__rw_objc_super(struct objc_object *o, struct objc_object *s) : object(o), superClass(s) {} 
};
复制代码
```

查看了一下 `objc_msgSendSuper` 的源码（只有头文件），它的定义为：

```c
objc_msgSendSuper(struct objc_super * _Nonnull super, SEL _Nonnull op, ...)
复制代码
```

接收的第一个参数是 `objc_super` 类型的一个结构体，与我们编译出来的 `__rw_objc_super` 其实是同一个东西，我们看一下源码中的 `objc_super`：

```c
struct objc_super {
    __unsafe_unretained _Nonnull id receiver;
    
#if !defined(__cplusplus)  &&  !__OBJC2__
    __unsafe_unretained _Nonnull Class class;
#else
    __unsafe_unretained _Nonnull Class super_class;
#endif

};

// 因为 #if 中的条件不满足，所以简化下来，它的结构为：

struct objc_super {
    id receiver;  
    Class super_class;
};

复制代码
```

这个与 `__rw_objc_super` 的结构是对应的。

一个 `receiver`，一个 `super_class`，根据我们编译后看到的，`receiver` 传入的是 `self`，也就是 `Cat` 实例对象，`super_class` 用的是 `class_getSuperclass(objc_getClass("Cat"))` 得出来的父类，也就是 `Animal`。

关键点在于，这里传入的 `receiver`，依然是 `Cat` 的实例对象，在调用 `class` 方法，也就是 `object_getClass`，传入的参数就是 `receiver`，其实就是 `self`，所以返回的 `class`，就是 `Cat` 类。

也就是，`[self class]` 和 `[super class]`，二者调用 `object_getCalss` 方法所传入的参数，其实都是 `self`，所以它们的返回结果是一样的。

而它们的区别在于查找方法的顺序上，`objc_msgSend` 是从自己开始，沿着继承链一路往上去查找方法，而 `objc_msgSendSuper` 是从 `self.superclass`，也就是自己的父类开始，沿着继承链一路往上查找方法，但是用于消息发送的 `receiver`，接收者还是自己，只不过不会查找自己的类中的方法列表，而直接从自己的父类中开始查找。

就好比有两个快递，一个是我买的，一个是我爸买的，但是用的都是我的信息，我是快递的签收人，我知道有一个快递是我爸的，我会给他，但是如果有人问，签收人的信息，那就还是我。

Always me.

## 其他

runtime 是开源的，可以从 [官网](https://link.juejin.cn?target=https%3A%2F%2Fopensource.apple.com%2Fsource%2Fobjc4%2F) 进行下载，或者网上找一份可以编译的版本，我用的是 [KCCObjc4](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FLGCooci%2FKCCbjc4_debug)。



作者：_Terry
链接：https://juejin.cn/post/7168539976223686687
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。