# 基础

## 1. 继承、拓展

1. 继承可以增加，修改或者删除方法，并且可以增加属性。

## 3. 什么是多态?什么是协议?

* 多态：多态在面向对象语言中指同一个接口有多种不同的实现方式,在OC中,多态则是不同对象对同一消息的不同响应方式;子类通过重写父类的方法来改变同一方法的实现.体现多态性 通俗来讲: 多态就父类类型的指针指向子类的对象,在函数（方法）调用的时候可以调用到正确版本的函数（方法）。 多态就是某一类事物的多种形态.继承是多态的前提。
* 协议：协议是一套标准，这个标准中声明了很多方法，但是不关心具体这些方法是怎么实现的，具体实现是由遵循这个协议的类去完成的。在OC中，一个类可以实现多个协议，通过协议可以弥补单继承的缺陷但是协议跟继承不一样，协议只是一个方法列表，方法的实现得靠遵循这个协议的类去实现。

# Object-C

## 1. 我们说的OC是动态运行时语言是什么意思？

​	主要是将数据类型的确定由编译时，推迟到了运行时。简单来说, 运行时机制使我们直到运行时才去决定一个对象的类别,以及调用该类别对象指定方法。

# Delegate 代理

代理是一种设计模式，以@protocol形式体现，一般是一对一传递；一般以weak关键词以规避循环引用。

# Notification 通知

## 1. 实现通知机制？

1. 应用服务提供商从服务器端把要发送的消息和设备令牌（device token）发送给苹果的消息推送服务器APNs。
2. APNs根据设备令牌在已注册的设备（iPhone、iPad、iTouch、mac等）查找对应的设备，将消息发送给相应的设备。
3. 客户端设备接将接收到的消息传递给相应的应用程序，应用程序根据用户设置弹出通知消息。



作者：程序员_秃头怪
链接：https://www.jianshu.com/p/1a6f2b6f05e4
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

# KVO

KVO是一种基于KVC实现的观察者模式。当指定的被观察的对象的属性更改了，KVO会以自动或手动方式通知观察者。 事例：监听 ScrollView 的 contentOffSet属性 [scrollview addObserver:self forKeyPath:@"contentOffset"options:NSKeyValueObservingOptionNew context:nil];

[KVO图](https://user-gold-cdn.xitu.io/2019/9/25/16d67d070bee8cb7?imageView2/0/w/1280/h/960/ignore-error/1)

## 1. KVO的底层实现？

KVO-键值观察机制，原理如下：

<img src="/Users/yicun/Desktop/100Day/100Day/iOS-Summaryinformation/KVO底层实现.png" alt="KVO底层实现" style="zoom:50%;" />

1. 当给A类添加KVO的时候，runtime动态的生成了一个子类NSKVONotifying_A，让A类的isa指针指向NSKVONotifying_A类，重写class方法，隐藏对象真实类信息
2. 重写监听属性的setter方法，在setter方法内部调用了Foundation 的 _NSSetObjectValueAndNotify 函数_
3. NSSetObjectValueAndNotify函数内部
   1. 首先会调用 willChangeValueForKey
   2. 然后给属性赋值
   3. 最后调用 didChangeValueForKey
   4. 最后调用 observer 的 observeValueForKeyPath 去告诉监听器属性值发生了改变 .
4. 重写了dealloc做一些 KVO 内存释放

#  如何选择delegate、notification、KVO

三种模式都是一个对象传递事件给另外一个对象，并且不要他们有耦合。

*  delegate. 一对一 notification 一对多,多对多 KVO 一对一 三者各有自己的特点: 
* delegate 语法简洁,方便阅读,易于调试 
* notification 灵活多变,可以跨越多个类之间进行使用 
* KVO 实现属性监听,实现model和view同步 可以根据实际开发遇到的场景来使用不同的方式

# KVC

KVC(key-value-coding)键值编码，是一种间接访问实例变量的方法。提供一种机制来间接访问对象的属性。

1. 给私有变量赋值。
2. 给控件的内部属性赋值（如自定义UITextFiled的clearButton，或placeholder的颜色，一般可利用runtime获取控件的内部属性名，Ivar *ivar = class_getInstanceVariable获取实例成员变量）。
   [textField setValue:[UIColor redColor] forKeyPath:@"placeholderLabel.textColor"];
3. 结合Runtime，model和字典的转换（setValuesForKeysWithDictionary，class_copyIvarList获取指定类的Ivar成员列表）

KVO是一种基于KVC实现的观察者模式。当指定的被观察的对象的属性更改了，KVO会以自动或手动方式通知观察者。
事例：监听 ScrollView 的 contentOffSet属性[scrollview addObserver:self forKeyPath:@"contentOffset"  options:NSKeyValueObservingOptionNew context:nil];

## 1. KVC的底层实现？

 当一个对象调用setValue方法时，方法内部会做以下操作：

1. 检查是否存在相应的key的set方法，如果存在，就调用set方法。
2. 如果set方法不存在，就会查找与key相同名称并且带下划线的成员变量，如果有，则直接给成员变量属性赋值。
3. 如果没有找到_key，就会查找相同名称的属性key，如果有就直接赋值。
4. 如果还没有找到，则调用valueForUndefinedKey:和setValue:forUndefinedKey:方法。
   这些方法的默认实现都是抛出异常，我们可以根据需要重写它们。

#内存管理

## 1. Objective-C 如何对内存管理的，说说你的看法和解决方法？

Objective-C的内存管理主要有三种方式ARC(自动内存计数)、手动内存计数、内存池。

1. 自动内存计数ARC：由Xcode自动在App编译阶段，在代码中添加内存管理代码。
2. 手动内存计数MRC：遵循内存谁申请、谁释放；谁添加，谁释放的原则。
3. 内存释放池Release Pool：把需要释放的内存统一放在一个池子中，当池子被抽干后(drain)，池子中所有的内存空间也被自动释放掉。内存池的释放操作分为自动和手动。自动释放受runloop机制影响。

# 属性关键字

## 1.用@property声明的 NSString / NSArray / NSDictionary 经常使用 copy 关键字，为什么？如果改用strong关键字，可能造成什么问题？

用 @property 声明 NSString、NSArray、NSDictionary 经常使用 copy 关键字，是因为他们有对应的可变类型：NSMutableString、NSMutableArray、NSMutableDictionary，他们之间可能进行赋值操作（就是把可变的赋值给不可变的），为确保对象中的字符串值不会无意间变动，应该在设置新属性值时拷贝一份。

1. 因为父类指针可以指向子类对象,使用 copy 的目的是为了让本对象的属性不受外界影响,使用 copy 无论给我传入是一个可变对象还是不可对象,我本身持有的就是一个不可变的副本。

2. 如果我们使用是 strong ,那么这个属性就有可能指向一个可变对象,如果这个可变对象在外部被修改了,那么会影响该属性。

总结：使用copy的目的是，防止把可变类型的对象赋值给不可变类型的对象时，可变类型对象的值发送变化会无意间篡改不可变类型对象原来的值。

[理解iOS中深浅拷贝-为什么NSString使用copy](https://www.jianshu.com/p/eda4957735ee) 

## 2. 属性关键字

* 读写权限：readonly、readwrite(默认)

* 原子性: atomic(默认)，nonatomic。atomic读写线程安全，但效率低，而且不是绝对的安全，比如如果修饰的是数组，那么对数组的读写是安全的，但如果是操作数组进行添加移除其中对象的还，就不保证安全了。

* 引用计数：

  * retain：

  * strong：表示指向并拥有该对象。其修饰的对象引用计数会增加1。该对象只要引用计数不为0则不会被销毁。当然强行将其设为nil可以销毁它。

  * weak：表示指向但不拥有该对象。其修饰的对象引用计数不会增加。无需手动设置，该对象会自行在内存中销毁。

  * weak 一般用来修饰对象，assign一般用来修饰基本数据类型。原因是assign修饰的对象被释放后，指针的地址依然存在，造成野指针，在堆上容易造成崩溃。而栈上的内存系统会自动处理，不会造成野指针。

  * assign：主要用于修饰基本数据类型，如NSInteger和CGFloat，这些数值主要存在于栈上。修饰对象类型时，不改变其引用计数，会产生悬垂指针，修饰的对象在被释放后，assign指针仍然指向原对象内存地址，如果使用assign指针继续访问原对象的话，就可能会导致内存泄漏或程序异常

  * copy与strong类似。不同之处是strong的复制是多个指针指向同一个地址，而copy的复制每次会在内存中拷贝一份对象，指针指向不同地址。copy一般用在修饰有可变对应类型的不可变对象上，如NSString, NSArray, NSDictionary。分为深拷贝和浅拷贝：

    * 浅拷贝：对内存地址的复制，让目标对象指针和原对象指向同一片内存空间会增加引用计数

    * 深拷贝：对对象内容的复制，开辟新的内存空间

      【可变对象的copy和mutableCopy都是深拷贝，不可变对象的copy是浅拷贝，mutableCopy是深拷贝，copy方法返回的都是不可变对象】

* Objective-C 中，基本数据类型的默认关键字是atomic, readwrite, assign；普通属性的默认关键字是atomic, readwrite, strong。

# 深拷贝和浅拷贝

## 1. 浅拷贝和深拷贝的区别？

* 浅拷贝：只复制指向对象的指针，而不复制引用对象本身。 
* 深拷贝：复制引用对象本身。内存中存在了两份独立对象本身，当修改A时，A_copy不变。

[详解iOS的深浅拷贝](https://www.jianshu.com/p/afca814fba36) 

# Category

* 分类有名字，类扩展没有分类名字，是一种特殊的分类。

* 分类只能扩展方法（属性仅仅是声明，并没真正实现），类扩展一般用于声明私有方法，私有属性，私有成员变量。 

* 在不修改原有类代码的情况下,可以给类添加方法 Categroy 给类扩展方法,或者关联属性, 
* Categroy底层结构也是一个结构体:内部存储这结构体的名字,那个类的分类,以及对象和类方法列表,协议,属性信息 通过Runtime加载某个类的所有Category数据 把所有Category的方法、属性、协议数据，合并到一个大数组中后面参与编译的Category数据，会在数组的前面 将合并后的分类数据（方法、属性、协议），插入到类原来数据的前面。

## 1. Objective-C的类可以多重继承么？可以实现多个接口么？Category是什么？重写一个类的方式用继承好还是分类好？为什么不要在category中重写一个类原有的方法？

Objective-c的类**不可以有多继承**，OC里面都是单继承，多继承可以用**Protocol委托代理来模拟实现**
可以实现多个接口，可以通过实现多个接口完成OC的多重继承。

Category是类别；

* 重写一个类的方式用继承好还是分类好：
  重写一个类的方式用继承还是分类.取决于具体情况.假如目标类有许多的子类.我们需要拓展这个类又不希望影响到原有的代码.继承后比较好.
  如果仅仅是拓展方法.分类更好.（不需要涉及到原先的代码）

分类中方法的优先级比原来类中的方法高，也就是说，在分类中重写了原来类中的方法，那么分类中的方法会覆盖原来类中的方法

* 为什么不要在category中重写一个类原有的方法：
  1. category没有办法去代替子类，它不能像子类一样通过super去调用父类的方法实现。如果category中重写覆盖了当前类中的某个方法，那么这个当前类中的原始方法实现，将永远不会被执行，这在某些方法里是致命的。(ps:这里提一下，+(void)load方法是一个特例，它会在当前类执行完之后再在category中执行。)
  2. 同时，一个category也不能可靠的覆盖另一个category中相同的类的相同的方法。例如UIViewController+A与UIViewController+B，都重写了viewDidLoad，我们就无法控制谁覆盖了谁。
  3. 通过观察头文件我们可以发现，Cocoa框架中的许多类都是通过category来实现功能的，可能不经意间你就覆盖了这些方法中的其一，有时候就会产生一些无法排查的异常原因。
  4. category的诞生只是为了让开发者更加方便的去拓展一个类，它的初衷并不是让你去改变一个类。
     结论：
     要重写方法，当然我们首推通过子类重写父类的方法，在一些不方便重写的情况下，我们也可以在category中用runtime进行method swizzling(方法的偷梁换柱)来实现。

# Block

## 1. block的注意点

1. 在block内部使用外部指针且会造成循环引用情况下，需要用weak修饰外部指针：

   __weak typeof(self) weakSelf = self;

2.  在block内部如果调用了延时函数还使用弱指针会取不到该指针，因为已经被销毁了，需要在block内部再将弱指针重新强引用一下。
   __strong typeof(self) strongSelf = weakSelf;

3. 如果需要在block内部改变外部栈区变量的话，需要在用__block修饰外部变量。

## 2. 什么是Block？

Block是将函数及其执行上下文封装起来的对象。

```objective-c
NSInteger num = 3;
    
NSInteger(^block)(NSInteger) = ^NSInteger(NSInteger n){
		return n*num;
};
    
block(2);
```

通过clang -rewrite-objc WYTest.m(文件名)命令编译该.m文件，发现该block被编译成这个形式:

```c
NSInteger num = 3;

NSInteger(*block)(NSInteger) = ((NSInteger (*)(NSInteger))&__WYTest__blockTest_block_impl_0((void *)__WYTest__blockTest_block_func_0, &__WYTest__blockTest_block_desc_0_DATA, num));

((NSInteger (*)(__block_impl *, NSInteger))((__block_impl *)block)->FuncPtr)((__block_impl *)block, 2);
```

其中WYTest是文件名，blockTest是方法名，这些可以忽略。
其中__WYTest__blockTest_block_impl_0结构体为

```c
struct __WYTest__blockTest_block_impl_0 {
  struct __block_impl impl;
  struct __WYTest__blockTest_block_desc_0* Desc;
  NSInteger num;
  __WYTest__blockTest_block_impl_0(void *fp, struct __WYTest__blockTest_block_desc_0 *desc, NSInteger _num, int flags=0) : num(_num) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```

__block_impl结构体为

```c
struct __block_impl {
  void *isa;//isa指针，所以说Block是对象
  int Flags;
  int Reserved;
  void *FuncPtr;//函数指针
};
```

block内部有isa指针，所以说其本质也是OC对象
block内部则为:

```c
static NSInteger __WYTest__blockTest_block_func_0(struct __WYTest__blockTest_block_impl_0 *__cself, NSInteger n) 
{
		NSInteger num = __cself->num; // bound by copy
		return n*num;
}
```

所以说 Block是将函数及其执行上下文封装起来的对象
既然block内部封装了函数，那么它同样也有参数和返回值。

## 3. Block的几种形式

* 分为全局Block(_NSConcreteGlobalBlock)、_
* _栈Block(_NSConcreteStackBlock)、
* 堆Block(_NSConcreteMallocBlock)三种形式

其中栈Block存储在栈(stack)区，堆Block存储在堆(heap)区，全局Block存储在已初始化数据(.data)区

1. **不使用外部变量的block是全局block**

   ```objective-c
   NSLog(@"%@",[^{
           NSLog(@"globalBlock");
       } class]);
   ```

   输出:

   ```
   __NSGlobalBlock__
   ```

   

2. **使用外部变量并且未进行copy操作的block是栈block**

   ```objective-c
   NSInteger num = 10;
       NSLog(@"%@",[^{
           NSLog(@"stackBlock:%zd",num);
       } class]);
   ```

   输出：

   ```
   __NSStackBlock__
   ```

   日常开发常用于这种情况:

   ```objective-c
   [self testWithBlock:^{
       NSLog(@"%@",self);
   }];
   
   - (void)testWithBlock:(dispatch_block_t)block {
       block();
   
       NSLog(@"%@",[block class]);
   }
   ```

3. **对栈block进行copy操作，就是堆block，而对全局block进行copy，仍是全局block**

   * 比如堆1中的全局进行copy操作，即赋值：

     ```objective-c
     void (^globalBlock)(void) = ^{
             NSLog(@"globalBlock");
         };
     
      NSLog(@"%@",[globalBlock class]);
     ```

     输出：

     ```
     __NSGlobalBlock__
     ```

     仍是全局block

   * 而对2中的栈block进行赋值操作：

     ```objective-c
     NSInteger num = 10;
     
     void (^mallocBlock)(void) = ^{
     
             NSLog(@"stackBlock:%zd",num);
         };
     
     NSLog(@"%@",[mallocBlock class]);
     ```

     输出：

     ```
     __NSMallocBlock__
     ```

     对栈blockcopy之后，并不代表着栈block就消失了，左边的mallock是堆block，右边被copy的仍是栈block
     比如:

     ```objective-c
     [self testWithBlock:^{
         
         NSLog(@"%@",self);
     }];
     
     - (void)testWithBlock:(dispatch_block_t)block
     {
         block();
         
         dispatch_block_t tempBlock = block;
         
         NSLog(@"%@,%@",[block class],[tempBlock class]);
     }
     ```

     输出：

     ```
     __NSStackBlock__,__NSMallocBlock__
     ```

   * **即如果对栈Block进行copy，将会copy到堆区，对堆Block进行copy，将会增加引用计数，对全局Block进行copy，因为是已经初始化的，所以什么也不做。**

     另外，__block变量在copy时，由于__forwarding的存在，栈上的__forwarding指针会指向堆上的__forwarding变量，而堆上的__forwarding指针指向其自身，所以，如果对__block的修改，实际上是在修改堆上的__block变量。

     **即__forwarding指针存在的意义就是，无论在任何内存位置，都可以顺利地访问同一个__block变量**。

   * 外由于block捕获的__block修饰的变量会去持有变量，那么如果用__block修饰self，且self持有block，并且block内部使用到__block修饰的self时，就会造成多循环引用，即self持有block，block 持有__block变量，而__block变量持有self，造成内存泄漏。
     比如:

     ```objective-c
      __block typeof(self) weakSelf = self;
         
         _testBlock = ^{
             
             NSLog(@"%@",weakSelf);
         };
         
         _testBlock();
     ```

     如果要解决这种循环引用，可以主动断开__block变量对self的持有，即在block内部使用完weakself后，将其置为nil，但这种方式有个问题，如果block一直不被调用，那么循环引用将一直存在。
     所以，我们最好还是用__weak来修饰self

## 4. Block变量截获

1. **局部变量截获 是值截获。 比如:**

   ```objective-c
       NSInteger num = 3;
       
       NSInteger(^block)(NSInteger) = ^NSInteger(NSInteger n){
           
           return n*num;
       };
       
       num = 1;
       
       NSLog(@"%zd",block(2));
   ```

   这里的输出是6而不是2，原因就是对局部变量num的截获是值截获。
   同样，在block里如果修改变量num，也是无效的，甚至编译器会报错。

   ```objective-c
   NSMutableArray * arr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
       
       void(^block)(void) = ^{
           
           NSLog(@"%@",arr);//局部变量
           
           [arr addObject:@"4"];
       };
       
       [arr addObject:@"3"];
       
       arr = nil;
       
       block();
   ```

   打印为1，2，3
   局部对象变量也是一样，截获的是值，而不是指针，在外部将其置为nil，对block没有影响，而该对象调用方法会影响

2. **局部静态变量截获 是指针截获。**

   ```objective-c
      static  NSInteger num = 3;
       
       NSInteger(^block)(NSInteger) = ^NSInteger(NSInteger n){
           
           return n*num;
       };
       
       num = 1;
       
       NSLog(@"%zd",block(2));
   ```

   输出为2，意味着num = 1这里的修改num值是有效的，即是指针截获。
   同样，在block里去修改变量m，也是有效的。

3. **全局变量，静态全局变量截获：不截获,直接取值。**

   我们同样用clang编译看下结果。

   ```objective-c
   static NSInteger num3 = 300;
   
   NSInteger num4 = 3000;
   
   - (void)blockTest
   {
       NSInteger num = 30;
       
       static NSInteger num2 = 3;
       
       __block NSInteger num5 = 30000;
       
       void(^block)(void) = ^{
           
           NSLog(@"%zd",num);//局部变量
           
           NSLog(@"%zd",num2);//静态变量
           
           NSLog(@"%zd",num3);//全局变量
           
           NSLog(@"%zd",num4);//全局静态变量
           
           NSLog(@"%zd",num5);//__block修饰变量
       };
       
       block();
   }
   ```

   编译后：

   ```c
   struct __WYTest__blockTest_block_impl_0 {
     struct __block_impl impl;
     struct __WYTest__blockTest_block_desc_0* Desc;
     NSInteger num;//局部变量
     NSInteger *num2;//静态变量
     __Block_byref_num5_0 *num5; // by ref//__block修饰变量
     __WYTest__blockTest_block_impl_0(void *fp, struct __WYTest__blockTest_block_desc_0 *desc, NSInteger _num, NSInteger *_num2, __Block_byref_num5_0 *_num5, int flags=0) : num(_num), num2(_num2), num5(_num5->__forwarding) {
       impl.isa = &_NSConcreteStackBlock;
       impl.Flags = flags;
       impl.FuncPtr = fp;
       Desc = desc;
     }
   };
   ```

   （ impl.isa = &_NSConcreteStackBlock;这里注意到这一句，即说明该block是栈block）
   可以看到局部变量被编译成值形式，而静态变量被编成指针形式，全局变量并未截获。而__block修饰的变量也是以指针形式截获的，并且生成了一个新的结构体对象：

   ```c
   struct __Block_byref_num5_0 {
     void *__isa;
   __Block_byref_num5_0 *__forwarding;
    int __flags;
    int __size;
    NSInteger num5;
   };
   ```

   该对象有个属性：num5，即我们用__block修饰的变量。
   这里__forwarding是指向自身的(栈block)。
   一般情况下，如果我们要对block截获的局部变量进行赋值操作需添加__block
   修饰符，而对全局变量，静态变量是不需要添加__block修饰符的。
   另外，block里访问self或成员变量都会去截获self。

# 堆、栈和队列

1. 从管理方式来讲
   * 对于栈来讲，是由编译器自动管理，无需我们手工控制；
   * 对于堆来说，释放工作由程序员控制，容易产生内存泄露(memory leak)
2. 从申请大小大小方面讲
   * 栈空间比较小
   * 堆控件比较大
3. 从数据存储方面来讲
   * 栈空间中一般存储基本类型，对象的地址
   * 堆空间一般存放对象本身，block的copy等

## 1. 堆 

堆是一种经过排序的树形数据结构，每个节点都有一个值，通常我们所说的堆的数据结构是指二叉树。所以堆在数据结构中通常可以被看做是一棵树的数组对象。

而且堆需要满足一下两个性质： 

1. 堆中某个节点的值总是不大于或不小于其父节点的值； 

2. 堆总是一棵完全二叉树。 堆分为两种情况，有最大堆和最小堆。将根节点最大的堆叫做最大堆或大根堆，根节点最小的堆叫做最小堆或小根堆，在一个摆放好元素的最小堆中，父结点中的元素一定比子结点的元素要小，但对于左右结点的大小则没有规定谁大谁小。 堆常用来实现优先队列，堆的存取是随意的，这就如同我们在图书馆的书架上取书，虽然书的摆放是有顺序的，但是我们想取任意一本时不必像栈一样，先取出前面所有的书，书架这种机制不同于箱子，我们可以直接取出我们想要的书。

 ## 2 栈 

栈是限定仅在表尾进行插入和删除操作的线性表。我们把允许插入和删除的一端称为栈顶，另一端称为栈底，不含任何数据元素的栈称为空栈。栈的特殊之处在于它限制了这个线性表的插入和删除位置，它始终只在栈顶进行。 栈是一种具有后进先出的数据结构，又称为后进先出的线性表，简称 LIFO（Last In First Out）结构。也就是说后存放的先取，先存放的后取，这就类似于我们要在取放在箱子底部的东西（放进去比较早的物体），我们首先要移开压在它上面的物体（放进去比较晚的物体）。 堆栈中定义了一些操作。两个最重要的是PUSH和POP。PUSH操作在堆栈的顶部加入一个元素。POP操作相反，在堆栈顶部移去一个元素，并将堆栈的大小减一。 栈的应用—递归 

## 3 队列 

队列是只允许在一端进行插入操作、而在另一端进行删除操作的线性表。允许插入的一端称为队尾，允许删除的一端称为队头。它是一种特殊的线性表，特殊之处在于它只允许在表的前端进行删除操作，而在表的后端进行插入操作，和栈一样，队列是一种操作受限制的线性表。 队列是一种先进先出的数据结构，又称为先进先出的线性表，简称 FIFO（First In First Out）结构。也就是说先放的先取，后放的后取，就如同行李过安检的时候，先放进去的行李在另一端总是先出来，后放入的行李会在最后面出来。

# UIView 和 CALayer 是什么关系？

* UIView 继承 UIResponder，而 UIResponder 是响应者对象，可以对iOS 中的事件响应及传递，CALayer 没有继承自 UIResponder，所以 CALayer 不具备响应处理事件的能力。CALayer 是 QuartzCore 中的类，是一个比较底层的用来绘制内容的类，用来绘制UI

* UIView 对 CALayer 封装属性，对 UIView 设置 frame、center、bounds 等位置信息时，其实都是UIView 对 CALayer 进一层封装，使得我们可以很方便地设置控件的位置；例如圆角、阴影等属性， UIView 就没有进一步封装，所以我们还是需要去设置 Layer 的属性来实现功能。

* UIView 是 CALayer 的代理，UIView 持有一个 CALayer 的属性，并且是该属性的代理，用来提供一些 CALayer 行的数据，例如动画和绘制。

# JS 和 OC 互相调用的几种方式？

js调用oc的三种方式:

1. 通过替换js中的function(方法)
2. 通过注入对象,直接调用对象方法
3. 利用网页重定向,截取字符串.

oc调用js代码两种方式

1. 通过webVIew调用 webView stringByEvaluatingJavaScriptFromString: 调用
2. 通过JSContext调用[context evaluateScript:];

# Http && Https

## 1. 如何理解HTTP?/Http 和 Https 的区别？Https为什么更加安全？

HTTP本质上是一种协议，全称是Hypertext Transfer Protocol，即超文本传输协议。HTTP是一个基于TCP/IP通信协议来传递数据, 该协议用于规定客户端与服务端之间的传输规则，所传输的内容不局限于文本(其实可以传输任意类型的数据)。

一次HTTP可以看做是一个事务,其工作过程分为4步:

1. 客户端与服务器建立连接
2. 建立连接后,客户端给服务端发送请求
3. 服务器收到消息后,给与响应操作
4. 客户端收到消息后,展示到屏幕上,断开连接.

区别：

1. HTTPS 需要向机构申请 CA 证书，极少免费。

2. HTTP 属于明文传输，HTTPS基于 SSL 进行加密传输。

3. HTTP 端口号为 80，HTTPS 端口号为 443 。
4. HTTPS 是加密传输，有身份验证的环节，更加安全。

安全

1. SSL(安全套接层) TLS(传输层安全)

2. 以上两者在传输层之上，对网络连接进行加密处理，保障数据的完整性，更加的安全。

# 设计模式

## 1. 编程中的六大设计原则？

1. 单一职责原则，通俗地讲就是一个类只做一件事
   * CALayer：动画和视图的显示。
   * UIView：只负责事件传递、事件响应。

2. 开闭原则，对修改关闭，对扩展开放。 要考虑到后续的扩展性，而不是在原有的基础上来回修改

3. 接口隔离原则，使用多个专门的协议、而不是一个庞大臃肿的协议，如 UITableviewDelegate + UITableViewDataSource

4. 依赖倒置原则，抽象不应该依赖于具体实现、具体实现可以依赖于抽象。 调用接口感觉不到内部是如何操作的

5. 里氏替换原则，父类可以被子类无缝替换，且原有的功能不受任何影响 如：KVO

6. 迪米特法则，一个对象应当对其他对象尽可能少的了解，实现高聚合、低耦合

# 沙盒

## 1. 沙盒目录结构是怎样的？各自用于那些场景？

* Application：存放程序源文件，上架前经过数字签名，上架后不可修改
* Documents：常用目录，iCloud备份目录，存放数据
* Library
  * Caches：存放体积大又不需要备份的数据
  * Preference：设置目录，iCloud会备份设置信息
* tmp：存放临时文件，不会被备份，而且这个文件下的数据有可能随时被清除的可能

# 数据持久化

## 1. iOS中数据持久化方案有哪些？

* NSUserDefault 简单数据快速读写
* Property list (属性列表)文件存储
* Archiver (归档)
* SQLite 本地数据库
* CoreData（是iOS5之后才出现的一个框架，本质上是对SQLite的一个封装，它提供了对象-关系映射(ORM)的功能，即能够将OC对象转化成数据，保存在SQLite数据库文件中，也能够将保存在数据库中的数据还原成OC对象，通过CoreData管理应用程序的数据模型）

# ViewController

## 1. 单个viewController的生命周期？

```objective-c
- initWithCoder:(NSCoder *)aDecoder：（如果使用storyboard或者xib）
- loadView：加载view
- viewDidLoad：view加载完毕
- viewWillAppear：控制器的view将要显示
- viewWillLayoutSubviews：控制器的view将要布局子控件
- viewDidLayoutSubviews：控制器的view布局子控件完成  
- viewDidAppear:控制器的view完全显示
- viewWillDisappear：控制器的view即将消失的时候
- viewDidDisappear：控制器的view完全消失的时候
- dealloc 控制器销毁
```

# 离屏渲染

## 1. iOS图片设置圆角性能问题

1. 直接使用setCornerRadius
   * 这样设置会触发离屏渲染，比较消耗性能。比如当一个页面上有十几头像这样设置了圆角会明显感觉到卡顿。
      注意：png图片UIImageView处理圆角是不会产生离屏渲染的。（ios9.0之后不会离屏渲染，ios9.0之前还是会离屏渲染）

 2. setCornerRadius设置圆角之后，shouldRasterize=YES光栅化
 
   * avatarImageView.layer.shouldRasterize = YES;
        avatarImageViewUrl.layer.rasterizationScale=[UIScreen mainScreen].scale;  //UIImageView不加这句会产生一点模糊shouldRasterize=YES设置光栅化，可以使离屏渲染的结果缓存到内存中存为位图，
     使用的时候直接使用缓存，节省了一直离屏渲染损耗的性能。
   
     但是如果layer及sublayers常常改变的话，它就会一直不停的渲染及删除缓存重新
     创建缓存，所以这种情况下建议不要使用光栅化，这样也是比较损耗性能的。
   
 3. 直接覆盖一张中间为圆形透明的图片（推荐使用）

 4. UIImage drawInRect绘制圆角

    * 这种方式GPU损耗低内存占用大，而且UIButton上不知道怎么绘制，可以用
      UIimageView添加个点击手势当做UIButton使用。

 5. SDWebImage处理图片时Core Graphics绘制圆角（暂时感觉是最优方法)

[iOS图片设置圆角性能问题](https://www.jianshu.com/p/34189f62bfd8) 

# 线程

## 1. 进程与线程

* 进程：
  1. 进程是一个具有一定独立功能的程序关于某次数据集合的一次运行活动，它是操作系统分配资源的基本单元.
  2. 进程是指在系统中正在运行的一个应用程序，就是一段程序的执行过程,我们可以理解为手机上的一个app.
  3. 每个进程之间是独立的，每个进程均运行在其专用且受保护的内存空间内，拥有独立运行所需的全部资源

* 线程
  1. 程序执行流的最小单元，线程是进程中的一个实体.
  2. 一个进程要想执行任务,必须至少有一条线程.应用程序启动的时候，系统会默认开启一条线程,也就是主线程

* 进程和线程的关系
  1. 线程是进程的执行单元，进程的所有任务都在线程中执行
  2. 线程是 CPU 分配资源和调度的最小单位
  3. 一个程序可以对应多个进程(多进程),一个进程中可有多个线程,但至少要有一条线程
  4. 同一个进程内的线程共享进程资源

## 2. iOS中实现多线程的几种方案，各自有什么特点？讲一下具体使用场景/在项目什么时候选择使用 GCD，什么时候选 择 NSOperation?

pthread 是一套通用的多线程的 API，可以在Unix / Linux / Windows 等系统跨平台使用，使用 C 语言编写，需要程序员自己管理线程的生命周期，使用难度较大，我们在 iOS 开发中几乎不使用 pthread，但是还是来可以了解一下的。

* NSThread 面向对象的，需要程序员手动创建线程，但不需要手动销毁。子线程间通信很难。
* GCD c语言，充分利用了设备的多核，自动管理线程生命周期。比NSOperation效率更高。
* NSOperation 基于gcd封装，更加面向对象，比gcd多了一些功能。

【场景：1.多个网络请求完成后执行下一步 2.多个网络请求顺序执行后执行下一步 3.异步操作两组数据时, 执行完第一组之后, 才能执行第二组】

项目中使用 NSOperation 的优点是 NSOperation 是对线程的高度抽象，在项目中使 用它，会使项目的程序结构更好，子类化 NSOperation 的设计思路，是具有面向对 象的优点(复用、封装)，使得实现是多线程支持，而接口简单，建议在复杂项目中 使用。

项目中使用 GCD 的优点是 GCD 本身非常简单、易用，对于不复杂的多线程操 作，会节省代码量，而 Block 参数的使用，会是代码更为易读，建议在简单项目中 使用。

[iOS 多线程：『pthread、NSThread』详尽总结](https://www.jianshu.com/p/cbaeea5368b1) 
[iOS 多线程：『GCD』详尽总结](https://www.jianshu.com/p/2d57c72016c6) 
[iOS 多线程：『NSOperation、NSOperationQueue』详尽总结](https://www.jianshu.com/p/4b1d77054b35)

## 3. 什么是GCD?GCD 的队列类型?

GCD(Grand Central Dispatch), 又叫做大中央调度, 它对线程操作进行了封装,加入了很多新的特性,内部进行了效率优化,提供了简洁的C语言接口, 使用更加高效,也是苹果推荐的使用方式.

GCD的队列可以分为2大类型

1. 并发队列（Concurrent Dispatch Queue）
   可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）
   并发功能只有在异步（dispatch_async）函数下才有效
2. 串行队列（Serial Dispatch Queue）
   让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）,按照FIFO顺序执行.

## 4. 什么是同步和异步任务派发(synchronous和asynchronous)?

GCD多线程经常会使用 dispatch_sync和dispatch_async函数向指定队列添加任务,分别是同步和异步

* 同步：指阻塞当前线程,既要等待添加的耗时任务块Block完成后,函数才能返回,后面的代码才能继续执行
* 异步：指将任务添加到队列后,函数立即返回,后面的代码不用等待添加的任务完成后即可执行,异步提交无法确定任务执行顺序

## 5. dispatch_barrier_(a)sync使用?

栅栏函数：一个dispatch barrier 允许在一个并发队列中创建一个同步点。当在并发队列中遇到一个barrier, 他会延迟执行barrier的block,等待所有在barrier之前提交的blocks执行结束。 这时，barrier block自己开始执行。 之后， 队列继续正常的执行操作。

# Runtime

## 1. Runtime实现的机制是什么？能做什么事情呢？

runtime简称运行时。OC是运行时机制，也就是在运行时才做一些处理。例如：C语言在编译的时候就知道要调用哪个方法函数，而OC在编译的时候并不知道要调用哪个方法函数，只有在运行的时候才知道调用的方法函数名称，来找到对应的方法函数进行调用。

1. 发送消息
   【场景：方法调用】
2. 交换方法实现（交换系统的方法）
   【场景：当第三方框架或者系统原生方法功能不能满足我们的时候，我们可以在保持系统原有方法功能的基础上，添加额外的功能。】
3. 动态添加方法
   【场景：如果一个类方法非常多，加载类到内存的时候也比较耗费资源，需要给每个方法生成映射表，可以使用动态给某个类，添加方法解决。】
4. 利用关联对象（AssociatedObject）给分类添加属性
   【场景：分类是不能自定义属性和变量的，这时候可以使用runtime动态添加属性方法；
    原理：给一个类声明属性，其实本质就是给这个类添加关联，并不是直接把这个值的内存空间添加到类存空间。 】
5. 遍历类的所有成员变量
   【
   1. NSCoding自动归档解档
        场景：如果一个模型有许多个属性，实现自定义模型数据持久化时，需要对每个属性都实现一遍encodeObject 和 decodeObjectForKey方法，比较麻烦。我们可以使用Runtime来解决。
        原理：用runtime提供的函数遍历Model自身所有属性，并对属性进行encode和decode操作。
   2. 字典转模型
        原理：利用Runtime，遍历模型中所有属性，根据模型的属性名，去字典中查找key，取出对应的值，给模型的属性赋值。
   3. 访问私有变量
        场景：修改textfield的占位文字颜色
      】
6. 利用消息转发机制解决方法找不到的异常问题

[教你深刻理解Runtime机制](https://www.jianshu.com/p/6fd68ac84701)

[Runtime在工作中的运用](https://juejin.im/post/6844903826068078605#heading-5)

[Runtime运行机制](https://www.jianshu.com/p/1f43dd215159) 

# RunLoop

## 1. 什么是 RunLoop？

从字面上讲就是运行循环，它内部就是do-while循环，在这个循环内部不断地处理各种任务。 一个线程对应一个RunLoop，基本作用就是保持程序的持续运行，处理app中的各种事件。通过runloop，有事运行，没事就休息，可以节省cpu资源，提高程序性能。 主线程的run loop默认是启动的。iOS的应用程序里面，程序启动后会有一个如下的main()函数 

```objective-c
int main(int argc, char * argv[]) { 
  @autoreleasepool { 
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class])); 		} 
}
```

* RunLoop，是多线程的法宝，即一个线程一次只能执行一个任务，执行完任务后就会退出线程。主线程执行完即时任务时会继续等待接收事件而不退出。非主线程通常来说就是为了执行某一任务的，执行完毕就需要归还资源，因此默认是不运行RunLoop的；
* 每一个线程都有其对应的RunLoop，只是默认只有主线程的RunLoop是启动的，其它子线程的RunLoop默认是不启动的，若要启动则需要手动启动；
* 在一个单独的线程中，如果需要在处理完某个任务后不退出，继续等待接收事件，则需要启用RunLoop；
* NSRunLoop提供了一个添加NSTimer的方法，可以指定Mode，如果要让任何情况下都回调，则需要设置Mode为Common模式；
* 实质上，对于子线程的runloop默认是不存在的，因为苹果采用了懒加载的方式。如果我们没有手动调用[NSRunLoop currentRunLoop]的话，就不会去查询是否存在当前线程的RunLoop，也就不会去加载，更不会创建。

[深入理解RunLoop](https://blog.ibireme.com/2015/05/18/runloop/) [iOS 多线程：『RunLoop』详尽总结](https://www.jianshu.com/p/d260d18dd551) 

## 2. 以scheduledTimerWithTimeInterval的方式触发的timer，在滑动页面上的列表时，timer会暂停，为什么？该如何解决？

原因在于滑动时当前线程的runloop切换了mode用于列表滑动，导致timer暂停。
runloop中的mode主要用来指定事件在runloop中的优先级，有以下几种：

* Default（NSDefaultRunLoopMode）：默认，一般情况下使用；
* Connection（NSConnectionReplyMode）：一般系统用来处理NSConnection相关事件，开发者一般用不到；
* Modal（NSModalPanelRunLoopMode）：处理modal panels事件；
* Event Tracking（NSEventTrackingRunLoopMode）：用于处理拖拽和用户交互的模式。
* Common（NSRunloopCommonModes）：模式合集。默认包括Default，Modal，Event Tracking三大模式，可以处理几乎所有事件。
回到题中的情境。滑动列表时，runloop的mode由原来的Default模式切换到了Event Tracking模式，timer原来好好的运行在Default模式中，被关闭后自然就停止工作了。
解决方法其一是将timer加入到NSRunloopCommonModes中。其二是将timer放到另一个线程中，然后开启另一个线程的runloop，这样可以保证与主线程互不干扰，而现在主线程正在处理页面滑动。

解决：

* 方法1
  `[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];`
* 方法2

```objective-c
dispatch_async(dispatch_get_global_queue(0, 0), ^{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeat:) userInfo:nil repeats:true];
		[[NSRunLoop currentRunLoop] run];
});
```

# Instrument

Instruments里面工具很多，常用的有：

1. Time Profiler：性能分析,用来检测应用CPU的使用情况.可以看到应用程序中各个方法正在消耗CPU时间。
2. Zoombies：检查是否访问了僵尸对象，但是这个工具只能从上往下检查，不智能
3. Allocations：用来检查内存，写算法的那批人也用这个来检查
4. Leaks：检查内存，看是否有内存泄漏
5. Core Animation：评估图形性能，这个选项检查了图片是否被缩放，以及像素是否对齐。被放缩的图片会被标记为黄色，像素不对齐则会标注为紫色。黄色、紫色越多，性能越差。

# 常用的排序算法

选择排序、冒泡排序、插入排序三种排序算法可以总结为如下：

都将数组分为已排序部分和未排序部分。

选择排序将已排序部分定义在左端，然后选择未排序部分的最小元素和未排序部分的第一个元素交换。

冒泡排序将已排序部分定义在右端，在遍历未排序部分的过程执行交换，将最大元素交换到最右端。

插入排序将已排序部分定义在左端，将未排序部分元的第一个元素插入到已排序部分合适的位置。

【选择排序】：最值出现在起始端

 *	第1趟：在n个数中找到最小(大)数与第一个数交换位置
 *	第2趟：在剩下n-1个数中找到最小(大)数与第二个数交换位置
 *	重复这样的操作...依次与第三个、第四个...数交换位置
 *	第n-1趟，最终可实现数据的升序（降序）排列。

```swift
void selectSort(int *arr, int length) {
	for (int i = 0; i < length - 1; i++) { //趟数
    for (int j = i + 1; j < length; j++) { //比较次数
        if (arr[i] > arr[j]) {
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
     }
	}
}
```

【冒泡排序】：相邻元素两两比较，比较完一趟，最值出现在末尾

 *	第1趟：依次比较相邻的两个数，不断交换（小数放前，大数放后）逐个推进，最值最后出现在第n个元素位置
 *	第2趟：依次比较相邻的两个数，不断交换（小数放前，大数放后）逐个推进，最值最后出现在第n-1个元素位置
 *	……   ……
 *	第n-1趟：依次比较相邻的两个数，不断交换（小数放前，大数放后）逐个推进，最值最后出现在第2个元素位置	

```swift
void bublleSort(int *arr, int length) {
	for(int i = 0; i < length - 1; i++) { //趟数
    for(int j = 0; j < length - i - 1; j++) { //比较次数
        if(arr[j] > arr[j+1]) {
            int temp = arr[j];
            arr[j] = arr[j+1];
            arr[j+1] = temp;
        }
    } 
	}
}
```

折半查找：优化查找时间（不用遍历全部数据）折半查找的原理：

* 数组必须是有序的
* 必须已知min和max（知道范围）
* 动态计算mid的值，取出mid对应的值进行比较
* 如果mid对应的值大于要查找的值，那么max要变小为mid-1
* 如果mid对应的值小于要查找的值，那么min要变大为mid+1

```swift
// 已知一个有序数组, 和一个key, 要求从数组中找到key对应的索引位置 
int findKey(int *arr, int length, int key) {
		int min = 0, max = length - 1, mid;
		while (min <= max) {
    		mid = (min + max) / 2; //计算中间值
    		if (key > arr[mid]) {
       		 min = mid + 1;
    		} else if (key < arr[mid]) {
      		  max = mid - 1;
    		} else {
      		  return mid;
    		}
		}
	return -1;
}
```

# 加密

## 1. 对称加密和非对称加密的区别？

1. 对称加密又称公开密钥加密，加密和解密都会用到同一个密钥，如果密钥被攻击者获得，此时加密就失去了意义。常见的对称加密算法有DES、3DES、AES、Blowfish、IDEA、RC5、RC6。
2. 非对称加密又称共享密钥加密，使用一对非对称的密钥，一把叫做私有密钥，另一把叫做公有密钥；公钥加密只能用私钥来解密，私钥加密只能用公钥来解密。常见的公钥加密算法有：RSA、ElGamal、背包算法、Rabin（RSA的特例）、迪菲－赫尔曼密钥交换协议中的公钥加密算法、椭圆曲线加密算法）。

# 性能优化

## 1. 说一下工作中你怎么做性能优化的

一般都是说关于tableView的优化处理，

* 造成tableView卡顿的原因
  1. 没有使用cell的重用标识符，导致一直创建新的cell
  2. cell的重新布局
  3. 没有提前计算并缓存cell的属性及内容
  4. cell中控件的数量过多
  5. 使用了ClearColor，无背景色，透明度为0
  6. 更新只使用tableView.reloadData()（如果只是更新某组的话，使用reloadSection进行局部更新）
  7. 加载网络数据，下载图片，没有使用异步加载，并缓存
  8. 使用addView 给cell动态添加view
  9. 没有按需加载cell（cell滚动很快时，只加载范围内的cell）
  10. 实现无用的代理方法(tableView只遵守两个协议)
  11. 没有做缓存行高（estimatedHeightForRow不能和HeightForRow里面的layoutIfNeed同时存在，这两者同时存在才会出现“窜动”的bug。
      建议是：只要是固定行高就写预估行高来减少行高调用次数提升性能。如果是动态行高就不要写预估方法了，用一个行高的缓存字典来减少代码的调用次数即可）
  12. 做了多余的绘制工作（在实现drawRect:的时候，它的rect参数就是需要绘制的区域，这个区域之外的不需要进行绘制）
  13. 没有预渲染图像。（当新的图像出现时，仍然会有短暂的停顿现象。解决的办法就是在bitmap context里先将其画一遍，导出成UIImage对象，然后再绘制到屏幕）

* 提升tableView的流畅度
  本质上是降低 CPU、GPU 的工作，从这两个大的方面去提升性能。
  1. CPU：对象的创建和销毁、对象属性的调整、布局计算、文本的计算和排版、图片的格式转换和解码、图像的绘制
  2. GPU：纹理的渲染

* 卡顿优化在 CPU 层面
  1. 尽量用轻量级的对象，比如用不到事件处理的地方，可以考虑使用 CALayer 取代 UIView
  2. 不要频繁地调用 UIView 的相关属性，比如 frame、bounds、transform 等属性，尽量减少不必要的修改
  3. 尽量提前计算好布局，在有需要时一次性调整对应的属性，不要多次修改属性
  4. Autolayout 会比直接设置 frame 消耗更多的 CPU 资源
  5. 图片的 size 最好刚好跟 UIImageView 的 size 保持一致
  6. 控制一下线程的最大并发数量
  7. 尽量把耗时的操作放到子线程
  8. 文本处理（尺寸计算、绘制）
  9. 图片处理（解码、绘制）

* 卡顿优化在 GPU层面
  1. 尽量避免短时间内大量图片的显示，尽可能将多张图片合成一张进行显示
  2. GPU能处理的最大纹理尺寸是 4096x4096，一旦超过这个尺寸，就会占用 CPU 资源进行处理，所以纹理尽量不要超过这个尺寸
  3. 尽量减少视图数量和层次
  4. 减少透明的视图（alpha<1），不透明的就设置 opaque 为 YES
  5. 尽量避免出现离屏渲染

[iOS 保持界面流畅的技巧](https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/) 

## 2. APP启动时间应从哪些方面优化？

App启动时间可以通过xcode提供的工具来度量，在Xcode的Product->Scheme-->Edit Scheme->Run->Auguments中，将环境变量DYLD_PRINT_STATISTICS设为YES，优化需以下方面入手

* dylib loading time
  * 核心思想是减少dylibs的引用
  * 合并现有的dylibs（最好是6个以内）
  * 使用静态库
* rebase/binding time
  * 核心思想是减少DATA块内的指针
  * 减少Object C元数据量，减少Objc类数量，减少实例变量和函数（与面向对象设计思想冲突）
  * 减少c++虚函数
  * 多使用Swift结构体（推荐使用swift）
* ObjC setup time
  * 核心思想同上，这部分内容基本上在上一阶段优化过后就不会太过耗时
* initializer time
  * 使用initialize替代load方法
  * 减少使用c/c++的attribute((constructor))；推荐使用dispatch_once() pthread_once() std:once()等方法
* 推荐使用swift
  * 不要在初始化中调用dlopen()方法，因为加载过程是单线程，无锁，如果调用dlopen则会变成多线程，会开启锁的消耗，同时有可能死锁
  * 不要在初始化中创建线程

[iOS App 启动过程（一）：基础概念](https://www.jianshu.com/p/27b2e9d744f0)

[iOS App 启动过程（二）：从 exec() 到 main()](https://www.jianshu.com/p/ff8d039195bf)

[iOS App 启动过程（三）：main() 及生命周期](https://www.jianshu.com/p/7fd94aead693) 

# 组件化

## 1. 组件化有什么好处？

* 业务分层、解耦，使代码变得可维护；
* 有效的拆分、组织日益庞大的工程代码，使工程目录变得可维护；
* 便于各业务功能拆分、抽离，实现真正的功能复用；
* 业务隔离，跨团队开发代码控制和版本风险控制的实现；
* 模块化对代码的封装性、合理性都有一定的要求，提升开发同学的设计能力；
* 在维护好各级组件的情况下，随意组合满足不同客户需求；（只需要将之前的多个业务组件模块在新的主App中进行组装即可快速迭代出下一个全新App）

## 2. 如何组件化解耦的？

* 分层
  1. 基础功能组件：按功能分库，不涉及产品业务需求，跟库Library类似，通过良好的接口拱上层业务组件调用；不写入产品定制逻辑，通过扩展接口完成定制；
  2. 基础UI组件：各个业务模块依赖使用，但需要保持好定制扩展的设计
  3. 业务组件：业务功能间相对独立，相互间没有Model共享的依赖；业务之间的页面调用只能通过UIBus进行跳转；业务之间的逻辑Action调用只能通过服务提供；
  4. 中间件：target-action，url-block，protocol-class

[iOS组件化方案的几种实现](https://www.jianshu.com/p/2a7e2aa0748b) 

# 第三方

## 1. SDWebImage加载图片过程

[iOS内存缓存和磁盘缓存的区别](https://www.jianshu.com/p/3b0e290cc049)

缓存分为内存缓存和磁盘缓存两种，其中内存是指当前程序的运行空间，缓存速度快容量小，是临时存储文件用的，供CPU直接读取，比如说打开一个程序,他是在内存中存储,关闭程序后内存就又回到原来的空闲空间；磁盘是程序的存储空间，缓存容量大速度慢可持久化与内存不同的是磁盘是永久存储东西的，只要里面存放东西,不管运行不运行 ，他都占用空间！磁盘缓存是存在Library/Caches。

1. 首先显示占位图 
2. 在webimagecache中寻找图片对应的缓存，它是以url为数据索引先在内存中查找是否有缓存； 
3. 如果没有缓存，就通过md5处理过的key来在磁盘中查找对应的数据，如果找到就会把磁盘中的数据加到内存中，并显示出来；
4.  如果内存和磁盘中都没有找到，就会向远程服务器发送请求，开始下载图片； 
5. 下载完的图片加入缓存中，并写入到磁盘中；
6. 整个获取图片的过程是在子线程中进行，在主线程中显示。

## 2. AFNetworking 底层原理分析

* AFNetworking是封装的NSURLSession的网络请求，由五个模块组成：分别由NSURLSession,Security,Reachability,Serialization,UIKit五部分组成 
* NSURLSession：网络通信模块（核心模块） 对应 AFNetworking中的 AFURLSessionManager和对HTTP协议进行特化处理的AFHTTPSessionManager,AFHTTPSessionManager是继承于AFURLSessionmanager的 
* Security：网络通讯安全策略模块 对应 AFSecurityPolicy 
* Reachability：网络状态监听模块 对应AFNetworkReachabilityManager 
* Seriaalization：网络通信信息序列化、反序列化模块 对应 AFURLResponseSerialization 
* UIKit：对于iOS UIKit的扩展库