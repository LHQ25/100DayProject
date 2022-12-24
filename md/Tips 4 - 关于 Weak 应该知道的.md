## 前言

Weak 是弱引用，它是 iOS 中用于修饰变量的一种修饰符，它有两个特点：

- 被 `weak` 修饰符修饰的对象，引用计数不会 +1
- 被 `weak` 修饰符修饰的对象，在废弃时，会将 `nil` 赋值给该变量

所谓引用计数，是苹果用来管理内存的一种机制。当一个对象被强引用时，它的引用计数会 +1，有多个强引用，每个强引用都是导致引用计数 +1，当一个强引用被释放，引用计数 -1，当引用计数为 0 时，系统会调用 `dealloc` 函数来销毁内存。

目前苹果采用的是自动引用计数，也就是我们不需要去手动的去对对象进行 `retain`（对引用计数+1） 和 `release`（对引用计数-1）的操作，这些由编译器来完成。但其实只有编译器的话是无法完全胜任的，还需要运行时库的协助。

而运行时库会根据开发者提供的对象的修饰符，来和编译器共同确定如何去管理这个对象的内存。

iOS 中有多种修饰符：

![property.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d172740b0d48450cbae74c4c6aff70b1~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

我们重点说明，`weak` 的作用以及它的实现原理。

## weak 解决循环引用

`weak`，其实它就是用来解决循环引用的，下面是一个循环引用的例子：

```objc
@interface Dog: NSObject
@property (nonatomic, strong) Cat *cat;
@end

@implementation Dog
- (void)dealloc {
    NSLog(@"dog dealloc");
}
@end

@interface Cat: NSObject
@property (nonatomic, strong) Dog *dog;
@end

@implementation Cat
- (void)dealloc {
    NSLog(@"cat dealloc");
}
@end
复制代码
```

在调用时：

```objc
- (void)viewDidLoad {
    [super viewDidLoad];

    Cat *cat = [[Cat alloc] init];
    Dog *dog = [[Dog alloc] init];
    cat.dog = dog;
    dog.cat = cat;
}
复制代码
```

它们的关系如图：

![cycle.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bf51643f6c5d4fe4a3e24ff4db1836b6~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

中间的实线箭头代表它们相互进行了强引用，强引用会导致引用计数 +1，在它们的作用域已经结束之后，因为它们的彼此引用，所以编译器无法释放它们的内存（引用计数为 0 才会释放），从而导致内存泄漏。在 `viewDidLoad` 方法执行结束之后，并没有打印 `Cat` 和 `Dog` 的 `dealloc` 方法。

此时 `weak` 就派上用场了，在上面的代码中使用的修饰符都是 `strong`，将其中一个，比如 `Dog` 中的 `@property (nonatomic, strong) Cat *cat` 改为 `@property (nonatomic, weak) Cat *cat`，此时他们的引用关系如下：

![weak.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/976854cbb9834077af0c3ccac730fb35~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

虚线代表弱引用，它不会导致引用计数 +1，所以在它们的作用域结束，也就是 `viewDidLoad` 方法执行结束之后，编译器会发现 `Cat` 的引用计数是 0，就是释放 `Cat`，当 `Cat` 被释放之后，`Cat` 所持有的 `dog` 的引用就没有了，`dog` 的引用计数也会变为 0，编译器就也会释放掉 `dog` 的内存，这样就解决了循环引用的问题。

控制台的打印结果为：

```shell
cat dealloc
dog dealloc
复制代码
```

## weak 原理

除了在属性中使用 `weak` 的方式，要弱引用一个对象，我们还可以这样使用：

```objc
NSObject *obj = [[NSObject alloc] init];
id __weak obj1 = obj;
复制代码
```

在 `id __weak obj1 = obj;` 处给个断点，打开 Xcode -> Debug -> Debug Workflow -> Always show Disassembly，展示汇编代码，可以看到下面这段代码：

![disassembly.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c17788fe449a4823b1bcb9f6f65c4eb6~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

通过 `objc_initWeak` 函数初始化附有 `__weak` 修饰符的变量，在变量作用域结束时通过 `objc_destoryWeak` 函数释放该变量。

翻开运行时库的源码，我们可以找到 `objc_initWeak` 和 `objc_destoryWeak` 的实现：

```objc
id objc_initWeak(id *location, id newObj)
{
    if (!newObj) {
        *location = nil;
        return nil;
    }

    return storeWeak<DontHaveOld, DoHaveNew, DoCrashIfDeallocating>
        (location, (objc_object*)newObj);
}
复制代码
void objc_destroyWeak(id *location)
{
    (void)storeWeak<DoHaveOld, DontHaveNew, DontCrashIfDeallocating>
        (location, nil);
}
复制代码
```

可以看到两个方法的内部都是调用了 `storeWeak`，所以上述源代码大致等于：

```objc
id obj1;
storeWeak(obj1, obj);
storeWeak(obj1, nil);
复制代码
```

那么重点就是 `storeWeak` 方法，这个方法有点长，而且没有一些前置的知识点的话估计看了源码也是一脸懵，所以先简单说一下这个方法主要做了哪些事情。

1. 这个方法中会使用两张表，`oldTable` 和 `newTable`，分别代表旧的弱引用表和新的弱引用表。
2. 如果 `weak` 指针之前已经指向了一个弱引用，那么将旧的 `weak` 指针地址从旧的弱引用表移除
3. 如果 `weak` 指针需要指向一个新的引用，将`weak` 指针添加到新的弱引用表中

所以为了看懂这个源码，我们得先知道什么是弱引用表。

### 弱引用表

弱引用表和引用计数表息息相关，它们都是散列表。散列表就是哈希表，我们用的字典 `NSDictionary` 也是这样的结构。

引用计数表在源码中对应的，是一个名为 `SideTable` 的结构体：

```objc
struct SideTable {
    spinlock_t slock;
    RefcountMap refcnts;
    weak_table_t weak_table;
    
    ...
}
复制代码
```

`SideTable` 主要有三个成员：

- `slock`：自旋锁，一个效率很高的锁，用于操作 `SideTable` 时进行上锁和解锁操作。
- `refcnts`：这是用来存储引用计数的哈希表，就是我们对象的引用计数是存放在里的。
- `weak_table`：就是我们所说的弱引用表所对应的结构体。

继续跳进 `weak_table_t` 中：

```objc
/**
 * The global weak references table. Stores object ids as keys,
 * and weak_*entry_t structs as their values.*
 */
struct weak_table_t {
    weak_entry_t *weak_entries;
    size_t    num_entries;
    uintptr_t mask;
    uintptr_t max_hash_displacement;
}
复制代码
```

- `weak_entries`：`hash` 数组，用来存放所有弱引用该对象的指针
- `num_entries`：`hash` 数组中的元素个数
- `mask`：`hash` 数组长度 -1，会参与 `hash` 计算
- `max_hash_displacement`：可能会发生的 `hash` 冲突的最大次数，用于判断是否出现了逻辑错误（`hash` 表中的冲突次数绝不会超过该值）

另外，在苹果的注释中可以看到，`weak_table_t` 是以对象的 id 作为 key，以 `weak_entries` 作为值的形式来存放一个对象的弱引用的。

综上，我们可以得出一个结构图：

![relationship.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7af1d44e1a0e478f9d553726bf885b16~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

(转自 [iOS底层原理：weak的实现原理](https://juejin.cn/post/6844904101839372295))

需要说明的是，引用计数表并不是只有一张表，而是很多张表，统称为 `SideTables`，以链表的形式串联起来。

### 源码的实现

知道上面这个结构之后，其实如何去存储 `weak` 指针和如何再对象废弃时将 `weak` 指针置为 `nil` 我们也能大概能猜出来了。

- 当使用一个 `weak` 指针指向某个对象时，我们以这个对象的 id 为 key，以这个 `weak` 指针作为值，将其存放弱引用表中。
- 如果这个 `weak` 指针之前已经指向了其他对象，也就是已经存放在了其他的弱引用表中，自然得先将它从之前的弱引用表中移除，因为它即将指向了新的对象
- 当被 `weak` 指针指向的这个对象执行 `dealloc` 方法，也就是在析构时，只需要以这个对象的 id 为 key，取出对应的 `values` 遍历一下全部置为 `nil`。当然，也要将这个 `key` 和 `values` 从弱引用表中移除掉。

源码的解析就直接看这篇 [iOS底层原理：weak的实现原理](https://juejin.cn/post/6844904101839372295) 吧，已经讲的很详细了就不再写一遍了。

## 总结

`weak` 被发明出来，就是主要来解决循环引用的问题的，它以指向的对象的地址为 `key`，将自身存放在弱引用表中，弱引用表是引用计数表中的一个成员。当我们使用 `weak` 去指向一个对象时，运行时库会将我们将 `weak` 指针给保存起来，在所指向的对象被释放时，运行时库也会将保存起来的 `weak` 指针置为 `nil`，保证安全。

另外，附有 `__weak` 修饰符变量所引用的对象是会被注册到 `autoreleasepool` 中的，比如一段代码：

```objc
{
    id __weak obj1 = obj;
    NSLog(@"%@", obj1);
}
复制代码
```

该源代码可转换为如下形式：

```objc
// 编译器的模拟代码
id obj1;
objc_initWeak(&obj1, obj);
id tmp = objc_loadWeakRetained(&obj1);
objc_autorelease(tmp);
NSLog(%@, tmp);
objc_destroyWeak(&obj1);
复制代码
```

1. `objc_loadWeakRetained` 函数取出附有 `__weak` 修饰符变量所引用的对象并 `retain`
2. `objc_autorelease` 函数将对象注册到 `autoreleasepool` 中

被 `__weak` 所引用的对象像这样被注册到了 `autoreleasepool` 中，因此在 `@autoreleasepool` 块结束之前都可以放心使用。但是，如果大量的使用附有 `__weak` 修饰符的变量，注册到 `autoreleasepool` 的对象也会大量的增加，因此在使用 `__weak` 时，最好先暂时赋值给 `__strong` 修饰符修饰的变量之后再使用。

比如，以下代码使用了 5 次附有 `__weak` 修饰符的变量 o。

```objc
{
    NSObject *obj = [[NSObject alloc] init];
    id __weak o = obj;
    NSLog(@"1 %@", o);
    NSLog(@"2 %@", o);
    NSLog(@"3 %@", o);
    NSLog(@"4 %@", o);
    NSLog(@"5 %@", o);
}
复制代码
```

相应的，变量 o 所赋值的对象也就注册到 `autoreleasepool` 中 5 次。

![release1.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2c3ab03e9923450e82982302969d7aa2~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

使用 `__strong` 可以避免此类问题：

```objc
{
    NSObject *obj = [[NSObject alloc] init];
    id __weak o = obj;
    id tmp = o;
    NSLog(@"1 %@", tmp);
    NSLog(@"2 %@", tmp);
    NSLog(@"3 %@", tmp);
    NSLog(@"4 %@", tmp);
    NSLog(@"5 %@", tmp);
}
复制代码
```

在 `tmp = o;` 时对象进登录到 `autoreleasepool` 中 1 次。

![release2.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0f0f16bd8ef244278f3f2b2aea461965~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

dene~



作者：_Terry
链接：https://juejin.cn/post/7170775802823311390
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。