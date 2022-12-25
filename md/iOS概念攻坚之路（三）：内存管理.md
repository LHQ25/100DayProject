## 前言

iOS 的内存管理不止是 「引用计数表」。

iOS 开发者基本都知道 iOS 是通过「引用计数」来管理内存的，但是也许并不知道 iOS 其他的内存管理方式，比如 「Tagged Pointer」（带标记的指针），比如 「NONPOINTER_ISA」（非指针型 isa），这个要根据不同的场景进行区分。

我们就这篇文章主要来谈一谈这三种内存管理方式。

## 关于内存

在说内存管理之前，我们先来说一下关于内存的概念。

> 内存是计算机中重要的部件之一，它是与 CPU 进行沟通的桥梁。计算机中所有的程序都是在内存中进行的。内存（Menory）也被成为「内存储器」和「主存储器」，其作用是用于暂时存放 CPU 中的运算数据，以及与硬盘等外部存储器交换的数据。只要计算机在运行中，CPU 就会把需要运算的数据调到内存中进行运算，当运算完成后 CPU 再将结果传送出来，内存的运行也决定了计算机的稳定运行。（来自 [度娘](https://link.juejin.cn?target=https%3A%2F%2Fbaike.baidu.com%2Fitem%2F%E5%86%85%E5%AD%98)）

在 App 启动后，系统会把 App 程序拷贝到内存中，然后在内存中执行代码。

内存的概念大家多多少少都有点了解，我们也不说那么多。一块内存条，是一个从下至上、地址依次递增结构。来看一下内存的分区：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/29/16b018e30b609882~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



上面这张图来自 [这里](https://link.juejin.cn?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2F7bbbe5d55440)。

大致说一下 iOS 内存分区的情况，五大区域：

- 栈区（Stack）
  - 由编译器自动分配释放，存放函数的参数，局部变量的值等
  - 栈是向低地址扩展的数据结构，是一块连续的内存区域
- 堆区（Heap）
  - 由程序员分配释放
  - 是向高地址扩展的数据结构，是不连续的内存区域
- 全局区
  - 全局变量和静态变量的存储是放在一块的，初始化的全局变量和静态变量在一块区域，未初始化的全局变量和未初始化的静态变量在相邻的另一块区域
  - 程序结束后由系统释放
- 常量区
  - 常量字符串就是放在这里的
  - 程序结束后由系统释放
- 代码区
  - 存放函数体的二进制代码

另外说一下一些值得注意的地方：

1. 在 iOS 中，堆区的内存是应用程序内共享的，一个应用程序其实就是一个进程，也就是进程内的内存是共享的。堆中的内存分配是需要程序员负责的
2. 系统使用一个链表来维护所有已经分配的内存空间（系统仅仅记录，并不管理具体的内容）
3. 变量使用结束后，需要释放内存，OC 中是判断引用计数是否为 0，如果是就说明没有任何变量使用该空间，那么系统将其回收
4. 当一个 app 启动后，代码区、常量区、全局区大小就已经固定，因此指向这些区的指针不会产生崩溃性的错误。而堆区和栈区是时时刻刻变化的（堆的创建销毁，栈的弹入弹出），所以当使用一个指针指向这个区里面的内存时，一定要注意内存是否已经被释放，否则会产生程序崩溃（也即是野指针报错）

## Tagged Pointer

> 为了节省内存和提高执行效率，苹果提出了 `Tagged Pointer` 的概念。对于 64 位程序，引入 `Tagged Pointer` 后，相关逻辑能减少一半的内存占用，以及 3 倍的访问速度提升，100 倍的创建、销毁速度提升。

（有没有那么牛逼咱也不知道，咱也不敢问）

我们先看看原有的对象为什么会浪费内存，假设我们要存储一个 `NSNumber` 对象，其值是一个整数。正常情况下，如果这个整数只是一个 `NSInteger` 的普通变量，那么它所占用的内存是与 `CPU` 的位数有关，在 32 位 CPU 下占 4 个字节，在 64 位 CPU 下是占 8 个字节的。而指针类型的大小通常也是与 CPU 位数相关的，一个指针所占用的内存在 32 位 CPU 下为 4 个字节，在 64 位 CPU 下也是 8 个字节。

所以一个普通的 iOS 程序，如果没有 `Tagged Pointer` 对象，从 32 位机器迁移到 64 位机器中后，虽然逻辑没有任何变化，但这种 `NSNumber`、`NSDate` 一类的对象所占用的内存会翻倍。

我们再来看看效率上的问题，为了存储和访问一个 `NSNumber` 对象，我们需要在堆上为其分配内存，另外还要维护它的引用计数，管理它的生命周期。这些都给程序增加了额外的逻辑，造成了运行效率上的损失。

所以为了改进上面提到的内存占用和效率问题，苹果提出了 `Tagged Pointer` 对象，由于 `NSNumber`、`NSDate` 一类的变量本身的值需要占用的内存大小常常不需要 8 个字节，拿整数来说，4 个字节所能表示的有符号整数就可以达到 20 多亿（2 ^ 31 = 2147483648，另外 1 位作为符号位），对于绝大多数情况都是可以处理的。

所以我们可以将一个对象的指针拆分成两部分，一部分直接保存数据，另一部分作为特殊标记，表示这是一个特别的指针，不指向任何一个地址。

Tagged Pointer 特点：

1. `Tagged Pointer` 专门用来存储小的对象，例如 `NSNumber` 和 `NSDate`
2. `Tagged Pointer` 指针的值不再是地址了，而是真正的值。所以，实际上它不再是一个对象了，它只是一个披着对象皮的**普通变量**而已。所以，它的内存并不存储在堆中，也不需要 `malloc` 和 `free`
3. 在内存读取上有着 3 倍的效率，创建时比以前快 106 倍
4. `objc_msgSend` 能识别 `Tagged Pointer`，比如 `NSNumber` 的 `intValue` 方法，直接从指针提取数据
5. 使用 `Tagged Pointer` 后，指针内存储的数据变成了 `Tag + Data`，也就是将数据直接存储在了指针中

## NONPOINTER_ISA

苹果将 `isa` 设计成了联合体，在 `isa` 中存储了与该对象相关的一些内存的信息，原因也如上面所说，并不需要 64 个二进制位全部都用来存储指针。

来看一下 `isa` 的结构：

```arduino
// x86_64 架构
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

// arm64 架构
struct {
    uintptr_t nonpointer        : 1;  // 0:普通指针，1:优化过，使用位域存储更多信息
    uintptr_t has_assoc         : 1;  // 对象是否含有或曾经含有关联引用
    uintptr_t has_cxx_dtor      : 1;  // 表示是否有C++析构函数或OC的dealloc
    uintptr_t shiftcls          : 33; // 存放着 Class、Meta-Class 对象的内存地址信息
    uintptr_t magic             : 6;  // 用于在调试时分辨对象是否未完成初始化
    uintptr_t weakly_referenced : 1;  // 是否被弱引用指向
    uintptr_t deallocating      : 1;  // 对象是否正在释放
    uintptr_t has_sidetable_rc  : 1;  // 是否需要使用 sidetable 来存储引用计数
    uintptr_t extra_rc          : 19;  // 引用计数能够用 19 个二进制位存储时，直接存储在这里
};
复制代码
```

注意这里的 `has_sidetable_rc` 和 `extra_rc`，`has_sidetable_rc` 表明该指针是否引用了 sidetable 散列表，之所以有这个选项，是因为少量的引用计数是不会直接存放在 SideTables 表中的，对象的引用计数会先存放在 `extra_rc` 中，当其被存满时，才会存入相应的 SideTables 散列表中，SideTables 中有很多张 SideTable，每个 SideTable 也都是一个散列表，而引用计数表就包含在 SideTable 之中。

## SideTables

### 原理

引用计数要么存放在 `isa` 的 `extra_rc` 中，要么存放在引用计数表中，而引用计数表包含在一个叫 `SideTable` 的结构中，它是一个散列表，也就是哈希表。而 `SideTable` 又包含在一个全局的 `StripeMap` 的哈希映射表中，这个表的名字叫 `SideTables`。

> 散列表（Hash table，也叫哈希表），是根据建（Key）而直接访问在内存存储位置的数据结构。也就是说，它通过一个关于键值得函数，将所需查询的数据映射到表中一个位置来访问记录，这加快了查找速度。这个映射函数称作散列函数，存放记录的数组称作散列表。

来看一下 `NSObject.mm` 中它们对应的源码：

```arduino
// SideTables
static StripedMap<SideTable>& SideTables() {
    return *reinterpret_cast<StripedMap<SideTable>*>(SideTableBuf);
}

// SideTable
struct SideTable {
    spinlock_t slock;           // 自旋锁
    RefcountMap refcnts;        // 引用计数表
    weak_table_t weak_table;    // 弱引用表
    
    // other code ...
};
复制代码
```

它们的关系如下图：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/29/16b012da8cb35264~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



一个 `SideTables` 包含众多 `SideTable`，每个 `SideTable` 中又包含了三个元素，`spinlock_t` 自旋锁、`RefcountMap` 引用计数表、`weak_table_t` 弱引用表。所以既然 `SideTables` 是一个哈希映射的表，为什么不用 `SideTables` 直接包含自旋锁，引用计数表和弱引用表呢？这是因为在众多线程同时访问这个 `SideTable` 表的时候，为了保证数据安全，需要给其加上自旋锁，如果只有一张 `SideTable` 的表，那么所有数据访问都会出一个进一个，单线程进行，非常影响效率，虽然自旋锁已经是效率非常高的锁，这会带来非常不好的用户体验。针对这种情况，将一张 `SideTable` 分为多张表的 `SideTables`，再各自加锁保证数据的安全，这样就增加了并发量，提高了数据访问的效率，这就是为什么一个 `SideTables` 下涵盖众多 `SideTable` 表的原因。

> 自旋锁：计算机科学用于多线程同步的一种锁，线程会反复检查锁变量是否可用。由于线程在这一过程中保持执行（没有进入休眠），因此是一种忙等。一旦获取了自旋锁，线程会一直保持该锁，直至显式释放自旋锁。

自旋锁适用于小型数据、耗时很少的操作，速度很快。

弱引用表也是一张哈希表的结构，其内部包含了每个对象对应的弱引用表 `weak_entry_t`，而 `weak_entry_t` 是一个结构体数组，其中包含的则是**每一个对象弱引用的对象**所对应的弱引用指针。

### 如何进行引用计数操作

当需要去查找一个对象对应的 `SideTable` 并进行引用计数或者弱引用计数的操作时，系统又是怎样实现的呢？

当一个对象访问 `SideTables` 时：

1. 首先会取得对象的地址，将地址进行哈希运算，与 `SideTables` 中 `SideTable` 的个数取余，最后得到的结果就是该对象所要访问的 `SideTable`
2. 在取得的 `SideTable` 中的 `RefcountMap` 表中再进行一次哈希查找，找到该对象在引用计数表中对应的位置
3. 如果该位置存在对应的引用计数，则对其进行操作，如果没有对应的引用计数，则创建一个对应的 `size_t` 对象，其实就是一个 `uint` 类型的无符号整型

## 引用计数

> 引用计数（Reference Count）是一个简单而有效的管理对象生命周期的方式。当我们创建一个新对象的时候，它的引用计数为 1，当有一个新的指针指向这个对象时，我们将其引用计数加 1，当某个指针不再指向这个对象时，我们将其引用计数减 1，当对象的引用计数变为 0 时，说明这个对象不再被任何指针指向了，这个时候我们就可以将对象销毁，回收内存。

上面是唐巧的 [理解 iOS 的内存管理](https://link.juejin.cn?target=https%3A%2F%2Fblog.devtang.com%2F2016%2F07%2F30%2Fios-memory-management%2F) 中对引用计数的一个定义，简单来说就是采取计数的方式对内存进行管理，内存首先需要被创建出来，然后有人用这块内存，计数 `+1`，那个人不用了，计数 `-1`，如果计数为 `0`，释放它。

当然，创建、使用、释放是有一个规则的，来看一下 iOS 中内存管理的思考方式：

- 自己生成的对象，自己所持有
- 非自己生成的对象，自己也能持有
- 不再需要自己持有的对象时释放
- 非自己持有的对象无法释放

与之对应的 Objective-C 方法：

| 对象操作       | Objective-C 方法                  |
| -------------- | --------------------------------- |
| 生成并持有对象 | alloc/new/copy/mutableCopy 等方法 |
| 持有对象       | retain 方法                       |
| 释放对象       | release 方法                      |
| 废弃对象       | dealloc 方法                      |

这些有关 Objective-C 内存管理的方法，实际上不包括在 Objective-C 语言中，而是包含在 Cocoa 框架中用于 OS X，iOS 应用开发，swift 也采用引用计数的方式进行内存管理。Cocoa 框架中 Foundation 框架类库的 NSObject 类担负内存管理的职责。Objective-C 内存管理中的 `alloc/retain/release/dealloc` 方法分别指代 NSObject 类的 `+alloc`、`-retain`、`-release`、`-dealloc` 方法。

而引用计数又分为 **MRC（Manual Reference Counting，手动引用计数）** 和 **ARC（Automatic Reference Counting，自动引用计数）**。

我们来看一下官方对于自动引用计数的说明：

> 在 Objective-C 中采用 Automatic Reference Counting（ARC）机制，让编译器来进行内存管理。在新一代 Apple LLVM 编译器(LLVM 3.0 或以上)中设置 ARC 为有效状态，就无需再次键入 retain 或者 release 代码，这在降低程序崩溃、内存泄漏等风险的同时，很大程度上减少了开发程序的工作量。编译器完全清楚目标对象，并能立刻释放那些不再被使用的对象，如此一来，应用程序将具有可预测性，且能流畅运行，速度也将大幅提升。

其实最主要的是一点：

**在 LLVM 编译器中设置 ARC 为有效状态，就无需再次键入 retain 或者是 release 代码**。

那么我们也就知道了 MRC 是怎么回事了，MRC 就是需要程序员手动插入 `retain`、`release` 等管理内存的代码，不过现在 MRC 已经属于远古时代的事情了，这里只是顺便提提，我们主要看 ARC，ARC 其实做的事情不止是自动插入管理内存的方法，还做了一些优化，我们放到后面一点讲。我们先来看看 `alloc/retain/release/dealloc` 这几个方法的大致实现，这里有一份编译好的 [runtime 源码](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FRetVal%2Fobjc-runtime%2Ftree%2Fobjc.750)，版本是 `objc4-750`，或者大家可以到 [opensource.apple](https://link.juejin.cn?target=https%3A%2F%2Fopensource.apple.com%2Fsource%2Fobjc4%2F) 去下载。

### alloc

`NSObject` 中类方法 `alloc` 做的事情：

首先看看 `alloc` 方法的实现：

```python
+ (id)alloc {
    return _objc_rootAlloc(self);
}
复制代码
```

`alloc` 中调用 `_objc_rootAlloc()`。

```javascript
id 
_objc_rootAlloc(Class cls)
{
    return callAlloc(cls, false/*checkNil*/, true/*allocWithZone*/);
}
复制代码
```

`_objc_rootAlloc` 中调用 `callAlloc()`。

```arduino
static ALWAYS_INLINE id
callAlloc(Class cls, bool checkNil, bool allocWithZone=false)
{
    // some code ...
    
    id obj = class_createInstance(cls, 0);
    return obj;
    
}

复制代码
```

省略了一部分代码，`callAlloc` 中会调用 `class_createInstance()` 。

```scss
id 
class_createInstance(Class cls, size_t extraBytes)
{
    return _class_createInstanceFromZone(cls, extraBytes, nil);
}
复制代码
```

`class_createInstance()` 中直接调用 `_class_createInstanceFromZone`，调用 `calloc` 方法分配内存。

```scss
static __attribute__((always_inline)) 
id
_class_createInstanceFromZone(Class cls, size_t extraBytes, void *zone, 
                              bool cxxConstruct = true, 
                              size_t *outAllocatedSize = nil)
{

    // some code ...
    id obj;
    obj = (id)calloc(1, size);  // 此时分配内存
    obj->initInstanceIsa(cls, hasCxxDtor);
    return obj;
}
复制代码
```

`_class_createInstanceFromZone` 中会调用 `obj->initInstanceIsa()`，以下就是初始化的方法了，此时内存已经分配。

```arduino
inline void 
objc_object::initInstanceIsa(Class cls, bool hasCxxDtor)
{
    initIsa(cls, true, hasCxxDtor);
}
复制代码
```

`initInstanceIsa()` 中调用 `initIsa()`。

```ini
inline void 
objc_object::initIsa(Class cls, bool nonpointer, bool hasCxxDtor) 
{ 
    if (!nonpointer) {
        isa.cls = cls;
    } else {
        isa_t newisa(0);

#if SUPPORT_INDEXED_ISA
        newisa.bits = ISA_INDEX_MAGIC_VALUE;
        newisa.has_cxx_dtor = hasCxxDtor;
        newisa.indexcls = (uintptr_t)cls->classArrayIndex();
#else
        newisa.bits = ISA_MAGIC_VALUE;
        newisa.has_cxx_dtor = hasCxxDtor;
        newisa.shiftcls = (uintptr_t)cls >> 3;
#endif
        isa = newisa;
    }
}
复制代码
```

这里就是对 `isa` 的一个初始化。

所以关于 `alloc` 方法，其大概步骤如下：

1. `alloc/allocWithZone`
2. `class_createInstance` / `initInstanceIsa`
3. `calloc` (在这一步开始分配内存)
4. `initIsa` (初始化 `isa` 指针里面的内容)

关于 NSObject 的源码解析大家可以看看以下两篇文章：

[iOS底层探索 - 实例对象的创建](https://link.juejin.cn?target=http%3A%2F%2Fsaveload.me%2Fios-explore-instance-alloc%2F)

[iOS NSObject.mm 源码解析](https://link.juejin.cn?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2F452bcf7eedb2)

#### `slowpath` 和 `fastpath`

这里我想提一嘴 `slowpath` 和 `fastpath`，看一下 `callAlloc` 的完整实现：

```scss
static ALWAYS_INLINE id
callAlloc(Class cls, bool checkNil, bool allocWithZone=false)
{
    if (slowpath(checkNil && !cls)) return nil;

#if __OBJC2__
    if (fastpath(!cls->ISA()->hasCustomAWZ())) {
        if (fastpath(cls->canAllocFast())) {
            // No ctors, raw isa, etc. Go straight to the metal.
            bool dtor = cls->hasCxxDtor();
            id obj = (id)calloc(1, cls->bits.fastInstanceSize());
            if (slowpath(!obj)) return callBadAllocHandler(cls);
            obj->initInstanceIsa(cls, dtor);
            return obj;
        }
        else {
            // Has ctor or raw isa or something. Use the slower path.
            id obj = class_createInstance(cls, 0);
            if (slowpath(!obj)) return callBadAllocHandler(cls);
            return obj;
        }
    }
#endif
    if (allocWithZone) return [cls allocWithZone:nil];
    return [cls alloc];
}
复制代码
```

注意到方法中使用到的 `slowpath` 和 `fastpath`，其实这两个都是宏定义，与代码逻辑本身无关，定义如下：

```scss
// x 很可能不为 0，希望编译器进行优化
#define fastpath(x) (__builtin_expect(bool(x), 1))
// x 很可能为 0，希望编译器进行优化
#define slowpath(x) (__builtin_expect(bool(x), 0))
复制代码
```

其实它们是所谓的快路径和慢路径，为了解释这个，我们来看一段代码：

```kotlin
if (x)
    return 1;
else 
    return 39;
复制代码
```

由于计算机并非一次只读取一条指令，而是读取多条指令，所以在读到 `if` 语句时也会把 `return 1` 读取进来。如果 `x` 为 0，那么会重新读取 `return 39`，重读指令相对来说比较耗时。

如果 `x` 有非常大的概率是 0，那么 `return 1` 这条指令每次不可避免的会被读取，并且实际上几乎没有机会执行，造成了不必要的指令重读。

因此，在苹果定义的两个宏中，`fastpath(x)` 依然返回 `x`，只是告诉编译器 `x` 的值一般不为 0，从而编译可以进行优化。同理，`slowpath(x)` 表示 `x` 的值很可能为 0，希望编译器进行优化。

这个例子的讲解来自 bestsswifter 的 [深入理解GCD](https://link.juejin.cn?target=https%3A%2F%2Fbestswifter.com%2Fdeep-gcd%2F)，大家感兴趣可以看看。

所以以下代码的解释就出来了：

```lua
// 很可能 cls 是有值的，编译器可以不用每次都读取 return nil 指令
 if (slowpath(checkNil && !cls)) return nil;
复制代码
```

`fastpath` 也是同样的机制，但是大家要知道，当 `checkNil && !cls` 判断成立的时候，`return nil` 指令还是会被读取，然后执行的。

还有一个就是 `#if __OBJ2__`、`#endif`，如果查看源码的话，还会碰到 `#if !__LP64__`、`#elif 1`、`#else` 这类的宏判断，这是因为苹果针对不同的版本做了不同的实现，比如 32 位架构下和 64 位架构下的实现，有一些代码在不同的情况下是不需要参与编译的，其实也跟我们平时的 `if-else` 是一样的概念。

### retain & release

`retain` 方法用于增加引用计数，`release` 用于减少引用计数。那么引用计数存储在哪里？其实有两个地方，一个是 `NONPOINTER_ISA`，也就是非指针型 `isa` 中，`isa` 有个 `extra_rc` 属性，就是用于存放引用计数的，在 ARM 64 下，`extra_rc` 占 19 位。

`extra_rc` 只会保存额外的自动引用计数，对象的实际的引用计数会在这个基础上 +1。当 `isa` 的 `extra_rc` 中存不下的时候，会使用 `SideTable` 来存储，`SideTable` 中包含了我们大家都知道的引用计数表。

通过引用计数表管理引用计数的好处在于：

1. 对象用内存块分配无需考虑内存块头部
2. 引用计数表各记录中存有内存块地址，可从各个记录追溯到各对象的内存块

第二点在调试时有着举足轻重的作用，即使出现故障导致对象占用的内存块损坏，但只要引用计数表没有被破坏，就能够确认各内存块的位置。另外，在利用工具检测内存泄漏时，引用计数表的记录也有助于检测各个对象的持有者是否存在。

如果想了解 `retain` 和 `release` 的底层实现，可以看一下 [黑箱中的 retain 和 release](https://link.juejin.cn?target=https%3A%2F%2Fdraveness.me%2Frr)。

### autorelease

#### 简介

顾名思义，`autorelease` 就是自动释放。这看上去很像 ARC，但实际上它更类似于 C 语言中自动变量（局部变量）的特性。

> 在计算机编程领域，**自动变量**（Automatic Variable）指的是局部作用域**变量**，具体来说即是在控制流进入**变量**作用域时系统**自动**为其分配存储空间，并在离开作用域时释放空间的一类**变量**。

程序执行时，若某自动变量超出其作用域，该自动变量将被自动废弃。

`autorelease` 会像 C 语言的自动变量那样来对待对象实例，当超出其作用域（相当于变量作用域）时，对象实例的 `release` 实例方法被调用。另外，同 C 语言的自动变量不同的是，编程人员可以设定变量的作用域。



需要被自动释放的对象会被添加到离它最近的自动释放池中（AutoreleasePool），我们先明确什么对象会自动加入自动释放池：

1. MRC 下需要对象调用 `autorelease` 才会入池，ARC 下可以通过 `__autoreleasing` 修饰符，否则的话看方法名，通过 `alloc/new/copy/mutablecopy` 以外的方法取得的对象，编译器帮我们自动加入 autoreleasepool。（使用 `alloc/new/copy/mutablecopy` 方法进行初始化时，由系统管理对象，在适当的位置 `release`，不加入 autoreleasepool）
2. 使用 `array` 会自动将返回对象注册到 autoreleasepool
3. `__weak` 修饰的对象，为了保证在引用时不被废弃，会被注册到 autoreleasepool 中
4. `id` 的指针或对象的指针，在没有显式指定时会被注册到 autoreleasepool 中

那 Autorelease 的对象什么时候释放？

在没有手动添加 AutoreleasePool 的情况下，Autorelease 对象是在当前的 `runloop` 迭代结束时释放的，而它能够释放的原因是**系统在每个 runloop 迭代中都加入了自动释放池的 Push 和 Pop**。

App 启动后，苹果在主线程 `runLoop` 里注册了两个 `Observer`，其回调都是 `_wrapRunLoopWithAutoreleasePoolHandler()`。

第一个 `Observer` 监视的事件是 `Entry(即将进入 loop)`，其回调会调用 `_objc_autoreleasePoolPush()` 创建自动释放吃。其 `order` 是 `-2147483647`，优先级最高，保证创建释放池发生在其他所有回调之前。

第二个 `Observer` 监视了两个事件：`BeforeWaiting(准备进入休眠)` 时调用 `_objc_autoreleasePoolPop()` 和 `_objc_autoreleasePoolPush()` 释放旧的池并创建新池；`Exit(即将退出 Loop)` 时调用 `_objc_autoreleasePoopPop()` 来释放自动释放池，这个 `Observer` 的 `order` 是 `2147483647`，优先级最低，保证释放池释放发生在其他所有回调之后。

在主线程执行的代码，通常是写在诸如事件回调、Timer 回调内的。这些回调会被 `RunLoop` 创建好的 `AutoreleasePool` 环绕着，所以不会出现内存泄漏，开发者也不必显式创建 Pool。

#### 使用方法

`autorelease` 的具体使用方法如下：

1. 生成并持有 `NSAutoreleasePool` 对象
2. 调用已分配对象的 `autorelease` 实例方法
3. 废弃 `NSAutoreleasePool` 对象

`NSAutoreleasePool` 对象的生存周期相当于 C 语言变量的作用域，对于所有调用过 `autorelease` 实例方法的对象，在废弃 `NSAutoreleasePool` 对象时，都将调用 `release` 实例方法。

```ini
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

id obj = [[NSObject alloc] init];

[obj autorelease];

[pool drain];    // 等同于 [obj release]
复制代码
```

在 Cocoa 框架中，相当于程序主循环的 `NSRunLoop` 或者在其他程序可运行的地方，对 `NSAutoreleasePool` 对象进行生成、持有和废弃处理。因此，开发者一般不需要使用手动创建释放池。Objective-C 的 `main.m` 的 `UIApplicationMain` 方法就是被一个自动释放池环绕着的，也就是说，整个 iOS 应用都是包含在一个自动释放池 `block` 中：

```objectivec
int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
复制代码
```

不过，在大量产生 `autorelease` 的对象时，只要不废弃 `NSAutoreleasePool` 对象，那么生成的对象就不能被释放，因此有时会由于内存不足而到达内存峰值。典型的例子是读入大量图片的同时改变其尺寸，图像文件读入到 `NSData` 对象，并从中生成 `UIImage` 对象，改变该对象尺寸后生成新的 `UIImage` 对象。这种情况下，就会大量产生 `autorelease` 的对象：

```css
for (int i = 0; i < 图像数 ; ++i) {
    /* 读入图像
     * 大量产生 autorelease 的对象
     * 由于没有废弃 NSAutoreleasePool 对象
     * 最终导致内存不足!
     */
}
复制代码
```

在这种情况下，有必要在适当的地方生成、持有或废弃 `NSAutoreleasePool` 对象：

```ini
for (int i = 0; i < 图像数; ++i) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    /*
     * 读入图像
     * 大量产生 autorelease 的对象
     */
     
    [pool drain];
    
    /*
     * 通过 [pool drain],
     * autorelease 的对象被一起 release。
     */
}
复制代码
```

在 ARC 下我们使用 `@autoreleasepool{}` 将代码环绕即可。

#### 原理

那么系统是如何实现 Autorelease 的，在 ARC 下，我们使用 `@autoreleasepool{}` 来使用一个 `AutoreleasePool`，随后编译器将其改写成下面的样子：

```scss
void *context = objc_autoreleasePoolPush();
// {} 中的代码
objc_autoreleasePoolPop(context);
复制代码
```

这两个函数都是对 `AutoreleasePoolPage` 的简单封装，所以自动释放机制的核心就在于这个类。

```arduino
class AutoreleasePoolPage 
{
    magic_t const magic;
    id *next;
    pthread_t const thread;
    AutoreleasePoolPage * const parent;
    AutoreleasePoolPage *child;
    uint32_t const depth;
    uint32_t hiwat;
    
    // other code ...
}
复制代码
```

`AutoreleasePoolPage` 是一个 C++ 实现的类。

- `AutoreleasePool` 并没有单独的结构，而是由若干个 `AutoreleasePoolPage` 以双向链表的形式组合而成（分别对应结构中的 `parent` 指针和 `child` 指针）
- `AutoreleasePool` 是按线程一一对应的（结构中的 `thread` 指针指向当前线程）
- `AutoreleasePoolPage` 每个对象会开辟 `4096` 字节内存（也就是虚拟内存一页的大小），除了上面的实例变量所占空间，剩下的空间全部用来储存 `autorelease` 对象的地址
- 上面的 `id *next` 指针作为游标（哨兵对象）指向栈顶最新 `add` 进来的 `autorelease` 对象的下一个位置
- 一个 `AutoreleasePoolPage` 的内存被占满时，会新建一个 `AutoreleasePoolPage` 对象，连接链表，后来的 `autorelease` 对象会被添加到新的 `page` 中

所以，若当前线程中只有一个 `AutoreleasePoolPage` 对象，并记录了很多 `autorelease` 对象地址，如下图：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/28/16afd37e567b1a53~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



图中的情况，这一页再加入一个 `autorelease` 对象就要满了（也就是 `next` 指针马上指向栈顶），这时就要执行上面说的操作，建立下一页 `page` 对象，与这一页链表连接完成后，新的 `page` 的 `next` 指针被初始化在栈底（`begin` 的位置），然后继续向栈顶添加新对象。

所以，向一个对象发送 `autorelease` 消息，就是将这个对象加入到当前的 `AutoreleasePoolPage` 的栈顶 `next` 指针指向的位置。



每当进行一次 `objc_autoreleasePoolPush` 调用时，`runtime` 向当前的 `AutoreleasePoolpage` 中 `add` 进一个 `哨兵对象`，值为 0（也就是个 `nil`），那么这一个 `page` 就变成了下面的样子：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/28/16afd93000259e55~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



`objc_autoreleasePoolPush` 的返回值正是这个哨兵对象的地址，被 `objc_autoreleasePoolPop(哨兵对象)` 作为入参，所以：

1. 根据传入的哨兵对象地址找到哨兵对象所处的 `page`
2. 在当前 `page` 中，将晚于哨兵对象插入的所有 `autorelease` 对象都发送一次 `-release` 消息，并向回移动 `next` 指针到正确位置，从最新加入的对象一直向前清理，可以向前跨越若干个 `page`，直到哨兵对象所在的 `page`

刚才的 `objc_autoreleasePoopPop` 执行后，最终变成了下面的样子：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/5/28/16afdf9f71fb1ddb~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



知道了上面的原理，嵌套的 `AutoreleasePool` 就非常简单了，`pop` 的时候总会释放到上次 `push` 的位置，多层的 `pool` 就是多个哨兵对象而已，就像剥洋葱一样，每次一层，互不影响。

在对象的引用计数归零时，会调用 `dealloc` 方法回收对象。

原理部分的讲解来自于孙源大神的 [黑幕背后的Autorelease](https://link.juejin.cn?target=https%3A%2F%2Fblog.sunnyxx.com%2F2014%2F10%2F15%2Fbehind-autorelease%2F)，讲的非常好，大家可以看看。

另外说一下 ARC 中对 `autorelease` 和 `retain` 的一些优化：

如果 ARC 在运行时检测到类函数中的 `autorelease` 后紧跟着一个 `retain` 操作，此时不直接调用对象的 `autorelease` 方法，而是改为调用 `objc_autoreleaseReturnValue`。`objc_autoreleaseReturnValue` 会检视当前方法返回之后将要执行的那段代码，若那段代码要在返回对象上执行 `retain` 操作，则设置全局数据结构中的一个标志位，而不执行 `autorelease` 操作，与之相似，如果方法返回了一个自动释放的对象，而调用方法的代码要保留此对象，那么此时不直接执行 `retain`，而是改为执行 `objc_retainAutoreleasedReturnValue` 函数。此函数要检测刚才提到的标志位，若已经置位，则不执行 `retain` 操作，设置并检测标志位，要比调用 `autorelease` 和 `retain` 更快。

### dealloc

当对象的引用计数为 0 时，也就是对象的所有者都不持有该对象，该对象被废弃时，不管 ARC 是否有效，都会调用对象的 `dealloc` 方法，对对象进行析构。

简单列举一下 `dealooc` 的调用流程，大家可以结合 runtime 源码来看：

1. `dealloc` 调用流程
   1. 首先调用 `_objc_rootDealloc()`
   2. 接下来调用 `rootDealloc()`
   3. 这时候会判断是否可以被释放，判断的依据主要有 5 个：
      - `NONPointer_ISA`   // 是否是非指针类型 isa
      - `weakly_reference`  // 是否有若引用
      - `has_assoc`  // 是否有关联对象
      - `has_cxx_dtor`  // 是否有 c++ 相关内容
      - `has_sidetable_rc`  // 是否使用到 sidetable
   4. 如果没有之前 5 种情况的任意一种，则可以执行释放操作，C 函数的 `free()`
   5. 执行完毕
2. `objc_dispose()` 调用流程
   1. 直接调用 `objc_destructInstance()`
   2. 之后调用 C 函数的 `free()`
3. `objc_destructInstance()` 调用流程
   1. 先判断 `hasCxxDtor`，如果有 `c++` 相关内容，要调用 `object_cxxDestruct()`，销毁 c++ 相关内容
   2. 再判断 `hasAssociatedObjects`，如果有关联对象，要调用 `object_remove_associations()`，销毁关联对象的一系列操作
   3. 然后调用 `clearDeallocating()`
   4. 执行完毕
4. `clearDeallocating()` 调用流程
   1. 先执行 `sideTable_clearDeallocating()`
   2. 再执行 `waek_clear_no_lock`，将指向该对象的弱引用指针置为 `nil`
   3. 接下来执行 `table.refcnts.eraser()`，从引用计数表中擦除该对象的引用计数
   4. 至此为此，`dealloc` 的执行流程结束

## 总结

来做一个小总结吧。

内存分区：

- 栈区
- 堆区
- 全局区
  - 未初始化
  - 已初始化
- 常量区
- 代码区

内存管理方式：

- Tagged Pointer（小对象）
- NONPOINTER_ISA （指针中存放与该对象内存相关的信息）
- 散列表（引用计数表、弱引用表）

这篇文章讲了内存分区、内存管理方式、`SideTables` 原理、引用计数、`alloc/retain/release/autorelease/dealloc` 内存相关方法的介绍，以及自动释放池。

## 参考文章

[【iOS】内存五大区域](https://link.juejin.cn?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2Fce8e75987f87)

[深入浅出－iOS内存分配与分区](https://link.juejin.cn?target=https%3A%2F%2Fwww.jianshu.com%2Fp%2F7bbbe5d55440)

[理解 iOS 的内存管理](https://link.juejin.cn?target=https%3A%2F%2Fblog.devtang.com%2F2016%2F07%2F30%2Fios-memory-management%2F)

[深入理解 GCD](https://link.juejin.cn?target=https%3A%2F%2Fbestswifter.com%2Fdeep-gcd%2F)

[iOS底层探索 - 实例对象的创建](https://link.juejin.cn?target=http%3A%2F%2Fsaveload.me%2Fios-explore-instance-alloc%2F)

[神经病院 Objective-C Runtime 入院第一天](https://link.juejin.cn?target=https%3A%2F%2Fhalfrost.com%2Fobjc_runtime_isa_class%2F)

[iOS 开发笔记（七）: 深入理解 Autorelease](https://juejin.cn/post/1#heading-6)

[黑幕背后的Autorelease](https://link.juejin.cn?target=https%3A%2F%2Fblog.sunnyxx.com%2F2014%2F10%2F15%2Fbehind-autorelease%2F)

[ARC下dealloc过程及.cxx_destruct的探究](https://link.juejin.cn?target=https%3A%2F%2Fblog.sunnyxx.com%2F2014%2F04%2F02%2Fobjc_dig_arc_dealloc%2F)

[详解iOS内存管理机制内部原理](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2FHorson19%2Farticle%2Fdetails%2F82593484%3Futm_source%3Dcopy)



作者：_Terry
链接：https://juejin.cn/post/6844903855751168013
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。