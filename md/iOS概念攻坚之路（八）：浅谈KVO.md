## 简介

KVO，Key-Value Observing，键值观察，是一种机制，允许成为其他对象的观察者，当被观察对象的某个被观察的属性发生改变时，注册的观察者便能得到通知。 机制很简单，就比如在某宝买东西，添加了这个东西的价格变化的通知，每次价格发生变化，某宝就会发个通知告诉我，这个机制就类似 KVO。

## 使用方法

### 基本使用

有几个基本的方法：添加监听、移除监听和值改变时的回调方法。

```Objc
// 添加监听
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

// 移除监听
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));

// 值改变时通知
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context;
复制代码
```

使用也很简单，就是先监听某个属性（通过 `keyPath` 的方式），然后实现 `observeValueForKeyPath:ofObject:change:context`方法来拿到对应属性的变化，最后记得移除监听即可。

举个栗子。

```Objc
@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@end
复制代码
```

有个 `Person` 的类，它有个属性是 `name`，下面我们来监听这个 `name`。 这是我的 `KVOTestViewController`：

```Objc
@interface KvoTestViewController ()
@property (nonatomic, strong) Person *person;
@end

@implementation KvoTestViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [[Person alloc] init];
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    // 添加监听
    [self.person addObserver:self forKeyPath:@"name" options:options context:nil];
}

// 监听改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"监听到%@的%@属性改变了 - %@ - %@", object, keyPath, change, context);
}

-(void)dealloc {
    // 移除监听
    [self.person removeObserver:self forKeyPath:@"name"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 触发值改变
    self.person.name = @"xiaoming";
}

@end
复制代码
```

这样就是一个简单的监听流程了。

### 进阶使用

#### 观察属性.属性的变化

比如这个 `Person` 还有个 `Dog`：

```Objc
@interface Dog : NSObject
@property (nonatomic, assign) NSInteger age;
@end

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Dog *dog;
@end
复制代码
```

监听狗子的年龄：

```Objc
- (void)viewDidLoad {
    self.person.dog = [[Dog alloc] init];
    [self.person addObserver:self forKeyPath:@"dog.age" options:options context:nil];
}
复制代码
```

其实就是 `keyPath` 使用 `dog.age` 就可以了。

#### 观察数组的改变

比如这个 `Person` 还有很多辆 `Car`：

```Objc
@interface Person : NSObject
@property (nonatomic, strong) NSMutableArray<NSString *> *cars;
@end
复制代码
```

一样的监听：

```Objc
[self.person addObserver:self forKeyPath:@"cars" options:options context:nil];
复制代码
```

但是数组改变的时候，不是直接使用 `addObject:` 方法，而是改成：

```Objc
// 添加
[[self.p1 mutableArrayValueForKey:@"cars"] addObject:@"wuling"];
// 移除
// [[self.p1 mutableArrayValueForKey:@"cars"] removeObject:@"wuling"];
复制代码
```

#### 一个观察者观察多个属性的变化

一个 `Person` 的 `name` 由 `firstName` 和 `lastName` 组成，所以当 `firstName` 和 `lastName` 改变的时候，我们都需要告诉监听者，`name` 发生了改变。

```Objc
@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end

// 在 Person 中加入以下类方法
+ (NSSet<NSString *> *)keyPathsForValuesAffectingName {
    NSSet *keyPaths = [NSSet setWithArray:@[@"firstName", @"lastName"]];
    return keyPaths;
}
复制代码
```

这样在 `firstName` 或者 `lastName` 发生改变时，就可以监听到属性变化。

#### 关闭自动触发

正常情况下，每次改变监听的值，都会触发通知，但是有些场景下并不需要每次都进行通知，此时可以通过重载方法来实现：

```Objc
@implementation Person

// 对所有的都关闭
//+ (BOOL)automaticallyNotifiesObserversOfAge {
//    return NO;
//}

// 关闭指定key的通知
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"name"]) {
        return NO;
    }
    return YES;
}

@end
复制代码
```

这样在 `name` 发生改变时，就不会触发 `observeValueForKeyPath:ofObject:change:context` 方法。

## 原理

假设有一个类 `Person`，为 `Person` 中的 `name` 属性添加观察者，那么 `runtime` 会为我们做以下事情：

1. 动态生成一个子类 `NSKVONotifying_Person`，并且让 `Person` 对象的 `isa` 指向这个全新的子类，这个子类的命名规则就是 `NSKVONotifying_XXX`。

2. 当修改对象的属性时，会在 `NSKVONotifying_Person` 中调用 `Foundation` 的 `_NSSetXXXValueAndNotify` 函数。

3. 在 

   ```
   _NSSetXXXValueAndNotify
   ```

    函数中依次调用：

   1. 调用 `willChangeValueForKey`
   2. 父类原来的 `setter`
   3. 调用 `didChangeValueForKey`，`didChangeValueForKey` 内部会触发监听器（`Observer`）的监听方法（`observeValueForKeyPath:ofObject:change:context:`）

简单来说就是生成了一个新的类，重载被监听的属性的 `setter` 方法，在重载的 `setter` 方法中，调用发送通知的方法，这些是被隐藏在 `runtime` 之中的。

## 实际运用

这个特性可以用来监听一些封装类的属性变化。 我们项目中有一个封装的性能检测类 `DMRecorder`，有个属性是 `@property (nonatomic, assign, readonly) NSInteger fps;`，并且没有暴露 `fps` 改变的回调方法，此时我们可以通过 KVO 的方法进行监听：

```Objc
[[DMRecorder shareInstance] addObserver:self forKeyPath:@"fps" options:NSKeyValueObservingOptionNew context:nil];
复制代码
```

还有一些常规的操作，比如模型的数据变化时，通知 UI 来进行刷新，就不列举了。

### 特点

KVO 是一种通信的机制，在 OC 中，有几种常规的通信方式，`delegate`、`block`、通知，还有 KVO。另外几种通信方式我们不提，就 KVO 来说，它是一个对象能观察另一个对象属性的值，这是一个对象与另外一个对象保持同步的一种方法，但它只能对属性做出反应。

优点：

1. 提供一个简单的方法来实现两个对象的同步
2. 能对非我们创建的对象做出反应
3. 能够提供观察的属性的最新值和先前值
4. 用 `keyPaths` 来观察属性，因此也可以观察嵌套对象

缺点：

1. 观察的属性必须使用 `string` 来定义，因此编译器不会出现警告和检查
2. 对属性的重构将导致观察不可用
3. 复杂的 `if` 语句，因为所有观察的对象都是通过一个方法来拿到通知，所以观察的对象多的话，`if` 语句会很复杂。



作者：_Terry
链接：https://juejin.cn/post/7152021659325562916
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。