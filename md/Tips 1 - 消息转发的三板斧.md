## 前言

在 Objective-C 中，一个方法的调用，编译器会将其被转成 `objc_msgSend` 的方式，沿着这个对象或者类的继承链，依次去查找是否有对应的方法实现，如果查找至根类，也就是 `NSObject` 都没有找到对应的方法，那么就会触发消息转发流程。如果你在消息转发流程，还是没有进行处理，那么系统就会报错，程序终止。

这篇文章，只讲消息转发流程。（符合单一职责的设计模式，dog head）

## 三板斧

三板斧其实都是模板方法，只要实现对应的模板方法即可。

![消息转发.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/40f5455940214ea6942a593cea12a0fd~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

### 第一斧：动态方法解析

首先，Runtime 会去调用 `+resolveInstanceMethod:`（实例方法） 或 `+resolveClassMethod:`（类方法），让你有机会去动态的添加一个方法，返回 `YES`，就会重启消息发送流程，再执行一次方法调用。

举个例子：

```objc
#import "ViewController.h"
#import <objc/runtime.h>

@interface Cat : NSObject

@end

@implementation Cat

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(fly)) {
        class_addMethod([self class], sel, (IMP)run, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void run(id obj, SEL _cmd) {
    NSLog(@"Cat run");
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Cat *cat = [[Cat alloc] init];
    [cat performSelector:@selector(fly)];
}

@end
复制代码
```

尝试去调用 `Cat` 类中的 `fly` 方法，但是 `Cat` 中并没有 `fly` 方法，所以使用 `class_addMethod` 去动态的添加了一个方法，`sel` 依然是 `fly`，但是 IMP 改成了 `run` 方法。`sel` 可以理解为方法的名字，IMP 则是方法的实现，也就是这样处理之后，`Cat` 中被添加了一个名为 `fly`，但是实现却是 `run` 的方法，外界依然是通过 `fly` 来进行调用。

处理之后的打印结果：

```c
Cat run
复制代码
```

### 第二板斧：重定向

如果没有在第一步中，去动态的添加一个方法，那么就会执行到下一步，重定向，重定向意思是，你这没有这个方法，但是别人有，你让别人来实现这个方法。

例子：

```objc
#import "ViewController.h"
#import <objc/runtime.h>

@interface Bird : NSObject

@end

@implementation Bird

- (void)fly {
    NSLog(@"Bird fly");
}

@end

@interface Cat : NSObject

@end

@implementation Cat

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(fly)) {
//        class_addMethod([self class], sel, (IMP)run, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

//
//void run(id obj, SEL _cmd) {
//    NSLog(@"Cat run");
//}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(fly)) {
        return [[Bird alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Cat *cat = [[Cat alloc] init];
    [cat performSelector:@selector(fly)];
}

@end
复制代码
```

输出是：

```c
Bird fly
复制代码
```

如果打开注释的代码，因为是先执行 `resolveInstanceMethod:` 方法，并且在其中添加的新的方法实现，所以不会走到 `forwardingTargetForSelector:`，输出是：

```c
Cat run
复制代码
```

不管 `resolveInstanceMethod:` 返回是 `YES` 还是 `NO`。

### 第三板斧：完整的消息转发

最后一步像是一个那些不能被识别的消息的分发中心，它可以将这些消息转发给不同的对象，也可以将一个消息翻译成另外的一个消息，或者简单的吃掉某些消息，因此没有响应也没有错误，不会导致你的程序 crash。它也可以对不同的消息提供相同的响应，这一切都取决于方法的具体实现，该方法提供的是将不同对象连接到消息链的能力。

主要是两个方法，一个方法是 `+(NSMethodSignature *)methodSignatureForSelector:`，这个方法用来获取一个合适的方法签名，我们之前添加方法时用到的 `v@:` 就是一个方法的签名，具体的签名规则，可以看一下苹果的文档 [Type Encodings](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FCocoa%2FConceptual%2FObjCRuntimeGuide%2FArticles%2FocrtTypeEncodings.html)，有很详细的说明。

如果要触发最后一个方法，这个签名必须是正确的函数签名，如果返回的是 `nil`，Runtime 会直接发出 `-doseNotRecognizeSelector:` 消息，程序直接 crash。

最后一个方法，就是 `forwardInvocation:` 方法，我们直接看例子：

```objc
#import "ViewController.h"
#import <objc/runtime.h>

@interface Bird : NSObject

@end

@implementation Bird

- (void)fly {
    NSLog(@"Bird fly");
}

@end

@interface Cat : NSObject

@end

@implementation Cat

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(fly)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    Bird *bird = [[Bird alloc] init];
    if ([bird respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:bird];
    }
    else {
        [super forwardInvocation:anInvocation];
    }
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Cat *cat = [[Cat alloc] init];
    [cat performSelector:@selector(fly)];
} 

@end
复制代码
```

这里的处理，还是将消息转给 `Bird` 类去处理，但是你也可以做其他的实现，或者简单点，什么都不实现（不推荐），那么执行也不会报错。

## 总结

其实消息转发的流程是简单的，毕竟都有对应的模板方法，依次调用即可，这也是 Objective-C 是一门动态语言的一个体现，毕竟我们可以在运行时随意的调整方法的调用。

## 链接

[Message Forwarding (官方文档)](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FCocoa%2FConceptual%2FObjCRuntimeGuide%2FArticles%2FocrtForwarding.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40008048-CH105-SW1)



作者：_Terry
链接：https://juejin.cn/post/7168322422083420167
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。