## 前言

这年头，不能扯点 Runtime 哪敢去面试啊。。

Runtime 直接翻译就是 **运行时**。但是有人说它叫运行时，有人说它是运行时库，有人说它就是一个对象，exm？又是对象？当初我看 RunLoop 的时候你也是这么说的。但你说的是对的，毕竟万物皆对象嘛，好，你回去等通知吧。

我觉得有几个概念要提前简单说明一下：

- 编译时：代码编译的时候
- 运行时：程序运行的时候
- 运行时库：程序运行的时候所依赖的库
- 运行时系统：一种把半编译的运行码在目标机器上运行的环境（维基百科），可以简单理解为一种运行环境

这里可以看看这位知乎er的[回答](https://link.juejin.cn?target=https%3A%2F%2Fwww.zhihu.com%2Fquestion%2F20607178)。

> 运行时就是**程序运行的时候**。

运行时库就是**程序运行的时候**所依赖的库。 
 **运行的时候**指的是指令加载到内存并由 CPU 执行的时候。 
 C 代码编译成可执行文件的时候，指令没有被 CPU 执行，这个时候算是编译时，就是**编译的时候**。

## 什么是 Runtime

我们 iOSer 说的 Runtime 都是指 Objective-C 语言中的 Runtime。我们先来看看[官方](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FCocoa%2FConceptual%2FObjCRuntimeGuide%2FIntroduction%2FIntroduction.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40008048-CH1-SW1)是怎么定义 Runtime 的：

> Objective-C 是一门动态语言，它将很多静态语言在编译和链接时做的事情推迟到运行时来处理。

> 这种特性意味着 Objective-C 不仅需要一个编译器，还需要一个运行时系统来执行编译的代码。对于 Objective-C 来说，这个运行时系统就像一个操作系统一样：它让所有的工作可以正常的运行。

那么 Objective-C 是如何实现这个运行时系统的呢？其实就是使用 C 和汇编写的一个运行时库，也就是我们常说的 Runtime，正是因为有这个运行时库，我们所编写的代码才能够正常的运行。

所以 Runtime 其实指的是那个用 C 和汇编写的那个库，库这个概念呢可以简单的理解成我们平时用的一些第三方库，比如 AFNetworking，我们开发需要网络请求，所以我们引入了 ADNetworking 库，而 Objective-C 语言需要动态性，所以引入了 Runtime 库。

不过一般我们说 Runtime，不但包含运行时库的意思，还包含了运行时、运行时系统等一些概念，这样比较笼统，不过个人觉得也无伤大雅，毕竟万物皆对象嘛。。



这里我还想扯一下一个问题，那就是，程序是从 `main` 函数开始的吗？这是《程序员的自我修养——链接、装载与库》里面的一个问题（书318页）。

我们一般都说 “程序的入口函数 `main`”，但是如果你善于观察，就会发现当程序执行到 `main` 函数的第一行时，很多事情都已经完成了。

这是 Objective-C 的 `main.m` 文件中的 `main` 函数，也就是我们一般说的程序入口。

```objC
int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
复制代码
```

如果我们打断点到函数里面，会发现在程序刚刚执行 `main` 的时候，`main` 函数的两个参数（`argc` 和 `argv`）已经被正确传了进来。此外，在你不知道的时候，堆和栈的初始化悄悄完成了，一些系统 I/O 也被初始化了，也许还有一些其他的操作，所以，`main` 函数执行之前其实系统已经帮我们做了一些事情。这是如何实现的呢？

操作系统装载程序之后，首先运行的代码并不是 `main` 的第一行，而是某些别的代码，这些代码负责准备好 `main` 函数执行所需要的环境，并且负责调用 `main` 函数，这时候你才可以在 `main` 函数里放心大胆地写各种代码，申请内存、使用系统调用、触发异常、访问 I/O。在 `main` 返回之后，它会记录 `main` 函数的返回值，然后结束进程。

运行这些代码的函数称为 **入口函数** 或 **入口点（Entry Point）**，视平台的不同而有不同的名字。程序的入口点实际上是一个程序初始化和结束部分，它往往是运行库的一部分。一个典型的程序运行步骤大致如下：

1. 操作系统在创建进程后，把控制权交到了程序的入口，这个入口往往是运行库中的某个入口函数
2. 入口函数对运行库和程序运行环境进行初始化，包括堆、I/O、线程、全局变量构造，等等
3. 入口函数在完成初始化后，调用 `main` 函数，正式开始执行程序主体部分
4. `main` 函数执行完毕以后，返回到入口函数，入口函数进行清理工作，包括全局变量析构、堆销毁、关闭 I/O 等，然后进行系统调用结束进程

这边多加了一个概念，**运行库**，这个运行库其实在 Objective-C 中就是运行时库，我们的主角：Runtime。



再重复一下，Runtime 就是 Objective-C 中使用 C 和 汇编编写的一套运行时库，它是我们代码真正运行的环境。



## Runtime 结构

这里有一份[编译好的 Runtime 源码](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FRetVal%2Fobjc-runtime%2Ftree%2Fobjc.750)。当然也可以从 [opensource.apple](https://link.juejin.cn?target=https%3A%2F%2Fopensource.apple.com%2Fsource%2Fobjc4%2F) 下载，目前最新的版本是 `objc4-750`，我们就使用这个版本来看一下 Runtime 里面的一些重要结构和函数。

先列举一下比较重要的一些基本概念：

- `SEL`：方法选择器，全名是 `selector`
- `id`：是一个参数类型，指向某个类实例的指针
- `Class`：指向了 `objc_class` 结构体的指针
- `Method`：代表了类中的某个方法的类型
- `Ivar`：成员变量的类型
- `IMP`：函数指针，由编译器生成，方法实现的代码就是由 `IMP` 指定
- `Cache`：方法调用的缓存器，为方法调用的性能进行优化
- `Property`：属性存储器

### Class

来看一下小码哥的一张图：

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/16/16abeb4540ca5b19~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)

从源码分析一下：

```c
typedef struct objc_object *id;

typedef struct objc_class *Class;

struct objc_object {
    isa_t isa;
};

struct objc_class : objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache;             // 方法缓存
    class_data_bits_t bits;    // 用于获取具体的类信息
    ...
}

复制代码
```

因为 `objc_class` 继承于 `objc_object`，所以 `objc_class` 的结构其实是：

```c
struct objc_class : objc_object {
    isa_t isa;                  
    Class superclass;
    cache_t cache;             // 方法缓存
    class_data_bits_t bits;    // 用于获取具体的类信息
    ...
}
复制代码
```

`objc_object` 用来描述 OC 中的实例，当用口语描述实例时，总会说 「XX类的实例x」或「x是XX的实例」；`objc_object` 的 `isa` 在程序结构上表达类似的含义，它指向了该实例所对应的类，类在 runtime 中被描述成 `objc_class` 结构。

`objc_class` 继承自 `objc_object`，所以它也有 `isa` 指针，指向它的元类，对于元类而言，类本身也是一个对象；`objc_class` 的 `superclass` 成员变量指向该类的父类；`isa` 和 `superclass` 这两个成员变量在继承链中扮演者关键作用，满足了类的继承关系的构建。关于 `isa`、`superclass`和元类的关系会在本文后面详细说明。`cache` 成员变量和优化有关，譬如缓存最近命中的方法等。对于 `bits` 字段，通过它，可以找到类的其他描述信息，包括类名、方法、成员变量等。

`bits` 类型的 `class_data_bits_t` 是一个结构体，里面包含了一个 `class_rw_t` 类型的指针，叫 `data`。`class_rw_t` 内部有个 `class_ro_t` 的指针，叫 `ro`。

### objc_object 与 isa

```c
struct objc_object {
    Class isa;
}

typedef struct objc_object *id;
复制代码
```

`objc_object` 中只有一个 `isa`，所以我们直接来看 `isa`，它对应的类型是 `isa_t`，是一个联合体，在 x86_64 架构下的定义如下：

```c
// 只抽取重要的部分
struct {
    uintptr_t nonpointer        : 1;  // 0:普通指针，1:优化过，使用位域存储更多信息
    uintptr_t has_assoc         : 1;  // 对象是否含有或曾经含有关联引用
    uintptr_t has_cxx_dtor      : 1;  // 表示是否有C++析构函数或OC的dealloc
    uintptr_t shiftcls          : 44; // 存放着 Class、Meta-Class 对象的内存地址信息
    uintptr_t magic             : 6;  // 用于在调试时分辨对象是否未完成初始化
    uintptr_t weakly_referenced : 1;  // 是否被弱引用指向
    uintptr_t deallocating      : 1;  // 对象是否正在释放
    uintptr_t has_sidetable_rc  : 1;  // 是否需要使用 sidetable 来存储引用计数
    uintptr_t extra_rc          : 8;  // 引用计数能够用 8 个二进制位存储时，直接存储在这里
};
复制代码
```

在 64 位架构下，系统用八个字节也就是 64 个二进制位来存储一个 `isa`，而如果单纯的存储对象的内存地址，那么其实不需要那么多位，剩余的二进制位就会浪费，所以苹果将剩余的二进制位来存储该对象相关的一些内存信息，这也是对内存使用的一个优化。

在 Objective-C 中，所有的类自身也是一个对象，这个对象的 `Class` 里面也有一个 `isa` 指针，它指向 `metaClass(元类)`，在后面我们会介绍。

当我们向一个 Objective-C 对象发送消息时，运行时库到对象的 `isa` 指针所指向的类中的方法列表以及父类的方法列表中去寻找与消息对应的 `selector` 指向的方法，能找到就执行，不能就进行消息转发。

### superclass

指向该类的父类，如果该类已经是最顶层的根类（如 `NSObject` 或 `NSProxy`），则 `superclass` 为 NULL。

### 元类 (Meta Class)

来看一个例子：

```objc
NSArray *array = [NSArray array];
复制代码
```

这个例子中，`+array` 消息发送给了 `NSArray` 类，而这个 `NSArray` 也是一个对象。既然是对象，那么它也是一个 `objc_object` 指针，它包含一个指向其类的 `isa` 指针。那么就有一个问题了，这个 `isa` 指向的是什么呢？为了调用 `+array` 方法，这个类的 `isa` 指针必须指向一个包含这些类方法的一个 `objc_class` 结构体。这就引出了 `meta-class` 的概念。

> meta-class 是一个类对象的类。

当我们向一个对象发送消息时，Runtime 会在这个对象所属的这个类的方法列表中查找方法；而向一个类发送消息时，会在这个类的 `meta-class` 的方法列表中查找。

`meta-class` 之所以重要，是因为它存储着一个类的所有类方法。每个类都会有一个单独的 `meta-class`，因为每个类的类方法基本不可能完全相同。

再深入一下，既然 `meta-class` 也是一个类，也可以向它发送一个消息，那么它的 `isa` 又是指向什么呢？为了不让这种结构无限延伸下去，Objective-C 的设计者让所有的 `meta-class` 的 `isa` 指向基类的 `meta-class`，以此作为它们的所属类。即，任何 `NSObject` 继承体系下的 `meta-class` 都使用 `NSObject` 的 `meta-class` 作为自己所属的类，而基类的 `meta-class` 的 `isa` 指向它自己，这样就形成了一个完美的闭环。

这个结构我们看一下这张很经典的图：

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2018/1/9/160da5dc3f53c917~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)

### cache_t

`cache_t` 的定义：

```c
struct cache_t {
    struct bucket_t *_buckets;  // 散列表
    mask_t _mask;   // 散列表的长度 -1
    mask_t _occupied;   // 已经缓存的方法数量
}

// bucket_t
struct bucket_t {
    cache_key_t _key;  // SEL 作为 key
    IMP _imp;   // 函数的内存地址
}
复制代码
```

> buckets:
>
> 指向 Method 数据结构指针的数组。这个数组可能包含不超过 mask+1 个元素。需要注意的是，指针可能是 NULL，表示这个缓存 bucket 没有被占用，另外被占用的 bucket 可能是不连续的。这个数组可能会随着时间而增长。

> mask:
>
> 一个整数，指定分配的缓存 bucket 的总数。在方法查找过程中，Objective-C runtime 使用这个字段来确定开始线性查找数组的索引位置。指向方法 selector 的指针与该字段做一个 AND 位操作（index = (mask & selector)）。这可以作为一个简单的 hash 散列算法。

> occupied:
>
> 一个整数，指定实际占用的缓存 bucket 的总数。

所以 `cache_t` 是一个 [散列表](https://link.juejin.cn?target=https%3A%2F%2Fbaike.baidu.com%2Fitem%2F%E5%93%88%E5%B8%8C%E8%A1%A8) （想贴维基百科的，但是考虑到要科学上网就贴一下百度的吧），用来缓存曾经调用过的方法，可以提高方法的查找速度。

### class_data_bits_t

上面说过，`class_data_bits_t` 是一个结构体，里面包含了一个 `class_rw_t` 类型的指针，叫 `data`。`class_rw_t` 内部有个 `class_ro_t` 的指针，叫 `ro`。

我们来看一下 `class_rw_t` 和 `class_ro_t`，这两个都是包含类信息的一个结构体，`rw` 意为 `read-write`，`ro` 意为 `read-only`。也就是 `class_rw_t` 是可读写的，而 `class_ro_t` 是只读的，下面是它们具体的定义：

`class_ro_t` 的定义：

```c
struct class_ro_t {

    const char * name;                // 类名
    
    method_list_t * baseMethodList;   // 方法列表
    protocol_list_t * baseProtocols;  // 协议列表
    const ivar_list_t * ivars;        // 实例变量

    ...
};
复制代码
```

`class_rw_t` 的定义：

```c
struct class_rw_t {

    const class_ro_t *ro;         // 原始类信息

    method_array_t methods;       // 类列表
    property_array_t properties;  // 属性列表
    protocol_array_t protocols;   // 协议列表

    Class firstSubclass;          // 第一个子类
    Class nextSiblingClass;       // 兄弟类
    
}
复制代码
```

在编译阶段，编译器就对 OC 类结构的基本信息进行了整理，只是这些信息比较分散，libojc 在运行时阶段，将这些零散的信息提取出来进行再加工结构化。

那么为什么要设计 `class_rw_t` 和 `class_ro_t` 两个结构体呢？它们又是如何初始化的呢？

[这篇文章](https://link.juejin.cn?target=https%3A%2F%2Fzhangbuhuai.com%2Fpost%2Fruntime.html) 指出，`objc_class` 的 `data` 指针最开始指向 `class_ro_t` 结构体，但在 `realize` 逻辑中，libobjc 创建了一个 `class_rw_t` 结构体，并把 `data` 指针指向到该结构体。

> **realize**: OC 类在被使用之前（譬如调用类方法），需要进行一系列的初始化，譬如：指定 `superclass`、指定 `isa` 指针、`attach categories` 等等；libobjc 在 runtime 阶段就可以做这些事情，但是有些过于浪费，更好的选择是懒处理，这一举措极大优化了程序的执行速度。而 runtime 把对类的惰性初始化过程称为「realize」。

> 利用已经被 `realize` 的类含有 `RW_REALIZED` 和 `RW_REALIZING` 标记的特点，可以为项目找出无用类；因为没有被使用的类，一定没有被 `realized`。

至于为什么要设计，可以这么理解，`class_ro_t` 包含的类信息（方法、属性、协议等）都是在编译期就可以确定的，暂且称为元信息吧，在之后的逻辑中，它们显然是不希望被改变的；后续在用户层，无论是方法还是别的扩展，都是在 `class_rw_t` 上进行操作，这些操作都不会影响类的元信息。

来看一下小码哥的关于 `class_rw_t` 和 `class_ro_t` 的结构的图，画的好的我就不重新画了（就没重新画过，忽略我）。

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/16/16abf95b5e49de6c~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/16/16abf98747d29cc0~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)

注意到 `class_rw_t` 中的 `method_array_t`，它是一个数组，而它里面的 `method_list_t`，也是一个数组，为什么我们需要用一个二维数组来保存方法呢？像 `class_ro_t` 中那样不就好了吗？这是因为，我们都知道 OC 中有分类的概念，分类中可以为原来的类去添加新方法，而且一个类是可以有多个分类的。那么每个分类的方法列表对应一个 `method_list_t`，最终都合并到原来的类的 `method_array_t` 中去。

### method_t

`method_t` 定义：

```c
struct method_t {
    SEL name;           // 函数名
    const char *types;  // 编码（返回值类型、参数类型）
    IMP imp;  // 指向函数的指针（函数地址）
};

// IMP
typedef id _Nullable (*IMP)(id _Nonnull, SEL _Nonnull, ...);

// SEL
typedef struct objc_selector *SEL;
复制代码
```

`SEL` 代表方法\函数名，一般叫做选择器，底层结构跟 `char *` 类似

- 可以通过 `@selector()` 和 `sel_registerName()` 获得
- 可以通过 `sel_getName()` 和 `NSStringFromSelector()` 转成字符串
- 不同类中相同方法的名字，所对应的方法选择器是相同的

`types` 包含了函数返回值，参数编码的字符串，关于编码字符串对应的意义，可以查看[这里](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FCocoa%2FConceptual%2FObjCRuntimeGuide%2FArticles%2FocrtTypeEncodings.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40008048-CH100-SW1)。

我们可以看到结构体中包含一个 `SEL` 和 `IMP`，实际上相当与 `SEL` 和 `IMP` 之间做了一个映射。有了 `SEL`，我们便可以找到对应的 `IMP`，从而调用方法的实现代码。

我觉得关于结构就说到这里吧，大家可以下载编译好的源码 [ojc4-750](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FRetVal%2Fobjc-runtime%2Ftree%2Fobjc.750) 看看。

另外也可以看看这篇文章 [runtime 完整总结](https://link.juejin.cn?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2F6b905584f536)。里面详细介绍了 runtime 的结构和一些概念，虽然版本有点久，但是还是有参考价值。



## Runtime 的作用

Runtime 其实主要做了下面几件事情：

1. 封装：在这个库中，对象可以用 C 语言中的结构体表示，而方法可以用 C 函数来实现，另外再加上了一些额外的特性。这些结构体和函数被 runtime 函数封装后，我们就可以在程序运行时创建、检查、修改类、对象和它们的方法了。
2. 找出方法的最终执行代码：当程序中执行 `[receiver message]` 时，会向消息接收者（`receiver`）发送一条消息 `message`，runtime 会根据消息接收者是否能响应该消息而做出不同的反应，这里面涉及到了消息转发，我们待会讲。



OC 中大致分为三类对象：

- 实例对象
- 类对象
- 元类对象

它们通过 `isa` 彼此串联，实例对象的 `isa` 指向类对象，类对象的 `isa` 指向元类对象，元类对象的 `isa` 指向元类的根类，它们之间的关系可以看一下上面 `元类 (meta-class)` 部分的那张图，消息也是沿着图中的指向来进行传递的。

### 消息与消息转发

可以看一下YY大佬的 [Objective-C 中的消息与消息转发](https://link.juejin.cn?target=https%3A%2F%2Fblog.ibireme.com%2F2013%2F11%2F26%2Fobjective-c-messaging%2F)。

#### 1.编译器的转换

```objc
[reveiver message];
复制代码
```

这一句话的含义是：向 `receiver` 发送名为 `message` 的消息。

我们可以把 oc 的代码转换成 c 代码，会发现 `[reveiver message]` 会由编译器转化为以下的纯 C 调用。

```c
objc_msgSend(receiver, @selector(message));
复制代码
```

所以，objc 发送消息，最终大都会转换为 `objc_msgSend` 的方法调用。

苹果在 [文档](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FCocoa%2FConceptual%2FObjCRuntimeGuide%2FArticles%2FocrtTypeEncodings.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40008048-CH100-SW1) 里是这么写的：

```objc
id objc_msgSend(id self, SEL _cmd, ...);
复制代码
```

将一个消息发送给一个对象，并且返回一个值。

在 objc 中，每个方法都默认带了两个参数，一个是 `self`，方法的调用者；另一个是 `_cmd`，当前方法的 `selector`。

其中 `self` 是消息的接收者，`_cmd` 是 `@selector`，`...` 是可变参数列表。

- 向一般对象发送消息：调用 `objc_msgSend`
- 向 `super` 发送消息：调用 `objc_msgSendSuper`
- 返回值是一个结构体：调用 `objc_msgSend_stret` 或 `objc_msgSendSuper_stret`。

#### 2.运行时定义的数据结构

```c
typedef struct objc_class *Class;
typedef struct objc_object *id;

struct objc_object {
    Class isa;
}

/// 不透明结构体，selector
typepef struct objc_selector *SEL;

/// 函数指针，用于表示对象方法的实现
typedef id (*IMP)(id SEL, ...);
复制代码
```

`id` 指代 `objc` 中的对象，每个对象在内存的结构并不是确定的，但其首地址指向的肯定是 `isa`。通过 `isa` 指针，运行时就能获取到 `objc_class`。

`objc_class` 表示对象的 Class，它的结构是确定的，由编译器生成。

`SEL` 表示选择器，这是一个不透明结构体，但是实际上，通常可以把它理解为一个字符串。例如 `printf("%s",@selector(isEqual:))` 会打印出 `isEqual`。运行时维护着一张 `SEL` 的表，将相同字符串的方法名映射到唯一一个 `SEL`。通过 `sel_registerName(char *name)` 方法，可以查找到这张表中方法名对应的 `SEL`。苹果提供了一个语法糖 `@selector` 用来方便地调用该函数。

实际上消息发送，最终都会转换成调用 C 函数。`objc_msgSend` 的实际动作就是，找到这个函数指针，然后调用它。

#### 3.`objc_msgSend` 的动作

为了加快速度，苹果对这个方法做了很多优化，这个方法是用汇编实现的。下面是 `objc_msgSend` 的方法实现的伪代码，来自 [这里](https://link.juejin.cn?target=)：

```c
id objc_msgSend(id self, SEL op, ...) {
    if (!self) return nil;
    // 关键代码(a)
    Imp imp = class_getMethodImplementation(self->isa, SEL op);
    imp(self, op, ...);  // 调用这个函数，伪代码...
}

// 查找 IMP
IMP calss_getMethodImplementation(Class cls, SEL self) {
    if (!cls || !sel) return nil;
    IMP imp = lookUpImpOrNil(cls, sel);
    if (!imp) {
        ... // 执行动态绑定
    }
    IMP imp = lookUpOrNil(cls, sel);
    if (!imp) return _objc_msgForward; // 这个用于消息转发的
    return imp;
}

// 遍历继承链，查找 IMP
IMP lookUpImpOrNil(Class cls, SEL sel) {
    if (!cls->initialize()) {
        _class_initialize(cls);
    }
    Class curClass = cls;
    IMP imp = nil;
    do {  // 先查缓存，缓存没有时重建，仍旧没有则向父类查询
        if (!curClass) break;
        if (!curClass->cache) fill_cache(cls, curClass);
        imp = cache_getImp(curClass, sel);
        if (imp) break;
    } while (curClass = curClass->superclass); // 关键代码(b)
    return imp;
}

复制代码
```

`objc_msgSend` 的动作比较清晰：首先在 Class 中的缓存查找 `imp`（没缓存则初始化缓存），如果没找到，则向父类的 Class 查找。如果一直查到到根类仍旧没有实现，则用 `_objc_msgForward` 函数指针代替 `imp`。最后，执行这个 `imp`。

`_objc_msgForward` 是用于消息转发的，当方法没有被寻找到的时候，就会触发消息转发流程。

#### 4.消息转发

当一个对象能接收一个消息时，就会走正常的方法调用流程。但如果一个对象无法接收指定消息时，又会发生什么事呢？默认情况下，如果是以 `[receiver message]` 的方式调用方法，那么如果 `receiver` 无法响应 `message` 消息时，编译器就会报错。但如果是 `perform...` 的形式来调用，则需要等到运行时才能确定 `receiver` 是否能接受 `message` 消息。如果不能，则程序崩溃。

通常，当我们不能确定一个对象是否能接收某个消息时，会先调用 `respondsToSelector:` 来判断一下：

```objc
if ([self respondsToSelector:@selector(method)]) {
    [self performSelector:@selector(method)];
}
复制代码
```

不过，我们不讨论使用 `respondsToSelector:` 判断的情况，这才是我们的重点。

当一个对象无法接收某一消息时，就会启动所谓的 `消息转发（message forwarding）` 机制，通过这一机制，我们可以告诉对象如何处理未知的消息。默认情况下，对象接收到未知的消息，会导致程序崩溃。

那我们来正式说一下 **消息转发** 的流程，可以分为三个阶段：

1. 方法解析
2. 重定向
3. 消息转发

来看一下这三个阶段具体做的事情：

##### 1.方法解析

当 runtime 在方法缓存列表和方法分发列表（包括超类）中找不到要执行的方法时，首先会进入方法解析阶段，此时可以在方法解析中动态添加方法实现。具体来看是两个方法：`+resolveInstanceMethod:` 和 `+resolveClassMethod:`，分别对应实例方法和类方法找不到实现的情况，我们可以在方法解析中动态添加方法实现。

如下面这个例子：

```objc
#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

- (void)methodWithoutImplementation;    // 定义一个没有实现的方法

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self methodWithoutImplementation];   // 调用没有实现的方法
}

/**
 动态添加的方法（OC 的方法其实只是一个 C 函数，不过它默认带了两个参数，一个是 id self. 另外一个是 SEL _cmd）
 */
void resolveMethod(id self, SEL _cmd) {
    NSLog(@"%s",__func__);
}


/**
 runtime 调用方法解析

 @param sel 方法的 selector
 @return NO：解析方法失败，YES：已处理
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(methodWithoutImplementation)) {
        class_addMethod([self class], sel, (IMP)resolveMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

@end
复制代码
```

可以看到主要是根据 `sel` 去判断当前需要解析的方法是哪一个，然后通过 `class_addMethod::::` 方法去动态添加一个方法，我们来看一下 `class_addMethod::::` 的定义：

```objc
class_addMethod(Class cls, SEL name, IMP imp, const char *types);
复制代码
```

我们分别来看一下这四个参数对应的意思：

1. `Class cls` : 这是你要指定的类，runtime 会到这个类中去找方法
2. `SEL name` : 这是要解析的那一个方法
3. `IMP` : 这是动态添加的方法实现的 `imp`
4. `const char *types` : 类型编码，是个字符串（更多关于[类型编码](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FCocoa%2FConceptual%2FObjCRuntimeGuide%2FArticles%2FocrtTypeEncodings.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40008048-CH100-SW1)）

如果你想让转发过程继续，那么就让 `resolveInstnceMethod:` 返回 `NO`。

##### 2.重定向

在消息转发机制执行前，系统会再给我们一次偷梁换柱的机会，即通过重载 `-(id)forwardingTargetForSelector:(SEL)sel` 方法替换消息的接受者为其他对象，毕竟消息转发需要耗费更多的时间，抓住这次机会将消息重定向给别人是个不错的选择，如果此方法返回 `nil` 或是 `self`，则会进入消息转发阶段，否则将会向返回的对象重新发送消息（其实这一步也可以算入转发阶段，因为重定向会将消息「转发」给另一个对象，不过为了方便理解，所以我们称其为 「重定向」）。

来看一下下面这个例子：

```objc
#import "ViewController.h"

@interface RedirectB : NSObject

- (void)redirectMethod;

@end

@implementation RedirectB

- (void)redirectMethod {
    NSLog(@"%s",__func__);
}

@end

@interface RedirectA : NSObject

- (void)redirectMethod;

@end

@implementation RedirectA

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *selStr = NSStringFromSelector(aSelector);
    if ([selStr isEqualToString:@"redirectMethod"]) {
        return [RedirectB new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RedirectA *a = [RedirectA new];
    [a redirectMethod];
    redirectMethod
 }

@end
复制代码
```

在 `RedirectA` 中定义了一个没有实现的方法，在 `viewDidLoad()` 方法中调用，按照正常的逻辑，这样会造成程序崩溃。但是我们在 `RedirectA` 中实现了 `forwardingTargetForSelector:` 方法，将 `redirectMethod` 这个方法的消息转发给了 `RedirectB`，在 `RedirectB` 中我们实现了这个方法，所以可以看到控制台的打印：

```objc
-[RedirectB redirectMethod]
复制代码
```

使用这个方法通常是在对象内部（本例中就是 `RedirectA` 的内部），可能还有一系列其他对象能处理该消息，我们便可借这些对象来处理消息并返回，这样在对象外部看来，还是由该对象处理了这一消息。

这样我们就完成了消息的重定向过程，也就是一个对象无法识别的消息，我们将其转发给另外一个对象。那么我们来看一下最后的一个步骤，消息转发。

##### 3.消息转发

如果重定向还不能处理未知的消息，那么就会启动消息转发，此时会调用以下方法：

```objc
- (void)forwardInvocation:(NSInvocation *)anInvocation
复制代码
```

运行时系统会在这一步给消息接收者最后一次机会将消息转发给其他对象。对象会创建一个表示消息的 `NSInvocation` 对象，把与尚未处理的消息有关的全部细节都封装在 `anInvocation` 中，包括 `selector`、目标（target）和参数。

`forwardInvocation:` 方法的实现主要有两个任务：

1. 定位可以响应封装在 `anInvocation` 中的消息的对象，这个对象不需要能处理所有未知消息。
2. 使用 `anInvocation` 作为参数，将消息发送到选中的对象。`anInvocation` 将会保留调用结果，运行时系统会提取这一结果并将其发送到消息的原始发送者。

不过，在这个方法中可以实现一些更复杂的功能，我们可以对消息的内容进行修改，比如追回一个参数，然后再去触发消息。另外，若发现某个消息不应由本类处理，则应调用父类的同名方法，以便继承体系中的每个类都有机会处理此调用请求。

这个方法就像是一个那些不能被识别的消息的分发中心，它可以将这些消息转发给不同的对象，也可以将一个消息翻译成另外的一个消息。或者简单的吃掉某些消息，因此没有响应也没有错误。它也可以对不同的消息提供相同的响应，这一切都取决于方法的具体实现，该方法提供的是将不同对象连接到消息链的能力。

不过在此之前，我们必须重写以下方法：

```objc
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector 
复制代码
```

需要从上面的这个方法中获取的信息来创建 `NSInvocation` 对象，因此我们必须重写这个方法，为给定的 `selector` 提供一个合适的方法签名。

我们来看一个完整的示例：

```objc
#import "ViewController.h"

@interface ForwardB : NSObject

- (void)forwardMethod;

@end

@implementation ForwardB

- (void)forwardMethod {
    NSLog(@"%s",__func__);
}

@end

@interface ForwardA : NSObject

- (void)forwardMethod;

@end

@implementation ForwardA

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    // 获取 aSelector 的方法签名
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {  // 如果无法获取
        if ([ForwardB instancesRespondToSelector:aSelector]) {  // 看 ForwardB 是否能够响应 aSelector
            // 获取 ForwardB 中 aSelector 的方法签名
            signature = [ForwardB instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([ForwardB instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:[ForwardB new]];
    }
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ForwardA *a = [ForwardA new];
    [a forwardMethod];
}

@end
复制代码
```

`NSObject` 的 `forwardInvocation:` 方法只是简单调用了 `doesNotRecognizeSelector:` 方法，它不会转发任何消息。这样，如果不在以上所述的三个步骤中处理未知消息，则会引发一个异常。

小结：

在找不到方法实现的时候，首先会进入**方法解析**阶段，我们在方法解析中动态添加方法实现。如果在方法解析阶段中我们没有处理这条消息，那系统会给我们一次重定向的机会。`msgSend` 方法需要指定一个 `target`，重定向的意思就是你当前的 `target` 实现不了，那么我将这个消息转发给另一个 `target` 去实现，对应的方法是 `forwardingTargetForSelector:`。如果重定向阶段也没有找到实现，那么就正式进入消息转发阶段。在消息转发阶段需要重写两个方法，一个是获取方法签名的方法 `methodSignatureForSelector:`、另一个是 `forwardInvocation` 方法。`methodSignatureForSelector:` 如果返回 `nil`，那么转发流程就会终止。`forwardInvocation:` 是消息转发的最后一关，这个方法就像是一个那些不能被识别的消息的分发中心，它可以将这些消息转发给不同的对象，也可以将一个消息翻译成另外的一个消息。或者简单的吃掉某些消息，因此没有响应也没有错误。它也可以对不同的消息提供相同的响应，这一切都取决于方法的具体实现。该方法提供的是将不同对象连接到消息链的能力。如果在这个阶段还不处理消息，那么就会系统就会通过 `doneNotRecognizeSelector` 抛出异常，程序终止。

贴一下[Objective-C 消息发送与转发机制原理](https://link.juejin.cn?target=http%3A%2F%2Fyulingtianxia.com%2Fblog%2F2016%2F06%2F15%2FObjective-C-Message-Sending-and-Forwarding%2F) 的一张完整消息发送与转发的流程图：

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/20/16ad323580e57514~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)

### 关于 super

在 Objective-C 中，如果我们需要在类的方法中调用父类的方法时，通常都会用到 `super`，如下所示：

```objc
@interface MyViewController : UIViewController

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
复制代码
```

我们知道如何使用 `super`，但现在的问题是，它是如何工作的？

首先我们要知道 `super` 与 `self` 不同，`self` 是类的一个隐藏参数，每个方法的实现的第一个参数即为 `self`。而 `super` 并不是隐藏参数，它实际上只是一个 「编译器标识符」，它负责告诉编译器，当调用 `viewDidLoad` 方法时，去调用父类的方法，而不是本类的方法。而它**与 `self` 指向的是相同的消息接收者**。为了理解这一点，我们先来看看 `super` 的定义：

```objc
struct objc_super {
    id receiver;  // 即消息的实际接收者
    Class super_class;  // 指针当前的父类
};
复制代码
```

当我们使用 `super` 来接受消息时，编译器会生成一个 `objc_super` 结构体。就上面的例子而言，这个结构体的 `receiver` 就是 `MyViewController` 对象，与 `self` 相同；`super_class` 指向 `MyViewController` 的父类 `UIViewController`。

接下来，发送消息时，不是调用 `objc_msgSend` 函数，而是调用 `objc_msgSendSuper` 函数，其声明如下：

```objc
id objc_msgSendSuper ( struct objc_super *super, SEL op, ... );
复制代码
```

该函数第一个参数即为前面生成的 `objc_super` 结构体，第二个参数是方法的 `selector`。该函数的实际操作是：从 `objc_super` 结构体指向的 `super_class` 的方法列表开始查找 `viewDidLoad` 的 `selector`，找到后以 `objc_receiver` 去调用这个 `selector`，而此时的操作流程就是如下方式了：

```objc
objc_msgSend(objc_super->receiver, @selector(viewDidLoad))
复制代码
```

由于 `objc_super->receiver` 就是 `self` 本身，所以该方法实际与下面这个调用是相同的：

```objc
objc_msgSend(self, @selector(viewDidLoad))
复制代码
```

为了便于理解，我们看以下例子：

```objc
@interface MyClass : NSObject

- (void)test;

@end

@implementation MyClass

- (void)test {
    NSLog(@"self class is : %@", self.class);
    NSLog(@"super class is : %@", super.class);
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyClass *myClass = [MyClass new];
    [myClass test];
}

@end
复制代码
```

可以看到打印台的打印：

```objc
2019-05-20 11:16:18.510148+0800 test[67484:14868457] self class is : MyClass
2019-05-20 11:16:18.510186+0800 test[67484:14868457] super class is : MyClass
复制代码
```

从上例中可以看到，两者的输出都是 `MyClass`。

### Method Swizzling

关于 「Method Swizzling」可以看一下 [这篇文章](https://link.juejin.cn?target=http%3A%2F%2Fblog.leichunfeng.com%2Fblog%2F2015%2F06%2F14%2Fobjective-c-method-swizzling-best-practice%2F)。

Method Swizzling 是一项异常强大的技术，它允许我们 **动态的替换方法的实现**，实现 `hook` 功能，是一种比子类化更加灵活的「重写」方法的方式。

来看一下例子：

写一个 `UIViewController` 的分类：

```objc
#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(my_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)my_viewWillAppear:(BOOL)animated {
    [self my_viewWillAppear:animated];
    NSLog(@"%s",__func__);
}

@end
复制代码
```

在 `ViewController` 中调用：

```objc
#import "ViewController.h"
#import "UIViewController+Swizzling.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
复制代码
```

我们主要关注 `+load` 方法中的代码，这里面有几个关键点需要引起我们的注意：

1. 为什么是在 `+load` 方法中实现 「Method Swizzling」 的逻辑，而不是其他的什么方法，比如 `+initialize` 等？
2. 为什么 「Method Swizzling」 的逻辑需要用 `dispatch_once` 来进行调度？
3. 为什么需要调用 `class_addMethod` 方法，并且以它的结果为依据分别处理两种不同的情况？

下面我们就来逐条分析一下：

**第一个为什么**：`+load` 和 `+initialize` 是 Objective-C runtime 会自动调用的两个类方法，但是它们的调用时机是不一样的。`+load` 方法是在类被加载的时候调用的，而 `+initialize` 方法是在类或它的子类收到第一条消息之前被调用的，这里所指的消息包括实例方法和类方法调用。也就是说 `+initialize` 方法是以懒加载的方式被调用的，如果程序一直没有给某个类或它的子类发送消息，那么这个类的 `+initialize` 方法是永远不会被调用的。此外 `+load` 方法还有一个非常重要的特性，那就是子类、父类和分类中的 `+load` 方法的实现是被区别对待的。换句话说在 Objective-C runtime 自动调用 `+load` 方法时，分类中的 `+load` 方法并不会对主类中的 `+load` 方法造成覆盖。综上所述，`+load` 方法是实现 「Method Swizzling」 逻辑的最佳 「场所」。

**第二个为什么**：我们上面提到，`+load` 方法在类加载的时候会被 runtime 自动调用一次，但是它并没有限制程序员对 `+load` 方法的手动调用，所以我们所能做的就是尽可能的保证程序能够在各种情况下正常运行。

**第三个为什么**：我们使用 「Method Swizzling」的目的通常都是为了给程序增加功能，而不是完全替换某个功能，所以我们一般都需要在自定义的实现中调用原始的实现。所以这里就会有两种情况需要我们分别进行处理：

**第 1 种情况**：主类本身有实现需要替换的方法，也就是 `class_addMethod` 方法返回 `NO`。这种情况的处理比较简单，直接交换两个方法的实现就可以了：

```objc
- (void)viewWillAppear:(BOOL)animated {
    // 先调用原始实现，由于主类本身有实现该方法，所以这里实际调用的是主类的实现
    [self my_viewWillAppear:animated];
    
    // 增加的功能
    // ...
}

- (void)my_viewWillAppear:(BOOL)animated {
    // 主类的实现
}
复制代码
```

**第 2 种情况**：主类本身没有实现需要替换的方法，而是继承了父类的实现，即 `class_addMethod` 方法返回 `YES`。这时调用 `class_getInstanceMethod` 函数获取到的 `originalSelector` 指向的就是父类的方法，我们再通过执行 `lass_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));` 将父类的实现替换到我们自定义的 `my_viewWillAppear` 方法中，这样就达到了在 `my_viewWillAppear` 方法的实现中调用父类实现的目的。

```objc
- (void)viewWillAppear:(BOOL)animated {
    // 先调用原始实现，由于主类本身并没有实现该方法，所以这里实际调用的是父类的实现
    [self my_viewWillAppear:animated];
    
    // 增加的功能
    // ...
}

- (void)my_viewWillAppear:(BOOL)animated {
    // 父类的实现
}
复制代码
```

### runtime 的实际运用

关于开发实例，大家可以看一下这篇 [Runtime Method Swizzling 开发实例汇总](https://juejin.im/entry/6844903456382124040)。我这边大概列举一下：

1. 替换 ViewController 生命周期的方法
2. 解决获取索引、添加、删除元素越界崩溃的问题
3. 防止按钮重复暴力点击
4. 全局更换控件初始效果
5. App 热修复
6. App 异常占位图通用类封装
7. 全局修改导航栏后退（返回）按钮

## 



作者：_Terry
链接：https://juejin.cn/post/6844903847240925191
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。