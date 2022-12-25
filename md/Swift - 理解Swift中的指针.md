# 理解Swift中的指针

## 指针基础知识

计算机是以字节为单位访问可寻址的存储器。机器级程序将存储器视为一个非常大的字节数组，称为**虚拟存储器**。这个存储器的每个字节都会有一个唯一的数字来标识，我们称为**地址**。所有这些地址的集合称为**虚拟地址空间**。

计算机是以一组二进制序列为单元执行存储，传送或操作的，该单元称为**字**。字的二进制位数称为**字长**。机器（`CPU`）的字长决定了虚拟地址空间的大小，字长`n`位，则虚拟地址空间的大小为：`0 ~ 2^n-1`，`32`位的字长，对应的虚拟地址空间大小为`4`千兆字节（`4GB`）。

**指针类型使用的是机器的全字长，即:`32`位 `4`字节，`64`位 `8`字节。指针表示的是地址，地址是虚拟存储器每个字节的唯一数字标识，`n`位机器虚拟地址空间的最大地址标识可达 `2^n-1`，这个数字标识的地址需要被表示，必须用`n`位来存储。**

## Swift内存布局

使用`MemoryLayout`查看Swift基本数据类型的大小，对齐方式。

```swift
MemoryLayout<Int>.size //Int类型，连续内存占用为8字节
MemoryLayout<Int>.alignment // Int类型的内存对齐为8字节
///连续内存一个Int值的开始地址到下一个Int值开始地址之间的字节值
MemoryLayout<Int>.stride // Int类型的步幅为8字节

MemoryLayout<Optional<Int>>.size // 9字节，可选类型比普通类型多一个字节
MemoryLayout<Optional<Int>>.alignment //8字节
MemoryLayout<Optional<Int>>.stride //16

MemoryLayout<Float>.size // 4字节
MemoryLayout<Float>.alignment //4字节
MemoryLayout<Float>.stride //4字节

MemoryLayout<Double>.size // 8
MemoryLayout<Double>.alignment //8
MemoryLayout<Double>.stride //8

MemoryLayout<Bool>.size //1
MemoryLayout<Bool>.alignment //1
MemoryLayout<Bool>.stride //1

MemoryLayout<Int32>.size // 4
MemoryLayout<Int32>.alignment //4
MemoryLayout<Int32>.stride //4
复制代码
```

使用`MemoryLayout`查看Swift枚举、结构体、类类型的大小，对齐方式。

```swift
///枚举类型
enum EmptyEnum {///空枚举
}
MemoryLayout<EmptyEnum>.size //0
MemoryLayout<EmptyEnum>.alignment //1 所有地址都能被1整除，故可存在于任何地址，
MemoryLayout<EmptyEnum>.stride //1

enum SampleEnum {
   case none
   case some(Int)
}
MemoryLayout<SampleEnum>.size //9
MemoryLayout<SampleEnum>.alignment //8
MemoryLayout<SampleEnum>.stride //16

///结构体
struct SampleStruct {
}
MemoryLayout<SampleStruct>.size //0
MemoryLayout<SampleStruct>.alignment //1 ，所有地址都能被1整除，故可存在于任何地址，
MemoryLayout<SampleStruct>.stride //1

struct SampleStruct {
    let b : Int
    let a : Bool
}
MemoryLayout<SampleStruct>.size // 9 but b与a的位置颠倒后，便会是16
MemoryLayout<SampleStruct>.alignment // 8
MemoryLayout<SampleStruct>.stride // 16

class EmptyClass {}
MemoryLayout<EmptyClass>.size//8
MemoryLayout<EmptyClass>.alignment//8
MemoryLayout<EmptyClass>.stride//8

class SampleClass {
    let b : Int = 2
    var a : Bool?
}
MemoryLayout<SampleClass>.size //8
MemoryLayout<SampleClass>.alignment//8
MemoryLayout<SampleClass>.stride//8

复制代码
```

内存布局[更详细的探索](https://link.juejin.cn/?target=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DERYNyrfXjlg)。

## Swift指针分类

`Swift`中的不可变指针类型:

|       | Pointer                | BufferPointer                |
| ----- | ---------------------- | ---------------------------- |
| Typed | Unsafe**Pointer**<T>   | Unsafe**BufferPointer**<T>   |
| Raw   | Unsafe`Raw`**Pointer** | Unsafe`Raw`**BufferPointer** |

`Swift`中的可变指针类型:

|       | Pointer                         | BufferPointer                         |
| ----- | ------------------------------- | ------------------------------------- |
| Typed | Unsafe*Mutable***Pointer**<T>   | Unsafe*Mutable***BufferPointer**<T>   |
| Raw   | Unsafe*Mutable*`Raw`**Pointer** | Unsafe*Mutable*`Raw`**BufferPointer** |

1. `Pointer`与`BufferPointer`：`Pointer` 表示指向内存中的单个值，如：`Int`。`BufferPointer`表示指向内存中相同类型的多个值（集合）称为缓冲区指针，如`[Int]`。
2. `Typed`与`Raw`：类型化的指针`Typed`提供了解释指针指向的字节序列的类型。而非类型化的指针`Raw`访问最原始的字节序列，未提供解释字节序列的类型。
3. `Mutable`与`Immutable`：不可变指针，只读。可变指针，可读可写。

`Swift`与`OC`指针对比

| Swift                           | OC          | 说明                       |
| ------------------------------- | ----------- | -------------------------- |
| Unsafe**Pointer**<T>            | const T*    | 指针不可变，指向的内容可变 |
| Unsafe*Mutable***Pointer**<T>   | T*          | 指针及指向内容均可变       |
| Unsafe`Raw`**Pointer**          | const void* | 指向未知类型的常量指针     |
| Unsafe*Mutable*`Raw`**Pointer** | void*       | 指向未知类型的指针         |

## 使用非类型化（Raw）的指针

示例：

使用非类型化的指针访问内存并写入三个整数（`Int`）。

```swift
let count = 3
let stride = MemoryLayout<Int>.stride ///8个字节，每个实例的存储空间
let byteCount = stride * count
let alignment = MemoryLayout<Int>.alignment
///通过指定的字节大小和对齐方式申请未初始化的内存
let mutableRawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
defer {
    mutableRawPointer.deallocate()
}
/// 初始化内存
mutableRawPointer.initializeMemory(as: Int.self, repeating: 0, count: byteCount)
///RawPointer 起始位置存储 整数15
mutableRawPointer.storeBytes(of: 0xFFFFFFFFF, as: Int.self)
///将RawPointer 起始位置 偏移一个整数的位置（8个字节） 并在此位置存储一个整数 有以下两种方式：
(mutableRawPointer + stride).storeBytes(of: 0xDDDDDDD, as: Int.self)
mutableRawPointer.advanced(by: stride*2).storeBytes(of: 9, as: Int.self)
///通过`load` 查看内存中特定偏移地址的值
mutableRawPointer.load(fromByteOffset: 0, as: Int.self) // 15
mutableRawPointer.load(fromByteOffset: stride, as: Int.self) //9
///通过`UnsafeRawBufferPointer`以字节集合的形式访问内存
let buffer = UnsafeRawBufferPointer.init(start: mutableRawPointer, count: byteCount)
for (index,byte) in buffer.enumerated(){///遍历每个字节的值
    print("index:\(index),value:\(byte)")
}
//输出
//index:0,value:255  index:8,value:221  index:16,value:9
//index:1,value:255  index:9,value:221  index:17,value:0
//index:2,value:255  index:10,value:221 index:18,value:0
//index:3,value:255  index:11,value:13  index:19,value:0
//index:4,value:15   index:12,value:0   index:20,value:0
//index:5,value:0    index:13,value:0   index:21,value:0
//index:6,value:0    index:14,value:0   index:22,value:0
//index:7,value:0    index:15,value:0   index:23,value:0

复制代码
```

`UnsafeRawBufferPointer` 表示内存区域中字节的集合，可用来以字节的形式访问内存。

## 使用类型化(Typed)的指针

针对上述示例，采用类型化指针实现：

```swift
let count = 3
let stride = MemoryLayout<Int>.stride ///8个字节，每个实例的存储空间
let byteCount = stride * count
let alignment = MemoryLayout<Int>.alignment
///申请未初始化的内存用于存储特定数目的指定类型的实例。
let mutableTypedPointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
/// 初始化内存
mutableTypedPointer.initialize(repeating: 0, count: count)
defer {
    mutableTypedPointer.deinitialize(count: count)
    mutableTypedPointer.deallocate()
}
/// 存储第一个值
mutableTypedPointer.pointee = 15
/// 存储第二个值
///`successor`返回指向下一个连续实例的指针
mutableTypedPointer.successor().pointee = 10
mutableTypedPointer[1] = 10
/// 存储第三个值
(mutableTypedPointer + 2).pointee = 20
mutableTypedPointer.advanced(by: 2).pointee = 30
/// 从内存中读取
mutableTypedPointer.pointee //15
(mutableTypedPointer + 2).pointee // 30
(mutableTypedPointer + 2).predecessor().pointee // 10
///通过`UnsafeRawBufferPointer`以字节集合的形式访问内存
let buffer = UnsafeRawBufferPointer.init(start: mutableTypedPointer, count: byteCount)
for (index,byte) in buffer.enumerated(){///遍历每个字节的值
    print("index:\(index),value:\(byte)")
}
//输出
//index:0,value:15 index:8,value:10 index:16,value:30
//index:1,value:0  index:9,value:0  index:17,value:0
//index:2,value:0  index:10,value:0 index:18,value:0
//index:3,value:0  index:11,value:0 index:19,value:0
//index:4,value:0  index:12,value:0 index:20,value:0
//index:5,value:0  index:13,value:0 index:21,value:0
//index:6,value:0  index:14,value:0 index:22,value:0
//index:7,value:0  index:15,value:0 index:23,value:0
复制代码
```

## RawPointer转换为TypedPointer

```swift
///未类型化指针申请未初始化的内存，以字节为单位
let  mutableRawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
defer {
    mutableRawPointer.deallocate()
}
/// Raw 转化 Typed，以对应类型的字节数 为单位
let mutableTypedPointer = mutableRawPointer.bindMemory(to: Int.self, capacity: count)
/// 初始化,非必需
mutableTypedPointer.initialize(repeating: 0, count: count)
defer {
    ///只需反初始化即可，第一个`defer`会处理指针的`deallocate`
    mutableTypedPointer.deinitialize(count: count)
}
///存储
mutableTypedPointer.pointee = 10
mutableTypedPointer.successor().pointee = 40
(mutableTypedPointer + 1).pointee = 20
mutableTypedPointer.advanced(by: 2).pointee = 30

///遍历，使用类型化的`BufferPointer`遍历
let buffer = UnsafeBufferPointer.init(start: mutableTypedPointer, count: count)
for item in buffer.enumerated() {
    print("index:\(item.0),value:\(item.1)")
}
//输出
//index:0,value:10
//index:1,value:20
//index:2,value:30
复制代码
```

`UnsafeBufferPointer<Element>` 表示连续存储在内存中的`Element`集合，可用来以元素的形式访问内存。比如：`Element`的真实类型为`Int16`时，将会访问到内存中存储的`Int16`的值。

## 调用以指针作为参数的函数

调用以指针作为参数的函数时，可以通过隐式转换来传递兼容的指针类型，或者通过隐式桥接来传递指向变量的指针或指向数组的指针。

### 常量指针作为参数

当调用一个函数，它携带的指针参数为`UnsafePointer<Type>`时，我们可以传递的参数有：

- `UnsafePointer<Type>`,`UnsafeMutablePointer<Type>`或`AutoreleasingUnsafeMutablePointer<Type>`, 根据需要会隐式转换为 `UnsafePointer<Type>`。
- 如果`Type`为`Int8` 或 `UInt8`，可以传`String`的实例；字符串会自动转换为`UTF8`,并将指向该`UTF8`缓冲区的指针传递给函数
- 该`Type`类型的可变的变量，属性或下标，通过在左侧添加取地址符`&`的形式传递给函数。(隐式桥接)
- 一个`Type`类型的数组（`[Type]`），会以指向数组开头的指针传递给函数。(隐式桥接)

示例如下：

```swift
///定义一个接收`UnsafePointer<Int8>`作为参数的函数
func functionWithConstTypePointer(_ p: UnsafePointer<Int8>) {
    //...
}
///传递`UnsafeMutablePointer<Type>`作为参数
let mutableTypePointer = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
mutableTypePointer.initialize(repeating: 10, count: 1)
defer {
    mutableTypePointer.deinitialize(count: 1)
    mutableTypePointer.deallocate()
}
functionWithConstTypePointer(mutableTypePointer)
///传递`String`作为参数
let str = "abcd"
functionWithConstTypePointer(str)
///传递输入输出型变量作为参数
var a : Int8 = 3
functionWithConstTypePointer(&a)
///传递`[Type]`数组
functionWithConstTypePointer([1,2,3,4])
复制代码
```

当调用一个函数，它携带的指针参数为`UnsafeRawPointer`时，可以传递与`UnsafePointer<Type>`相同的参数，只不过没有了类型的限制：

示例如下：

```swift
///定义一个接收`UnsafeRawPointer`作为参数的函数
func functionWithConstRawPointer(_ p: UnsafeRawPointer) {
    //...
}
///传递`UnsafeMutablePointer<Type>`作为参数
let mutableTypePointer = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
mutableTypePointer.initialize(repeating: 10, count: 1)
defer {
    mutableTypePointer.deinitialize(count: 1)
    mutableTypePointer.deallocate()
}
functionWithConstRawPointer(mutableTypePointer)
///传递`String`作为参数
let str = "abcd"
functionWithConstRawPointer(str)
///传递输入输出型变量作为参数
var a = 3.0
functionWithConstRawPointer(&a)
///传递任意类型数组
functionWithConstRawPointer([1,2,3,4] as [Int8])
functionWithConstRawPointer([1,2,3,4] as [Int16])
functionWithConstRawPointer([1.0,2.0,3.0,4.0] as [Float])
复制代码
```

### 可变指针作为参数

当调用一个函数，它携带的指针参数为`UnsafeMutablePointer<Type>`时，我们可以传递的参数有：

- `UnsafeMutablePointer<Type>`的值。
- 该`Type`类型的可变的变量，属性或下标，通过在左侧添加取地址符`&`的形式传递给函数。(隐式桥接)
- 一个`Type`类型的可变数组（`[Type]`），会以指向数组开头的指针传递给函数。(隐式桥接)

示例如下：

```swift
///定义一个接收`UnsafeMutablePointer<Int8>`作为参数的函数
func functionWithMutableTypePointer(_ p: UnsafePointer<Int8>) {
    //...
}
///传递`UnsafeMutablePointer<Type>`作为参数
let mutableTypePointer = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
mutableTypePointer.initialize(repeating: 10, count: 1)
defer {
    mutableTypePointer.deinitialize(count: 1)
    mutableTypePointer.deallocate()
}
functionWithMutableTypePointer(mutableTypePointer)
///传递`Type`类型的变量
var b : Int8 = 10
functionWithMutableTypePointer(&b)
///传递`[Type]`类型的变量
var c : [Int8] = [20,10,30,40]
functionWithMutableTypePointer(&c)
复制代码
```

同样的，当调用一个函数，它携带的指针参数为`UnsafeMutableRawPointer`时，可以传递与`UnsafeMutablePointer<Type>`相同的参数，只不过没有了类型的限制。 示例如下：

```swift
///定义一个接收`UnsafeMutableRawPointer`作为参数的函数
func functionWithMutableRawPointer(_ p: UnsafeMutableRawPointer) {
    //...
}
///传递`UnsafeMutablePointer<Type>`作为参数
let mutableTypePointer = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
mutableTypePointer.initialize(repeating: 10, count: 1)
defer {
    mutableTypePointer.deinitialize(count: 1)
    mutableTypePointer.deallocate()
}
functionWithMutableRawPointer(mutableTypePointer)
///传递任意类型的变量
var b : Int8 = 10
functionWithMutableRawPointer(&b)
var d : Float = 12.0
functionWithMutableRawPointer(&d)
///传递任意类型的可变数组
var c : [Int8] = [20,10,30,40]
functionWithMutableRawPointer(&c)
var e : [Float] = [20.0,10.0,30.0,40.0]
functionWithMutableRawPointer(&e)
复制代码
```

### 重要的知识点

> The pointer created through implicit bridging of an instance or of an array’s elements is only valid during the execution of the called function. Escaping the pointer to use after the execution of the function is undefined behavior. In particular, do not use implicit bridging when calling an `UnsafePointer`/`UnsafeMutablePointer`/`UnsafeRawPointer`/`UnsafeMutableRawPointer`initializer.

```swift
var number = 5
let numberPointer = UnsafePointer<Int>(&number)
// Accessing 'numberPointer' is undefined behavior.
var number = 5
let numberPointer = UnsafeMutablePointer<Int>(&number)
// Accessing 'numberPointer' is undefined behavior.
var number = 5
let numberPointer = UnsafeRawPointer(&number)
// Accessing 'numberPointer' is undefined behavior.
var number = 5
let numberPointer = UnsafeMutableRawPointer(&number)
// Accessing 'numberPointer' is undefined behavior.
复制代码
```

**what is undefined behavior?**

> Undefined behavior in programming languages can introduce difficult to diagnose bugs and even lead to security vulnerabilities in your App.[Detail](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.apple.com%2Fvideos%2Fplay%2Fwwdc2017%2F407%2F) 示例：

```swift
func functionWithPointer(_ p: UnsafePointer<Int>) {
    let mPointer = UnsafeMutablePointer<Int>.init(mutating: p)
    mPointer.pointee = 6;
}
var number = 5
let numberPointer = UnsafePointer<Int>(&number)
functionWithPointer(numberPointer)
print(numberPointer.pointee) //6
print(number)//6 会出现比较难以盘查的bug
number = 7
print(numberPointer.pointee) //7
print(number)//7
复制代码
```

## 内存访问

`Swift`中任意类型的值,`Swift`提供了全局函数直接访问它们的指针或内存中的字节。

### 访问指针

通过下列函数，`Swift`可以访问任意值的指针。

```swift
withUnsafePointer(to:_:)///只访问，不修改
withUnsafeMutablePointer(to:_:)//可访问，可修改
复制代码
```

示例:

```swift
/// 只访问
let temp : [Int8] = [1,2,3,4] 
withUnsafePointer(to: temp) { point in
    print(point.pointee)
}
///规范方式：访问&修改
var temp : [Int8] = [1,2,3,4]
withUnsafeMutablePointer(to: &temp) { mPointer in
    mPointer.pointee = [6,5,4];
}
print(temp) ///[6, 5, 4]
复制代码
```

**`Swift`的值，如果需要通过指针的方式改变，则必须为变量，并且调用上述方法时必须将变量标记为`inout`参数，即变量左侧添加`&`。常量值，不能以`inout`参数的形式访问指针。**

错误示例一：

```swift
///错误方式：访问&修改
var temp : [Int8] = [1,2,3,4]
withUnsafePointer(to: &temp) { point in
    let mPointer = UnsafeMutablePointer<[Int8]>.init(mutating: point)
    mPointer.pointee = [6,5,4];
}
复制代码
```

原因如下：

> A closure that takes a pointer to `value` as its sole argument. If the closure has a return value, that value is also used as the return value of the `withUnsafePointer(to:_:)` function. The pointer argument is valid only for the duration of the function’s execution. **It is `undefined behavior` to try to mutate through the pointer argument by converting it to `UnsafeMutablePointer` or any other mutable pointer type.** If you need to mutate the argument through the pointer, use `withUnsafeMutablePointer(to:_:)` instead.

错误示例二：

```swift
var tmp : [Int8] = [1,2,3,4]
///错误1
let pointer = withUnsafePointer(to: &tmp, {$0})
let mPointer = UnsafeMutablePointer<[Int8]>.init(mutating: pointer)
mPointer.pointee = [7,8,9]
///错误2
let mutablePointer = withUnsafeMutablePointer(to: &tmp) {$0}
mutablePointer.pointee = [6,5,4,3]
复制代码
```

原因如下：

> The pointer argument to `body` is valid only during the execution of `withUnsafePointer(to:_:)`or `withUnsafeMutablePointer(to:_:)`. Do not store or return the pointer for later use.

**使用上述方法访问内存时，切记不要返回或者存储闭包参数`body`中的指针，供以后使用。**

### 访问字节

通过下列函数，`Swift`可以访问任意值的在内存中的字节。

```swift
withUnsafeBytes(of:_:)///只访问，不修改
withUnsafeMutableBytes(of:_:)///可访问，可修改
复制代码
```

示例:

```swift
///只访问，不修改
var temp : UInt32 = UInt32.max
withUnsafeBytes(of: temp) { rawBufferPointer in
    for item in rawBufferPointer.enumerated() {
        print("index:\(item.0),value:\(item.1)")
    }
}
//输出
index:0,value:255
index:1,value:255
index:2,value:255
index:3,value:255

///规范方式：访问&修改，
var temp : UInt32 = UInt32.max //4294967295
withUnsafeMutableBytes(of: &temp) { mutableRawBuffer in
    mutableRawBuffer[1] = 0;
    mutableRawBuffer[2] = 0;
    mutableRawBuffer[3] = 0;
    //mutableRawBuffer[5] = 0;/// crash
}
print(temp) ///255
复制代码
```

错误示例：

```swift
///访问&修改，此方式有风险，需要重点规避
var temp : UInt32 = UInt32.max //4294967295
withUnsafeBytes(of: &temp) { rawBufferPointer in
    let mutableRawBuffer = UnsafeMutableRawBufferPointer.init(mutating: rawBufferPointer)
    ///小端序
    mutableRawBuffer[1] = 0;
    mutableRawBuffer[2] = 0;
    mutableRawBuffer[3] = 0;
    for item in mutableRawBuffer.enumerated() {
        print("index:\(item.0),value:\(item.1)")
    }
}
print(temp) ///255
复制代码
```

原因如下：

> A closure that takes a raw buffer pointer to the bytes of `value` as its sole argument. If the closure has a return value, that value is also used as the return value of the `withUnsafeBytes(of:_:)` function. The buffer pointer argument is valid only for the duration of the closure’s execution. **It is `undefined behavior` to attempt to mutate through the pointer by conversion to `UnsafeMutableRawBufferPointer` or any other mutable pointer type.** If you want to mutate a value by writing through a pointer, use `withUnsafeMutableBytes(of:_:)`instead.

## 参考资料

[developer.apple.com/documentati…](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.apple.com%2Fdocumentation%2Fswift%2Fswift_standard_library%2Fmanual_memory_management%2Fcalling_functions_with_pointer_parameters)

[www.raywenderlich.com/7181017-uns…](https://link.juejin.cn/?target=https%3A%2F%2Fwww.raywenderlich.com%2F7181017-unsafe-swift-using-pointers-and-interacting-with-c%23toc-anchor-009)

[www.vadimbulavin.com/swift-point…](https://link.juejin.cn/?target=https%3A%2F%2Fwww.vadimbulavin.com%2Fswift-pointers-overview-unsafe-buffer-raw-and-managed-pointers%2F)