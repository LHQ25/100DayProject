## GCD 是什么？

GCD，全称 Grand Central Dispatch，是异步执行任务的技术之一。一般将应用程序中记述的线程管理用的代码在系统级中实现。开发者只需要定义想执行的任务并追加到适当的 `Dispatch Queue` 中，GCD 就能生成必要的线程并计划执行任务。由于线程管理是作为系统的一部分来实现的，因此可统一管理，也可执行任务，这样就比以前的线程更有效率。

也就是，GCD 使用了很简洁的方式，实现了极为复杂的多线程编程。

## 为什么要使用 GCD？

是因为之前用于多线程的方式太繁琐，写法不够简洁。

看一下在 GCD 之前的处理多线程的代码：

```objc
- (void)begin {
    // 发起任务执行
    [self performSelectorInBackground:@selector(asyncWork) withObject:nil];
}

- (void)asyncWork {
    // 耗时任务...

    // 执行完成后调用主线程处理结果
    [self performSelectorOnMainThread:@selector(asyncWorkDone) withObject:nil waitUntilDone:NO];
}

- (void)asyncWorkDone {
    // 只有在主线程可以执行的处理
    // 比如界面刷新
}
复制代码
```

而使用 GCD 只需要：

```objc
dispatch_async(queue, ^{
    // 耗时任务...
        
    dispatch_async(dispatch_get_main_queue(), ^{
        // 只有主线程才能执行的任务，如 UI 刷新
    });
});
复制代码
```

结果一目了然。

## GCD 的 API

会提到的 API 有：

- Dispatch Queue
- dispatch_queue_create
- Main Dispatch Queue / Global Dispatch Queue
- dispatch_set_target_queue
- dispatch_after
- Dispatch Group
- dispatch_barrier_async
- dispatch_sync
- dispatch_apply
- dispatch_suspend / dispatch resume
- Dispatch Semaphore
- dispatch_once
- Dispatch I/O

### Dispatch Queue

> 开发者要做的只是定义想执行的任务并追加到适当的 Dispatch Queue 中。

`Dispatch Queue`，就是执行处理的等待队列。这个队列按照先进先出的规则执行被追加到队列中的任务，就跟排队一样。

`Dispatch Queue` 分两种：

- `Serial Dispatch Queue`：串行队列，需要等待当前执行处理结束
- `Concurrent Dispatch Queue`：并行队列，不需要等待当前执行处理结束

啥意思呢？

举个栗子，某公司的厕所，只有一个坑位，有 A、B、C 三位同事想摸鱼，A 先进厕所，然后 B，然后 C，只能依次排队，这是串行队列。

```objc
dispatch_async(wc_serial, A);
dispatch_async(wc_serial, B);
dispatch_async(wc_serial, C);
复制代码
```

因为串行队列能同时执行的执行数，也就是厕所的坑位只有 1 个，所以一定按照以下顺序执行：

```objc
A
B
C
复制代码
```

另外一家公司的厕所，有三个坑位，这家公司也有 A、B、C 三位同事，A、B、C 还是按顺序进入了厕所，但是因为有三个坑位，所以他们可以同时开始摸鱼，B 不需要等 A 摸鱼结束，C 也不需要等 B 摸鱼结束。这是并行队列。

```objc
dispatch_async(wc_concurrent, A);
dispatch_async(wc_concurrent, B);
dispatch_async(wc_concurrent, C);
复制代码
```

并行队列时，不需要等待当前执行结束，A、B、C 还是依次添加进任务的，首先执行 A，但是 B 并不需要等 A 结束，所以执行 A 后，也开始执行 B，C 也是同理。

并行处理的处理数量取决于当前系统的状态，即 iOS 和 OS X 基于 `Dispatch Queue` 中的处理数、CPU 核数以及 CPU 负荷等当前系统的状态来决定并行执行的处理数。所谓 "并行执行"，就是使用多个线程同时执行多个处理。

### 如何得到 Dispatch Queue

有两种方式：

- `dispatch_queue_create`：自己创建一个
- `Main Dispatch Queue` 和 `Global Dispatch Queue`：获取系统为我们提供的。

#### dispatch_queue_create

```objc
// 创建一个串行队列
dispatch_queue_t mySerialQueue =
        dispatch_queue_create("com.example.mySerialDispatchQueue", NULL);
复制代码
```

需要注意的是，虽然串行和并行队列受到系统资源的限制，但用 `dispatch_queue_create` 函数是可以生成任意多个队列的，当生成多个串行队列时，各个串行队列将并行执行。

虽然在一个串行队列中只能同时处理一个任务，但是如果将任务分别加到 4 个串行队列中，每个串行队列都执行一个，即为同时处理 4 个任务。

可以生成任意多个串行队列意思是，你想生成几个就生成几个，比如生成 2000 个队列，也行，那就会生成 2000 个线程，但是，过多使用多线程，会消耗大量内存，引起大量的上下文切换，大幅度降低系统的响应性能。

所以在使用串行队列的时候，一定要注意数量，不要大量的创建串行队列，而且一般只在多个线程更新相同资源导致数据竞争的这种情况下使用串行队列。

对于并行队列来说，就没有这个担忧，不管你生成多少个，系统都会帮你管理，只使用有效管理的线程，不会发生串行队列的那种问题。

```objc
// 创建并行队列
dispatch_queue_t myConcurrentQueue =
        dispatch_queue_create("com.example.myConcurrentDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
复制代码
```

#### Main Dispatch Queue / Global Dispatch Queue

这两个 Queue 是系统为我们提供的。

`Main Dispatch Queue` 就是在主线程中执行的 `Dispatch Queue`，它是串行的。

追加到 `Main Dispatch Queue` 的处理会在主线程的 RunLoop 中执行.

另一个 `Global Dispatch Queue` 是一个全局的并行队列，它有四个优先级：

- High Priority（高）
- Default Priority（默认）
- Low Priority（低）
- Background Priority（后台）

不过这些优先级只是一个大致的判断，并不能保证实时性。

```objc
// main dispatch queue
dispatch_queue_t mainQueue =
    dispatch_get_main_queue();

// high global dispatch queue
dispatch_queue_t globalQueueHigh =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

// default global dispatch queue
dispatch_queue_t globalQueueDefault =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

// low global dispatch queue
dispatch_queue_t globalQueueLow =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);

// background global dispatch queue
dispatch_queue_t globalQueueBackground =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
复制代码
```

一个很常见的操作是：

```objc
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 异步执行耗时任务

    // 回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
       // 刷新 UI
    });
});
复制代码
```

### dispatch_set_target_queue

这是用于指定队列的优先级的，通过 `dispatch_queue_create` 创建的不管是串行队列还是并行队列，都是使用的优先级，如果要变更优先级，就需要使用 `dispatch_set_target_queue`。

```objc
dispatch_queue_t mySerialQueue =
    dispatch_queue_create("com.example.mySerialDispatchQueue", NULL);

dispatch_queue_t globalQueueBackground =
     dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0); 
     
dispatch_set_target_queue(mySerialQueue, globalQueueBackground);
复制代码
```

### dispatch_after

用于延迟执行一些任务。

```objc
// DISPATCH_TIME_NOW 指现在的时间，`3 * NSEC_PER_SEC`，意思是距离现在时间 3 秒后。
dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);

dispatch_after(time, dispatch_get_main_queue(), ^{
    NSLog(@"waited at least three seconds.");
});
复制代码
```

不过，这里并不是在指定时间后就开始处理，而是在指定时间后将任务追加到 `Dispatch Queue` 之中。

比如上述代码意思是 3 秒后将 `NSLog` 追加到主队列中，因为主队列是在主线程的 RunLoop 中执行的，所以在比如每隔 1/60 秒执行的 RunLoop 中，任务最快在 3 秒后执行，最慢在 3 秒 + 1/60 秒后执行，并且如果主队列有大量追加任务或主线程的处理本身有延迟时，这个时间会更长。

### Dispatch Group

这是用来处理我们想要在多个队列中的任务全部执行完成后，再做一个结束的处理。一般是用于并行队列，因为串行队列的话，只需要将这些任务加入串行队列，然后在队列的最后追加我们要处理的任务即可。

但是并行队列处理起这种情况就比较麻烦，所以 GCD 提供了 `Dispatch Group` 来处理这种情况。

举个栗子：

```objc
dispatch_queue_t queue = 
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();

dispatch_group_async(group, queue, ^{NSLog(@"task0");});
dispatch_group_async(group, queue, ^{NSLog(@"task1");});
dispatch_group_async(group, queue, ^{NSLog(@"task2");});

dispatch_group_notify(group, dispatch_get_main_queue(), ^{NSLog(@"done");});
复制代码
```

`task0`、`task1`、`task2` 谁先输出是不确定的，但是 `done` 一定是在它们都输出完之后才会输出。

不管 `queue` 是不是同一个，只要你是同一个 `group`，不管你使用的 `queue` 是串行的还是并行的，一个还是多个，都可以保证在这些队列中的任务都执行完成，然后才会触发 `dispatch_group_notify` 的回调。

比如：

```objc
// 并行队列
dispatch_queue_t queue = 
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
// 串行队列
dispatch_queue_t serialQueue = dispatch_queue_create("com.example.mySerialQueue", NULL);
dispatch_group_t group = dispatch_group_create();

dispatch_group_async(group, queue, ^{NSLog(@"task0");});
dispatch_group_async(group, serialQueue, ^{NSLog(@"task1");});
dispatch_group_async(group, queue, ^{NSLog(@"task2");});

dispatch_group_notify(group, dispatch_get_main_queue(), ^{NSLog(@"done");});
复制代码
```

`done` 都会是在最后输出的。

`dispatch_group_notify` 需要传入三个参数，第一个参数是要监听的 `Dispatch Group`，第二个参数需要传入一个队列，第三个参数是要执行的任务，在所监听的 `Dispatch Group` 中的全部任务处理结束后，将第三个参数所需要执行的任务，添加到第二个参数所指定的队列之中。

除了使用 `dispatch_group_notify`，还可以使用 `dispatch_group_wait` 来仅等待全部处理执行结束：

```objc
dispatch_queue_t queue = 
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();

dispatch_group_async(group, queue, ^{NSLog(@"task0");});
dispatch_group_async(group, queue, ^{NSLog(@"task1");});
dispatch_group_async(group, queue, ^{NSLog(@"task2");});

dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
复制代码
```

`DISPATCH_TIME_FOREVER` 意味着永久等待，只要 `group` 的处理还没结束，就会一直等待。

`dispatch_group_wait` 是有返回值的，如果返回值为 0，说明 `group` 中的处理已经全部结束，如果不为 0，说明 `group` 还有某个任务正在执行中。当传入的时间是 `DISPATCH_TIME_FOREVER` 时，返回值一定是 0，因为它会一直等待。如果传入的不是永久，而是其他的时间，比如：

```objc
dispatch_queue_t queue = 
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();

dispatch_group_async(group, queue, ^{NSLog(@"task0");});
dispatch_group_async(group, queue, ^{NSLog(@"task1");});
dispatch_group_async(group, queue, ^{NSLog(@"task2");});

dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
long result = dispatch_group_wait(group, time);

if (result == 0) {
    NSLog(@"all done");
} else {
    NSLog(@"working");
}
复制代码
```

上述代码的意思是，等待 1 秒后，判断当前 `group` 中的任务是否已经全部执行完毕，执行完毕输出 `all done`，否则输出 `working`。

等待的意思是，在经过 `dispatch_group_wait` 中指定的时间或 `Dispatch Group` 的处理全部执行结束之前，执行该函数的线程暂停。

### dispatch_barrier_async

在访问数据库或文件时，使用串行队列可以避免数据竞争的问题。但是访问数据库或文件，其实有两种操作，一个是写，一个是读，如果是读的话，那么使用并行执行是不会有问题的，因为它不会修改到数据源，只有写的时候，才需要确保只有一个人在写。

GCD 为我们提供 `dispatch_barrier_async` 函数来处理这种情况。

```objc
dispatch_queue_t queue = 
    dispatch_queue_create("com.example.gcd.ForBarrier", DISPATCH_QUEUE_CONCURRENT);

dispatch_async(queue, task0_for_reading);
dispatch_async(queue, task1_for_reading);
dispatch_barrier_async(queue, task_for_writing);
dispatch_async(queue, task2_for_reading);
dispatch_async(queue, task3_for_reading);
复制代码
```

`dispatch_barrier_async` 函数会等待追加到并行队列上的并行执行处理全部结束后，再将指定的处理追加到该并行队列中，然后在由 `dispatch_barrier_async` 函数追加的处理执行完毕后，并行队列才恢复为一般的动作，追加到该并行队列的处理又开始并行执行。

![dispatch_barrier_async.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/29c0f39961034293ad0e44b51548a9dd~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

### dispatch_sync

一个经典的题目：在主线程执行下面的代码会有什么问题？

```objc
dispatch_queue_t queue = dispatch_get_main_queue();
dispatch_sync(queue, ^{NSLog(@"Hello?");});
复制代码
```

（一般我题都不用看全就说它死锁了。）

`sync` 意味着同步，`dispatch_sync` 是将指定的任务 "同步" 追加到指定的 `Dispatch Queue` 中，在追加任务结束之前，`dispatch_sync` 函数会一直等待。

之前在说 `dispatch_group_wait` 函数的时候说到过，等待意味着当前线程停止。

死锁就是相互等待，`dispatch_sync` 在等待主队列的任务执行完毕，而主队列正在执行 `dispatch_sync` 这段代码，它需要等到 `dispatch_sync` 中的内容处理完毕才能结束。这样互相等待，是没有结果的（突然有点伤心？）。

主队列是一个串行队列，其实只要在串行队列去执行一个 `sync` 的操作，就会导致死锁。

`dispatch_barrier_async` 函数相应的也有 `dispatch_barrier_sync`，大家在使用 `sync` 之类的函数时一定要小心，稍有不慎就会导致死锁。

### dispatch_apply

`dispatch_apply` 函数是 `dispatch_sync` 函数和 Dispatch Group 的关联 API。该函数按指定的次数将指定的 Block 追加到指定的 Dispatch Queue 中，并等待全部处理执行结束。

```objc
dispatch_queue_t queue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

dispatch_apply(10, queue, ^(size_t index) {
    NSLog(@"%zu", index);
});
NSLog(@"done");
复制代码
```

`index` 的打印是不固定的，因为是在并行队列中执行的，但是 `done` 肯定是最后打印的。因为 `dispatch_apply` 会等待全部处理执行结束。

Block 带了一个参数，表示当前执行任务的下标。

这个可以用来对 `NSArray` 类对象的所有元素执行处理，比如：

```objc
dispatch_queue_t queue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_apply([array count], queue, ^(size_t index) {
    NSLog(@"%zu: %@", index, [array objectAtIndex: index]);
});
复制代码
```

这样就可以简单的在队列中对所有的元素执行 Block。

因为 `dispatch_apply` 和 `dispatch_sync` 函数一样会等待处理执行结束，所以推荐在 `dispatch_async` 函数中非同步的执行 `dispatch_apply` 函数。

```objc
dispatch_queue_t queue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

dispatch_async(queue, ^{
    dispatch_apply([array count], queue, ^(size_t index) {
        NSLog(@"%zu: %@", index, [array objectAtIndex: index]);
    });

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"done");
    });
});
复制代码
```

### dispatch_suspend / dispatch resume

`suspend` 用于挂起队列，`resume` 用于恢复。

挂起队列，队列中尚未被执行的处理会被暂停，而恢复后则继续执行。

```objc
dispatch_suspend(queue);

dispatch_resume(queue);
复制代码
```

### Dispatch Semaphore

这是和信号量有关的，是用于多线程同步的一个东西，它会让你指定一个数，比如指定了 2，意思就是同时只能有两个并行执行的处理，假设有个厕所，你指定了坑位是 2，有 10 个人想蹲坑，但是由于坑位是 2，所以只能同时蹲两个人，两个坑都蹲了人的话，坑位是 0，但坑位是 0 时，不允许进人。一个人蹲完之后，坑位 +1，当坑位不为 0 时，可以再进人。直到所有的人都蹲完（老是举这种例子好像有点不雅）。

所以信号量就是这么个东西，它让你给个数，来一个执行，这个数减 1，减到 0 时，不能再来执行了，得候着。处理完一个执行，数 + 1，但这个数不为 0 时，就可以再进一个新的执行。它可以用来控制同时在执行的执行数。

理解了概念之后，我们来看 GCD 中的信号量如何使用：

```objc
// 容易出错的情况
dispatch_queue_t queue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
NSMutableArray *array = [[NSMutableArray alloc] init];

for (int i = 0; i < 100000; i++) {
    dispatch_async(queue, ^{
        [array addObject:@(i)];
    });
}
复制代码
```

这是不加管理的情况，一个厕所 100000 个人等着蹲，只有一个坑，还没人管，万一两个人同时来了，不好吧。

这个时候就可以用一下信号量：

```objc
dispatch_queue_t queue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

// 指定信号量为 1
dispatch_semaphore_t semphore = dispatch_semaphore_create(1);

NSMutableArray *array = [[NSMutableArray alloc] init];
for (int i = 0; i < 100000; i++) {
    dispatch_async(queue, ^{
        // 信号量 -1，因为指定的是 1，1-1=0，所以进入一个执行后，后续的执行需要等待
        dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
        // 执行
        [array addObject:@(i)];
        // 信号量 +1，0+1=1，不为0，后续的执行又可以进入
        dispatch_semaphore_signal(semphore);
    });
}
复制代码
```

在没有 `Serial Dispatch Queue` 和 `dispatch_barrier_async` 函数那么大粒度且一部分处理需要进行排他控制的情况下，`Dispatch Semaphore` 便可发挥威力。

### dispatch_once

`dispatch_once` 很常用，`once` 就是只执行一次，它保障在应用程序执行中只执行一次指定处理的 API，写单例和使用 `Method Swizzling` 的时候都会用。

通过 `dispatch_once` 函数，即使在多线程的环境下执行，也可以保证百分百的安全。

### Dispatch I/O

在读取较大文件时，如果将文件分成合适的大小并使用 Global Dispatch Queue 并列读取的话，会比一般的读取速度快不少。现在的输入 / 输出硬件已经可以做到一次使用多个线程更快的并列读取了。能实现这一功能的就是 Dispatch I/O 和 Dispatch Data。

```objc
dispatch_async (queue, ^{// 读取 0 ~ 8191 字节});
dispatch_async (queue, ^{// 读取 8192 ~ 16383 字节});
dispatch_async (queue, ^{// 读取 16384 ~ 24575 字节});
...
复制代码
```

## GCD 的实现

我们可以自己实现多线程，但是性能不会有 GCD 的好，苹果的官方说明是：

> 通常，应用程序中编写的线程管理用的代码要在系统级实现。

也就是说，GCD 是在系统级，也就是 iOS 和 OS X 的核心 XNU 内核级上实现的，无论我们如何努力的编写管理线程的代码，性能上也不会超过在内核级上实现的 GCD。

所以我们应该尽量使用 GCD 或者封装了 GCD 的 Cocoa 框架中的 `NSOperationQueue` 类的 API。

这是 GCD 相关的 [源码](https://link.juejin.cn?target=https%3A%2F%2Fopensource.apple.com%2Fsource%2Flibdispatch%2F)，都放在 `libdispatch` 库中，是用 C 语言写的。

`Dispatch Queue` 通过结构体和链表，被实现为 FIFO（先进先出）队列。FIFO 队列管理着通过 `dispatch_async` 等函数所追加的 `Block`（要执行的任务）。

`Block` 并不是直接加入到 FIFO 队列中，而是先加入 `Dispatch Continuation` 这一 `dispatch_continuation_t` 类型结构体中，然后再加入 FIFO 队列。这个 `Dispatch Continuation` 会记录 `Block` 所属的 `Dispatch Group` 和一些其他的信息，相当于一般常说的执行上下文。

![dispatch_continuation_t.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0e63602fca1c4e23b364d7842df970ed~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

也就是包了一层，添加了一些必要的信息，再加入到队列中，这种操作很常见。

`Dispatch Queue` 可通过 `dispatch_set_target_queue` 函数设定，可以设定执行该 `Dispatch Queue` 处理的 `Dispatch Queue` 为目标。该目标可像串珠子一样，设定多个连接在一起的 `Dispatch Queue`，但是在连接串的最后必须设定为 `Main Dispatch Queue`，或各种优先级的 `Global Dispatch Queue`，或是准备用于 `Serial Dispatch Queue` 的各种优先级的 `Global Dispatch Queue`。

`Global Dispatch Queue` 有如下 8 种：

- Global Dispatch Queue（High Priority）
- Global Dispatch Queue（Default Priority）
- Global Dispatch Queue（Low Priority）
- Global Dispatch Queue（Background Priority）
- Global Dispatch Queue（High Overcommit Priority）
- Global Dispatch Queue（Default Overcommit Priority）
- Global Dispatch Queue（Low Overcommit Priority）
- Global Dispatch Queue（Background Overcommit Priority）

`Global Dispatch Queue` 有两块，一共八种，一块是不带 `Overcommit` 的，一块是 `Overcommit` 的。

区别我们等下说。

这 8 种 `Global Dispatch Queue` 各使用 1 个 `pthread_workqueue`。GCD 初始化时，使用 `pthread_workqueue_create_up` 函数生成 `pthread_workqueue`。

`pthread_workqueue` 包含在 Libc 提供的 `pthreads` API 中。其使用 `bsdthread_register` 和 `workq_open` 系统调用，在初始化 XNU 内核的 `workqueue` 之后获取 `workqueue` 信息。

XNU 内核持有 4 种 `workqueue`。

- WORKQUEUE_HIGH_PRIOQUEUE
- WORKQUEUE_DEFAULT_PRIOQUEUE
- WORKQUEUE_LOW_PRIOQUEUE
- WORKQUEUE_BG_PRIOQUEUE

该执行优先级与 `Global Dispatch Queue` 的 4 种执行优先级相同。

它们的结构如下图：

![pthread_workqueue.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e2351d37d44a441b8f0ac81b8ca07a38~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

带 `Overcommit` 的 `Global Dispatch Queue` 是使用在 `Serial Dispatch Queue` （串行队列）中的，不带的是用于 `Concurrent Dispatch Queue` （并行队列）的。

我们前面说过，使用 `dispatch_queue_create` 创建串行队列时，一定会产生一个新的线程，也就是带 `Overcommit` 优先级的 `Queue`，XNU 内核一定会给你搞个新的线程出来。但是并行队列的线程数，是受 XNU 内核控制的，它会根据系统状态那些，合理的使用线程数。

当在 `Global Dispatch Queue` 中执行 `Block` 时，`libdispatch` 从 `Global Dispatch Queue` 自身的 FIFO 队列中取出 `Dispatch Continuation`，然后调用 `pthread_workqueue_additem_np` 函数（这个函数我在新版的源代码中已经搜不到了，可能换了名字，反正是一个添加的函数），将该 `Global Dispatch Queue` 自身，符合其优先级的 `workqueue` 信息以及为执行 `Dispatch Continuation` 的回调函数等传递给参数。

`pthread_workqueue_additem_up` 函数使用 `workq_kernreturn` 系统调用，通知 `workqueue` 增加应当执行的项目。根据该通知，XNU 内核基于系统状态判断是否要生成线程。当然，带 `Overcommit` 优先级的 `Global Dispatch Queue`，`workqueue` 是肯定会给你生成线程的。

`workqueue` 的线程执行 `pthread_workqueue` 函数，该函数调用 `libdispatch` 的回调函数，在该回调函数中执行加入到 `Dispatch Continuation` 的 `Block`。

`Block` 执行结束后，进行通知 `Dispatch Group` 结束，释放 `Dispatch Continuation` 等处理，开始准备执行加入到 `Global Dispatch Queue` 中的下一个 `Block`。

大概画了下流程：

![dispatch_queue_work.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/60d62e837484490e84a43c0514acd67c~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

由于 XNU 内核的加入，在编程人员自己管理的线程中，想发挥出 GCD 的性能是不可能的。

## 总结

最近重温了[《Objective-C高级编程 iOS与OS X多线程和内存管理》](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FkopuCoder%2FiOS_Development-Book%2Fblob%2Fmaster%2FObjective-C%E9%AB%98%E7%BA%A7%E7%BC%96%E7%A8%8B%20iOS%E4%B8%8EOS%20X%E5%A4%9A%E7%BA%BF%E7%A8%8B%E5%92%8C%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86.pdf)（网上找的一个下载的链接），这是其中 GCD 的章节，结合自己的理解，就出现了这篇文章，经典好书，推荐大家去读。



作者：_Terry
链接：https://juejin.cn/post/7168884409104334885
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。