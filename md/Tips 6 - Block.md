## 前言

这篇文章会有一点长，会从以下几个点进行对 Block 的剖析（当然也是基于源码）：

- Block 的定义
- Block 底层实现
- Block 的实质
- Block 如何截获自动变量
- `__block` 的原理
- Block 造成的循环引用问题及解决方案

## Blocks 的定义

Block 的定义是：带有自动变量（局部变量）的匿名函数。

所以匿名函数就是不带名字的函数，带有自动变量值表现为 "截获自动变量值"。

比如：

```objc
int a = 0;
void (^blk)(void) = ^{
    printf("%d", a);
};
a = 1;
blk();
复制代码
```

`^{ ... }` 其实就是一个匿名函数，也就是 Block。

在将 `a` 赋值为 `1` 之后再执行 `blk`，发现输出是：

```shell
0
复制代码
```

也就是在定义 `blk` 时，就已经捕获 `a` 当时的值，也就是 `0`，这就是截获自动变量值。

## Blocks 的实现

Block 其实编译之后，就是一段普通的 C 语言代码。而 Block 的实质，就是一个 Objective-C 的对象。

比如下面一段代码：

```objc
int main() 
{
    void (^blk)(void) = ^{
        printf(@"Block\n");
    };
    
    blk();
}
复制代码
```

编译之后的代码为：

```c++
struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;

};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
   printf("Block\n");
}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

int main(int argc, const char * argv[]) {
    void (*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    return 0;
}
复制代码
```

大致的结构如下图：

![block_structure.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f0b0989b65af49a89c5b289cfebeed2f~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

其实也不复杂，我们逐个击破。

首先 Blocks 中的函数，在 C 语言中被转换成 `__main_block_func_0`，可以看到里面执行的方法就是 `printf("Block\n")`，所以其实 Blocks 使用的匿名函数实际上是被转换成了一个简单的 C 函数，它的命名规则是根据 Blocks 所属的函数名（这里是 `main`） 和该 Blocks 语法在该函数中出现的顺序值（这里是 0）来命名的。

这个函数还有一个参数：`struct __main_block_impl_0 *__cself`，`__cself` 是结构体 `__main_block_impl_0` 的指针。

去掉构造函数，`__main_block_impl_0` 的定义如下：

```c++
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
}

struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
}
复制代码
```

两个成员分别对应两个结构体：`__block_impl` 和 `__main_block_desc_0`，这两个结构体我们后面细说，先来看一下构造函数：

```c++
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
复制代码
```

`_NSConcreteStackBlock` 是栈 Block，这个也放在后面聊，看一下构造函数是如何调用的，在 `main` 方法中：

```c++
// 去掉转换的部分
struct __main_block_imp_0 tmp = 
    __main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA);

struct __main_block_impl_0 *blk = &tmp;
复制代码
```

这段代码的意思是，将 `__main_block_impl_0` 结构体类型的自动变量，即栈上生成的 `__main_block_impl_0` 结构体实例的指针，赋值给 `__main_block_impl_0` 结构体指针类型的变量 `blk`，以下为这部分代码对应的最初源代码：

```objc
void (^blk)(void) = ^{ printf("Block\n"); };
复制代码
```

将 Block 语法生成的 Block 赋给 Block 类型变量 `blk`，它等同于将 `__main_block_impl_0` 结构体实例的指针赋给变量 `blk`。该代码中的 Block 就是 `__main_block_impl_0` 结构体类型的自动变量，即栈上生成的 `__main_block_impl_0` 结构体实例。

下面就来看看 `__main_block_impl_0` 结构体实例构造参数：

```c++
__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA);
复制代码
```

第一个参数是由 Block 语法转换的 C 语言函数指针。第二个参数是作为静态全局变量初始化的 `__main_block_desc_0` 结构体实例指针，以下为 `__main_block_desc_0` 结构体实例的初始化部分代码：

```c++
static struct __main_block_desc_0 __main_block_desc_0_DATA = {
    0,
    sizeof(struct __main_block_impl_0)
};
复制代码
```

使用 `__main_block_impl_0` 结构体实例的大小，进行初始化。

如果展开 `__main_block_impl_0` 中的 `__block_impl`：

```c++
struct __main_block_impl_0 {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
    struct __main_block_desc_0* Desc;
}
复制代码
```

然后它会像下面这样进行初始化：

```c++
isa = &_NSConcreteStackBlock;
Flags = 0;
Reserved = 0;
FuncPtr = __main_block_func_0;
Desc = __main_block_desc_0_DATA;
复制代码
```

这里是将 `__main_block_func_0` 的函数指针赋值给了成员变量 `FuncPtr`。

在最初的代码中，调用 Block 的函数是：

```objc
blk();
复制代码
```

它被转换成了：

```c++
((__block_impl *)((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
复制代码
```

去掉转换的部分为：

```c++
(*blk->imp1.FuncPtr)(blk);
复制代码
```

这就是简单的使用函数指针调用函数。正如我们前面提到的，由 Block 语法转换的 `__main_block_func_0` 函数的指针被赋值到了 `FuncPtr` 中。另外，`__main_block_func_0` 函数还有一个参数 `_cself`，这里传递的是 `blk`，也就是 `_cself` 指向了 Block 值。

到这里已经解释清楚了 Block 在底层是如何实现的。下面看一下我们前面留下的问题，`_NSConcreteStackBlock` 是什么。

### 关于 `_NSConcreteStackBlock`

```c++
isa = &_NSConcreteStackBlock;
复制代码
```

将 Block 指针赋给 Block 的结构体成员变量 `isa`。

为了理解它，我们先来说明一下 Objective-C 中类和对象的实质。

在 Objective-C 用于存储对象的类型是 `id`，在 runtime 源代码中的声明如下：

```c++
typedef struct objc_object *id;

struct objc_object {
    Class isa;
}
复制代码
```

`Class` 也是一个结构体，继承自 `objc_object`。

```c++
typedef struct objc_class *Class;

struct objc_class : objc_object {
    
}
复制代码
```

对于一个 Objective-C 的类：

```objc
@interface MyObject : NSObject 
{
    int val0;
    int val1;
}
@end
复制代码
```

该类的对象编译后如下：

```c++
typedef struct objc_object MyObject;

struct MyObject_IMPL {
    Class isa;
    int val0;
    int val1;
};
复制代码
```

`MyObject` 类的实例变量 `val0` 和 `val1` 被直接声明为对象的结构体成员。Objective-C 中由类生成对象，意味着由类生成该对象的结构体实例。生成的各个对象，其实就是由该类生成的对象的各个结构体实例，然后这些结构体实例通过成员变量 `isa` 保持了该类的结构体实例指针。

`MyObject_IMPL` 可以理解为类的元数据，它会通过类型的方式与类的 `objc_class` 结构体连接起来，`MyObject_IMPL` 的内存大小在编译时就确定了，可以看到它包含了成员变量，这也可以解释为什么不能在分类中添加成员变量，因为类生成的结构体在编译时就已经确定了内存，不允许再修改，而分类是在运行时才会动态加载，此时是不能改动到编译时就已经确定的类的内存的。

这里所生成的 `MyObject_IMPL` 持有的 `isa`，指向的就是 `MyObject` 这个类的 `object_class` 结构体实例，在这个结构体实例中持有了声明的成员变量、方法的名称、方法的实现（函数指针），属性以及父类的指针：

```c++
struct objc_class: objc_object {
    Class isa; // 继承自 objc_object
    Class superclass; // 父类
    cache_t cache; // 方法缓存
    class_data_bits_t *bits; // 方法实现等
}
复制代码
```

回到刚刚的 Block 结构体：

```c++
struct __main_block_impl_0 {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
    struct __main_block_desc_0* Desc;
}
复制代码
```

此 `__main_block_impl_0` 结构体相当于基于 `objc_object` 结构体的 Objective-C 类对象的结构体。另外，对其中的成员变量 `isa` 进行初始化，具体如下：

```c++
isa = &_NSConcreteStackBlock;
复制代码
```

即 `_NSConcreteStackBlock` 相当于 `objc_class` 结构体实例。在将 Block 作为 Objective-C 的对象处理时，关于该类的信息放在 `_NSConcreteStackBlock` 中。

到这里，应该就能说明为什么 Block 就是 Objective-C 的对象了。

## 截获自动变量值的底层实现

来看下面一段代码：

```objc
int main() 
{
    int a = 0;
    int b = 99;
    void (^blk)(void) = ^{
        printf(@"%d", a);
    };
    a = 1;
    blk();
}
复制代码
```

转换后：

```c++
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int a;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _a, int flags=0) : a(_a) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  int a = __cself->a; // bound by copy
  printf("%d", a);
}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

int main(int argc, const char * argv[]) {
    int a = 0;
    int b = 99;
    void (*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, a));
    a = 1;
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    return 0;
}
复制代码
```

Block 语法表达式中使用的自动变量被作为成员变量追加到了 `__main_block_impl_0` 结构体中：

```c++
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int a;
}
复制代码
```

`__main_block_impl_0` 结构体内声明的成员变量类型与自动变量类型完全相同。请注意，Block 语法表达式中没有使用的自动变量不会被追加，变量 `b` 就没有追加。自动变量捕获只针对 Block 中使用的自动变量。

结合 `main` 中的调用和 `__main_block_impl_0` 的定义，可以得到 `__main_block_impl_0` 结构体实例的初始化如下：

```c++
impl.isa = &_NSConcreteStackBlock;
impl.Flags = 0;
impl.FuncPtr = __main_block_func_0;
Desc = &__main_block_0_DATA;
a = 0;
复制代码
```

由此可见，在 `__main_block_impl_0` 结构体实例（即 Block）中，自动变量值被捕获。

再看 `^{ printf("%d", a); }` 方法，该源代码转换为以下函数：

```c++
static void __main_block_func_0(struct __main_block_impl_0 *__cself) 
{
    int a = __cself->a;
    printf("%d", a);
}
复制代码
```

这里使用的，是被捕获到 `__main_block_impl_0` 结构体中的成员变量上的自动变量 `a`，也就是 0。

所以，所谓 "截获自动变量值"，意味着在执行 Block 语法时，Block 语法表达式所使用的自动变量值被保存到 Block 的结构体实例（即 Block 自身）中。

## __block

自动变量值捕获只能保存执行 Block 语法当时的值，保存后就不能改写该值：

```objc
int a = 0;
void (^blk)(void) = ^{
    a = 1;
};
blk();
复制代码
```

这样会报错：

![error.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fddfa428149f4b22ae9f011b3341bddb~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

```shell
Variable is not assignable (missing __block type specifier)
复制代码
```

如果想在 Block 中修改 `a`，就需要在 `a` 被定义的时候加上 `__block` 说明符：

```objc
__block int a = 0;
void (^blk)(void) = ^{
    a = 1;
};
blk();
复制代码
```

这样就没有问题了。

我们需要解决两个问题：

1. 为什么会报错，
2. 为什么使用 `__block` 就可以了

你可以想象之前的变量 `int a` 是 A，被 Block 截获后的变量 `block a` 是 B，两个是不同的东西，在 Block 内操作的都是 B，就算你真的可以在 Block 内修改，改的也是 B 而不是 A，但是在使用者看来，它们都是 A，所以编译器在遇见这种行为时，直接报错，不允许修改。

![__blockA.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b2c7e2f312df49f098aa5e1116063588~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

`__block` 说明符更准确的表述是 "`__block` 存储域类说明符"，C 语言中有以下存储域类说明符：

- typedef
- extern
- static
- auto
- register

它们用于指定将变量值设置到哪个存储域中。例如，`auto` 表示作为自动变量存储在栈中，`static` 表示作为静态变量存储在数据区中。

我们编译一下使用 `__block` 后的代码：

```c++
struct __Block_byref_a_0 {
  void *__isa;
  __Block_byref_a_0 *__forwarding;
  int __flags;
  int __size;
  int a;
};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_a_0 *a; // by ref
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc,   __Block_byref_a_0 *_a, int flags=0) : a(_a->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_a_0 *a = __cself->a; // bound by ref
  (a->__forwarding->a) = 1;
}
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->a, (void*)src->a, 8/*BLOCK_FIELD_IS_BYREF*/);}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->a, 8/*BLOCK_FIELD_IS_BYREF*/);}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};

int main(int argc, const char * argv[]) {
    __attribute__((__blocks__(byref))) __Block_byref_a_0 a = {(void*)0,(__Block_byref_a_0 *)&a, 0, sizeof(__Block_byref_a_0), 0};
    void (*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_a_0 *)&a, 570425344));
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    return 0;
}
复制代码
```

可以看到 `a` 变成了一个结构体：

```c++
struct __Block_byref_a_0 {
  void *__isa;
  __Block_byref_a_0 *__forwarding;
  int __flags;
  int __size;
  int a;
};
复制代码
```

最后的成员变量 `a` 相当于原自动变量的成员变量。

而赋值的代码：`^{ a = 1; }` 转换成了：

```c++
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_a_0 *a = __cself->a; // bound by ref
  (a->__forwarding->a) = 1;
}
复制代码
```

Block 的 `__main_block_impl_0` 结构体实例持有指向 `__block` 变量的 `__Block_byref_a_0` 结构体实例的指针。

`__Block_byref_a_0` 结构体实例的成员变量 `__forwarding` 持有 "指向该实例自身" 的指针。通过成员变量 `__forwarding` 访问成员变量 `a`。（成员变量 `a` 是该实例自身持有的变量，它相当于原自动变量。）

另外，`__block` 变量生成的 `__Block_byref_a_0` 结构体并不在 `__main_block_impl_0` 结构体中，这样做是为了在多个 Block 中使用 `__block` 变量。

也就是 `int a`，我们先称它为 A，被 `__block` 说明符修饰之后，直接变成了另外一个变量 C，之后不管在 Block 内使用还是 Block 外使用的，都是变换后的 C，所以在 Block 内可以修改，因为改的都是同一个东西。

![__blockb.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3c5adb8180674af28c79e972e76b89ad~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

比如：

```objc
int main()
{ 
    __block int a = 0;
    a = 1;
}
复制代码
```

转换后的代码为：

```c++
struct __Block_byref_a_0 {
  void *__isa;
  __Block_byref_a_0 *__forwarding;
  int __flags;
  int __size;
  int a;
};

int main() {
    __attribute__((__blocks__(byref))) __Block_byref_a_0 a = {(void*)0,(__Block_byref_a_0 *)&a, 0, sizeof(__Block_byref_a_0), 0};
    (a.__forwarding->a) = 1;
    return 0;
}
复制代码
```

## Block 存储域

通过前面的说明，我们可以知道Block 会转换为 Block 的结构体类型的自动变量，`__block` 变量会转换为 `__block` 变量的结构体类型的自动变量。所谓结构体类型的自动变量，即栈上生成的结构体的实例。

并且也知道 Block 其实就是 Objective-C 中的对象，之前的例子中，我们生成的 Block 对应的类为 `_NSConcreteStackBlock`，在变换后的源码中没有关于它的信息，但有很多与之类似的类：

- `_NSConcreteStackBlock`（对象存放在栈上）
- `_NSConcreteGlobalBlock`（与全局变量一样，存放在数据区域（`.data` 区））
- `_NSConcreteMallocBlock`（存放在由 `malloc` 函数分配的内存块（堆）中）

![blockc.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f2a671405add439fa123a6b95753f9ef~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

到目前为止我们 Block 例子中使用的都是 `_NSConcreteStackBlock` 类，且都设置在栈上。事实上当然并非都是这样的，比如在记述全局变量的地方使用 Block 语法时，生成的 Block 为 `_NSConcreteGlobalBlock` 类对象，例如：

```objc
void (^blk)(void) = ^{ printf("Global Block\n"); };

int main() 
{
}
复制代码
```

这段代码也会像之前一样，转换为一个结构体，结构体中的 `isa` 初始化如下：

```c++
impl.isa = &_NSConcreteGlobalBlock;
复制代码
```

此 Block 的结构体实例放置在程序的数据区域中。

当：

- 记述全局变量的地方有 Block 语法时
- Block 语法的表达式中不使用应截获的自动变量时

Block 为 `_NSConcreteGlobalBlock` 对象，除此之外的 Block 语法生成的 Block 为 `_NSConcreteStackBlock` 类对象，且设置在栈上。

那么堆上的 `_NSConcreteMallocStack` 在啥时候用呢？

设置在栈上的 Block，如果其所属的变量作用域结束，则该 `__block` 变量也会被废弃：

![blockd.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6dcb75c92437488381143c1efb350a78~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

但 Block 有一个特性，就是它在超出变量作用域的时候仍可使用。

这是通过将 Block 和 `__block` 变量从栈上复制到堆上来实现的，将在栈上的 Block 复制到堆上，这样即使 Block 语法所在的变量作用域结束，堆上的 Block 还可以继续存在：

![blocke.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/554680e5a77a4c58bd498535e7f8af86~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

我们来看一下复制的过程，下面有一段返回 Block 的函数：

```objc
typedef int (^blk)(int);

blk_t func(int rate) {
    return ^(int count) {
        return rate * count;
    };
}
复制代码
```

该代码为返回配置在栈上的 Block 的函数，程序执行中从该函数返回函数调用方时变量作用域结束，因此栈上的 Block 也被废弃，虽然有这样的问题，但是该代码经过编译器转换如下：

```c++
blk_t func(int rate) 
{
    blk_t tmp = &__func_block_impl_0(
        __func_block_func_0, &__func_block_desc_0_DATA, rate);
    
    tmp = objc_retainBlock(tmp);
    
    return objc_autoreleaseReturnValue(tmp);
}
复制代码
```

查看 objc4 的源码，发现 `objc_retainBlock` 函数实际上就是 `_Block_copy` 函数：

```c++
/**
* 将通过 Block 语法生成的 Block，
* 即配置在栈上的 Block 结构体实例
* 赋值给相当于 Block 类型的变量 tmp 中
*/
tmp = _Block_copy(tmp);

/**
* _Block_copy 函数
* 将栈上的 Block 复制到堆上。
* 复制后，将堆上的地址作为指针赋值给变量 tmp
*/

return objc_autoreleaseReturnValue(tmp);

/**
* 将堆上的 Block 作为 Objective-C 对象
* 注册到 autoreleasepool 中，然后返回该对象
*/
复制代码
```

将 Block 作为函数返回值返回时，编译器会自动生成复制到堆上的代码。

大多数情况下编译器会进行适当的判断，除此之外的情况下需要手动生成，将 Block 从栈上复制到堆上，此时需要使用 `copy` 方法。

编译器不能判断的情况：

- 向方法或函数的参数中传递 Block 时

不过这种情况下还有一些是编译器可以判断的：

- Cocoa 框架的方法且方法名中含有 `usingBlock` 时
- GCD 的 API

按配置 Block 的存储域，调用 `copy` 方法：

![blockf.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a54cb206e98c4c71b8d0a6d5db457a9b~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

## __block 变量存储域

当 Block 从栈上被复制到堆上时，其中的 `__block` 变量也会一并复制到堆上。

当 Block 还在栈上时，`__block` 是作为栈中的一个单独的结构体存在，但 Block 被赋值到堆上时，Block 会去持有 `__block` 变量。

![block_g.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c6eda25b41454269a0d4019418c80081~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

当多个 Block 使用 `__block` 时也是一样，在栈上时，`__block` 变量依然是作为一个单独的结构体存在，当被复制到堆上后，每多一个引用都会增加 `__block` 的引用计数。

![block_h.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1945b7c1ce0245bd8c6c86238a2f3236~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

如果配置在堆上的 Block 被废弃，那么它所使用的 `__block` 变量也就被释放。

![block_i.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8e2964836563446a9e3f640c3ed9b713~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

当栈上的 `__block` 被赋值到堆上时，会将它结构体中的成员变量 `__forwarding` 的值替换成堆上的 `__block` 的结构体实例地址，所以无论是在 Block 内还是 Block 外使用 `__block`，也不管是在栈上还是堆上，都可以正确的访问同一个 `__block` 变量。

![block_j.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/25227078ddc94a91969885eec275c4ef~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

以下情况，栈上的 Block 会复制到堆上：

- 调用 Block 的 `copy` 实例方法时
- Block 作为函数返回值返回时
- 将 Block 赋值给附有 `__strong` 修饰符 id 类型的类或 Block 类型成员变量时
- 在方法名中含有 `usingBlock` 的 Cocoa 框架方法或 GCD 的 API 中传递 Block 时

## Block 的循环引用

如果在 Block 中使用附有 `__strong` 修饰符的对象类型自动变量，那么当 Block 从栈赋值到堆时，该对象为 Block 所持有，这样容易引起循环引用。

```objc
typedef void (^blk_t)(void);

@interface MyObject : NSObject
{
    blk_t _blk;
}
@end

@implementation MyObject

- (instancetype)init {
    if (self = [super init]) {
        _blk = ^{ NSLog(@"self = %@", self); };
    }
    return self;
}

@end

int main(int argc, const char * argv[]) {
    MyObject *o = [[MyObject alloc] init];
    NSLog(@"%@", o);
    return 0;
}
复制代码
```

这段代码执行后，`MyObject` 的 `dealloc` 方法不会被调用，也就是 `MyObject` 不会被释放。

因为 `MyObject` 持有 Block，而在 `init` 方法中执行的 Block 语法里，使用了附有 `__strong` 修饰符的 id 类型变量 `self`，并且由于 Block 语法赋值给了成员变量 `_blk`，会导致 Block 从栈上被赋值到堆，并持有所使用的 `self`。`self` 持有 Block，Block 持有 `self`，这就是循环引用。

![block_k.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dc32eba3c4c24626b578f2755b0da52b~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

可以使用 `weak` 来避免循环引用：

```objc
- (instancetype)init {
    if (self = [super init]) {
        id __weak tmp = self;
        _blk = ^{ NSLog(@"self = %@", tmp); };
    }
    return self;
}
复制代码
```

![block_l.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f3565e1fb6944f559a5d06fb31b201b9~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

## 一些面试题

### 系统的 block 中使用 self 为什么可以不用弱引用？

```objc
[UIView animateWithDuration:duration animations:^{
    [self.superView layoutIfNeed];
}];

[[NSOperationQueue mainQueue] addOperationWithBlock:^{
    self.a = 10;
}];

...
复制代码
```

这些系统的 Block 不会造成循环引用的原因是，这些是类方法，Block 不被 `self` 所持有，而是被其他对象持有，所以不会造成循环引用。

![block_m.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9ac9a031c75e4ddf8ae7f438eb949276~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

### GCD 中的 api 中使用 self 为什么可以不用弱引用？

很简单，因为 `self` 并不持有 GCD 的东西，只是 GCD 的 Block 持有了 `self` 而已，所以不会有循环引用的问题。

![block_n.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ea7a1fb8255540ea801ba561a19a6e6c~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

### 为什么 Block 中还需要写一个 strong self？

在避免循环引用的时候使用了 `__weak` 修饰符，然后再在 Block 内部使用 `__strong` 去修饰：

```objc
- (instancetype)init {
    if (self = [super init]) {
        id __weak tmp = self;
        _blk = ^{
            id __strong strongTmp = tmp;
            NSLog(@"self = %@", strongTmp);
        };
    }
    return self;
}
复制代码
```

这是为了防止在 Block 执行的过程中，`self` 已经被释放了，这里对应的是 `tmp`，我们采用 `__weak` 修饰的 `tmp` 在释放后会被设置为 `nil`，Objective-C 不会执行 `nil` 所调用的那些方法，程序倒不会崩溃。但是执行的结果可能会和我们预想的不一致，因为我们是想在 Block 中去输出关于 `self` 的一些内容，但如果 `self` 被释放了，我们的输出就都是 `nil`，类似这种需要 Block 在执行时，所引用的对象不会被释放的情况，就可以使用 `__strong` 再修饰一次，这里被 `__strong` 所修饰后的 `strongTmp`，就像一个在 Block 内部定义的自动变量，跟随 Block 的生命周期，在 Block 执行结束后，`strongTmp` 也会被释放。



作者：_Terry
链接：https://juejin.cn/post/7173565854049632263
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。