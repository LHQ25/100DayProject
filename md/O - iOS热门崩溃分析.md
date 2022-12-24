## 前言

随着移动互联网的发展，各种App应用已经融入到我们的日常生活当中，应用的稳定性的要求也越来越高，首当其冲的就是应用的crash问题，轻则影响用户的良好体验，重则导致用户大量流失造成巨大的影响。所以解决crash是重要而紧急的事情。

2021年友盟+发布了移动应用性能体验报告，报告中指出App的整理崩溃率为0.29%，其中iOS端崩溃率为0.10%。以及热门崩溃排行榜：

![崩溃排行榜.webp](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1555482727404c53bb96368cef02dac8~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

本文将通过热门崩溃产生的原因以及崩溃demo（写bug）来了解这些崩溃是如何产生的。热门崩溃占比是很高的，如果能解决这些热门崩溃，移动应用的质量会有很大的提升。

## NSException

首先我们先来介绍一下NSException：

![NSException.webp](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b3c054e03a0d4a7a8623cf07961949a8~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

相信大家对这个页面不会陌生吧，这个日志就是NSException产生的，一旦程序抛出异常，程序就会崩溃，控制台就会输出这些崩溃日志。

NSException对象继承自NSObject，是专门用来抛出Objective-C异常的，有四个属性：

- name：异常名称
- reason：异常原因
- userInfo：异常信息，字典形式
- reserved：堆栈信息

```swift
@interface NSException : NSObject <NSCopying, NSSecureCoding> {
    @private
    NSString		*name;
    NSString		*reason;
    NSDictionary	*userInfo;
    id			reserved;
}
复制代码
```

当出现异常时，会抛出一个NSException对象，内容如上图所示。

![异常.webp](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/539a19ef0a6d4b7d83db5b599756c3df~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

除了上面的属性外，NSException还预定义了一些通用的异常名称：

```objectivec
/***************	Generic Exception names		***************/
/*
You should typically use a more specific exception name.
*/
FOUNDATION_EXPORT NSExceptionName const NSGenericException; 
/*
Name of an exception that occurs when attempting to access outside the bounds of some data, such as beyond the end of a string.
*/
FOUNDATION_EXPORT NSExceptionName const NSRangeException; 
/*
Name of an exception that occurs when you pass an invalid argument to a method, such as a nil pointer where a non-nil object is required.
*/
FOUNDATION_EXPORT NSExceptionName const NSInvalidArgumentException;
/*
Name of an exception that occurs when an internal assertion fails and implies an unexpected condition within the called code.
*/ 
FOUNDATION_EXPORT NSExceptionName const NSInternalInconsistencyException; 

/*
Obsolete; not currently used.
*/
FOUNDATION_EXPORT NSExceptionName const NSMallocException; 

/*
Name of an exception that occurs when a remote object is accessed from a thread that should not access it.
*/
FOUNDATION_EXPORT NSExceptionName const NSObjectInaccessibleException; 
/*
Name of an exception that occurs when the remote side of the NSConnection refused to send the message to the object because the object has never been vended.
*/
FOUNDATION_EXPORT NSExceptionName const NSObjectNotAvailableException; 
/*
Name of an exception that occurs when an internal assertion fails and implies an unexpected condition within the distributed objects.
*/
FOUNDATION_EXPORT NSExceptionName const NSDestinationInvalidException;
    
    /*
Name of an exception that occurs when a timeout set on a port expires during a send or receive operation.
*/
FOUNDATION_EXPORT NSExceptionName const NSPortTimeoutException;
/*
Name of an exception that occurs when the send port of an NSConnection has become invalid.
*/
FOUNDATION_EXPORT NSExceptionName const NSInvalidSendPortException;
/*
Name of an exception that occurs when the receive port of an NSConnection has become invalid.
*/
FOUNDATION_EXPORT NSExceptionName const NSInvalidReceivePortException;
/*
Generic error occurred on send.
*/
FOUNDATION_EXPORT NSExceptionName const NSPortSendException;
/*
Generic error occurred on receive.
*/
FOUNDATION_EXPORT NSExceptionName const NSPortReceiveException;


/*
No longer used.
*/
FOUNDATION_EXPORT NSExceptionName const NSOldStyleException;

/*
The name of an exception raised by NSArchiver if there are problems initializing or encoding.
*/
FOUNDATION_EXPORT NSExceptionName const NSInconsistentArchiveException;

/***************	Exception object	***************/
复制代码
```

但并不是所有的异常都在这里定义，如UIApplicationInvalidInterfaceOrientation这个异常就是定义在UIKit的UIApplication中的

```objectivec
UIKIT_EXTERN NSExceptionName const UIApplicationInvalidInterfaceOrientationException API_AVAILABLE(ios(6.0)) API_UNAVAILABLE(tvos);
复制代码
```

当然我们也可以使用自定义异常进行抛出。

```objectivec
NSString *nilStr = nil;
    NSMutableArray *arrayM = [NSMutableArray array];
    @try {
        //如果@try中的代码会导致程序崩溃，就会来到@catch
        
        //将一个nil插入到可变数组中，这行代码肯定有问题
        [arrayM addObject:nilStr];
    }
    @catch (NSException *exception) {
        //在这里你可以进行相应的处理操作
        //异常的名称
        NSString *exceptionName = @"异常的名称";
        //异常的原因
        NSString *exceptionReason = @"我异常的原因";
        //异常的信息
        NSDictionary *exceptionUserInfo = nil;

        NSException *exception1 = [NSException exceptionWithName:exceptionName reason:exceptionReason userInfo:exceptionUserInfo];

        //抛异常
        @throw exception1;
    }
    @finally {
        //@finally中的代码是一定会执行的
        
        //你可以在这里进行一些相应的操作
    }
复制代码
```

## 热门崩溃

下面我们看一下这些热门崩溃都是什么以及产生的原因

### 1，NSInvalidArgumentException

非法参数异常（NSInvalidArgumentException）是Objective-C代码最常出现的错误，所以平时写代码的时候，需要多加注意，加强对参数的检查，避免传入非法参数导致异常，其中尤以nil参数为甚。 (1)无法识别选择器

```ini
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    // 未实现buttonAction
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
复制代码
```

(2)数组中插入异常数据，传递nil

```ini
NSMutableArray *array = [NSMutableArray array];
[array addObject:nil];
复制代码
```

(3)NSString在使用stringWithString时，传递nil

```ini
NSString *str = [NSString stringWithString:nil];
复制代码
```

(4)参数类型传递错误

```ini
UITextField *textField = [[UITextField alloc] init];
    textField.background = [UIColor blueColor];
复制代码
```

### 2，NSGenericException

通用异常 (1)foreach操作 NSGenericException这个异常容易出现在foreach操作中，在for in循环中如果修改所遍历的数组，无论你是add或remove，都会出错

```ini
NSArray *array = @[@"111", @"222", @"333", @"444", @"555"];
    NSMutableArray *marray = [array mutableCopy];
    for (NSString *item in marray) {
//        [marray addObject:@"666"];
        if ([item isEqualToString:@"111"]) {
            [marray removeObject:item];
        }
    }
复制代码
```

解决办法：如果有add或remove操作请使用for循环。 (2)读取文件失败

### 3，NSRangeException

越界异常（NSRangeException）是iOS开发中比较常出现的异常 (1)容器越界

```ini
NSArray *arry = @[@"111", @"222", @"333"];
    NSString *str = arry[4];
复制代码
```

在使用tableview或者collectionview时数据源容器越界 (2)处理数据范围NSRange超过数据本身的长度

```ini
NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14],
                                 NSForegroundColorAttributeName:[UIColor colorWithRed:0.2 green:0.2 blue:0.188 alpha:1]
                                 };
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:@"123456" attributes:attributes];
    NSRange range = {1,8};
    [mutableAttributedString setAttributes:attributes range:range];
复制代码
```

解决办法：为了避免NSRangeException的发生，必须传入的下标参数或者NSRange范围进行合法性检查，判断是否在集合数据的范围内，然后再进行相关的处理 (3)KVO被移除多次

```objectivec
[self.titleLabel addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
    self.titleLabel.backgroundColor = [UIColor blueColor];
    //第一次remove
    [self.titleLabel removeObserver:self forKeyPath:@"backgroundColor"];
    //第二次remove
    [self.titleLabel removeObserver:self forKeyPath:@"backgroundColor"];
复制代码
```

### 4，NSMallocException

这是内存不足的问题，无法分配足够的内存空间，比如需要分配的内存大小是一个不正常的值，比较巨大或者设备的内存空间不足以及耗尽

(1)分配空间过大

```ini
NSMutableData *data = [[NSMutableData alloc] initWithCapacity:1];
NSInteger len = 203293514200000000;
[data increaseLengthBy:len];
复制代码
```

(2)图像占用空间过大

```css
-[SDImageCache storeImage:recalculateFromImage:imageData:forKey:toDisk:]
复制代码
```

如果imageData长度过长，就会出现NSMallocException (3)OOM问题

```vbnet
Terminating app due to uncaught exception 'NSMallocException', reason: 'Out of memory. We suggest restarting the application. If you have an unsaved document, create a backup copy in Finder, then try to save
复制代码
```

这种情况一般是程序陷入死循环，注意检查代码 解决办法：对于程序中分配内存空间的操作，需要检查参数（空间大小）的有效性，特别是这个参数来自其他模块的返回值，更应该注意。

### 5，NSInternalInconsistencyException

内部不一致异常（NSInternalInconsistencyException）

(1)NSMutableDictionary的错误使用：比如把NSDictionary当做NSMutableDictionary来使用，从他们内部机理来说，就会产生一些错误，NSMutableDictionary中有很多NSDictionary不支持的接口。

(2)界面使用不当：如在子线程刷新UI

```scss
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ self.tableView.frame = CGRectMake(0, 0, 10, 0); });
复制代码
```

解决办法：通过runtime的方法替换,替换UIView 的 setNeedsLayout， layoutIfNeeded，layoutSubviews， setNeedsUpdateConstraints。方法，判断当前线程是否为主线程，如果不是，在主线程执行。

(3)tableview里再cellForRowAtIndexPath方法中，返回的内容不是UITableViewCell类型，比如返回了nil

```objectivec
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { return nil; }
复制代码
```

(4)KVO的observer没有实现observeValueForKeyPath方法

```objectivec
[self.titleLabel addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil]; self.titleLabel.backgroundColor = [UIColor blueColor]; // 未实现observeValueForKeyPath
复制代码
```

### 6，UIApplicationInvalidInterfaceOrientation

应用程序无效界面定向异常

(1)ViewController中设置的方位跟应用支持的方位不一致：应用只支持竖屏，VC却支持横屏

苹果目前已经对这种情况做了兼容，如果应用只支持竖屏，而VC支持横屏的情况只会横屏无效果，并不会crash了。

### 7，CALayerInvalidGeometry

CALayer无效坐标异常

(1)rect里面包含非数字

```objectivec
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; button.frame = CGRectMake(100, 100, 100, NAN);
复制代码
```

(2)rect中在计算时分母为0

苹果目前已经对这种情况做了兼容，如果分母为0则会报一个警告，并且该值当做0来处理

![坐标异常.webp](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c406fc9aadb5468caf29d7761d442b8d~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

### 8，NSFilehandleOperationException

手机空间不足，会使客户端直接崩溃，触发NSFilehandleOperationException，所以在处理文件时，比如应用频繁的保存文档，缓存资料或者处理比较大的数据，需要考虑空间的问题

(1)没有空间：手机没有存储空间了，或者需要写的文件太大，会触发“No space left on device”异常

(2)文件读写权限：明明是要写文件，可只给了读权限，所以触发了“Bad file descriptor”异常

(3)读文件失败： - readDataOfLength:

(4)获取文件数据失败

解决办法：在处理文件I/O时，需要考虑到存储空间的有限性，对大小参数进行有效性校验；另外对NSFileHandle的有效性也要判断。

### 9，NSUnknownKeyException

未知key异常

(1)不符合键值编码

(2)kvc使用了不存在的key

```csharp
[self.parentVC setValue:@"123" forKey:@"abc"];
复制代码
```

### 10，NSArchiverArchiveInconsistency

存档不一致异常

## 总结

这些热门崩溃是占比较大的崩溃，可以针对这些常见的、热门的崩溃进行防护，然后再辅助crash上报以及日志等功能来保证App应用的稳定性。

当然除了这些热门崩溃还会有很多偶现的、不好定位的崩溃，需要花更多的精力来解决。



作者：好_好先生
链接：https://juejin.cn/post/7169555530783358984
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。