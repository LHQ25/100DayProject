Crash的主要原因是你的应用收到了未处理的信号。 未处理的信号可能来源于三个地方：kernel（系统内核）、其他进程、以及App本身。 因此，crash异常也分为三种：

- Mach异常：是指底层的内核级异常。用户态的开发者可以直接通过Mach API设置Thread、task、host的异常端口，来捕获Mach异常。
- Unix信号：又称BSD信号，如果开发者没有捕获Mach异常，则会被host层的方法ux_exception()将异常转换为对应的UNIX信号，并通过方法threadsignal()将信号投递到出错的线程。可以通过方法singnal(x, SignalHandler)来捕获single。
- NSException：应用级异常，它是未被捕获的Objective-C异常，导致程序向自身发送了SIGABRT信号而崩溃，对于未捕获的Objective-C异常，是可以通过try catch来捕获的，或者通过NSSetUncaughtExceptionHandler()机制来捕获。

# 异常

##### Exception Type：

异常的type固定是SIGABRT，其实是CrashReporter在捕获Exception之后，再调用abort()发出的信号类型。这个机制也决定了如果是Exception Crash，堆栈就看这里的Last Exception Backtrace:, Crash Thread 里面固定是handleException的堆栈，没有查看的意义。

##### Exception Codes：

一般就是 0 at 0x18ac2378，后面这个地址就是发生异常的对象的地址

##### 特殊的 Exception Code

- 0xdead10cc - Deaklock

我们在挂起之前持有文件锁或 SQLite 数据库锁。我们应该在挂起之前释放锁

- 0xbaaaaaad - Bad

通过侧面和两个音量按钮对整个系统进行了 stackshot。

- 0xbad22222 - Bad too (two) many times

可能是 VOIP 应用被频繁唤起导致的崩溃。也可以注意一下我们的后台调用网络的代码。 如果我们的TCP连接被唤醒太多次（例如 300 秒内唤醒 15 次），就会导致此崩溃。

- 0x8badf00d - Ate (eight) bad food

我们的应用程序执行状态更改（启动、关闭、处理系统消息等）花费了太长时间。与看门狗的时间策略发生冲突（超时）并导致终止。最常见的罪魁祸首是在主线程上进行同步的网络连接。

- 0xc00010ff - Cool Off

系统检测的设备发烫而终止了我们的 App。如果只在少量设备上（几个）发生，那就可能是由于硬件的问题，而不是我们 App 问题。但是如果发生在其他设备上，我们应该使用 Instruments 去检查我们 App 的耗电量问题。

- 0x2bad45ec - Too bad for security

发生安全冲突。 如果 Termination Description 显示为 Process detected doing insecure drawing while in secure mode，则意味着我们的应用尝试在不允许的情况下进行绘制，例如在锁定屏幕的情况下。

##### Triggered by Thread：

发生Crash的线程

##### Application Specific Infomation：

Exception的信息，这个是定位异常的关键信息

##### Last Exception Backtrace：

抛出异常的代码堆栈，如果是异常，就看这个堆栈

# 主要信号

主要信号有 SIGTERM、SIGABRT、SIGSEGV、SIGBUS、SIGILL、SIGFPT、SIGKILL、SIGTRAP

### SIGTERM

程序结束（terminate）信号，与SIGKILL不同的是该信号可以被阻塞和处理。通常用来要求程序自己正常退出。iOS中一般不会处理到这个信号

### SIGABRT

##### 原因

- double free指针，void *ptr = malloc(256); free(ptr);free(ptr);// 重复释放会导致SIGABRT错误
- free没有初始化的地址或者错误的地址，void *ptr - (void*)0x0000100; free(ptr);//释放未初始化的地址导致SIGABRT错误
- 内存越界，char str2[10]; char *str1 = "askldfjadslfjsalkjfsalkfdj"; strcpy(str2, str1);
- 直接调用abort()
- 直接调用assert()

#### 场景

全局变量赋值的代码段，被多线程调用同时赋值，上一次赋的值就可能被多个线程释放

##### 解决方案

删掉类似的赋值操作或者加锁

### SIGSEGV

##### 原因:

- invalid memory access（segmentation fault）
- 无效的内存地址引用信号（常见的野指针访问，访问了没有权限的内存地址，系统内存地址等）
- 非ARC模式下，iOS中经常会出现在Delegate对象野指针访问
- ARC模式下，iOS经常会出现在Block代码块内强持有可能释放的对象

##### 场景:

SDWebImageDownloaderOperation 生命周期的管理和错误回调是在2个queue, 有可能 self  	已经进入释放逻辑，再访问 self.completeBlock, 再访问就是无效的。

##### 原因:

多线程访问或者操作对象、栈溢出。

### SIBBUS

##### 原因:

- mmap 内存映射访问超出了⼤⼩

```ini
char *p, tmp;
NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
int fd = open(path.UTF8String, O_RDWR);
p = (char*)mmap(NULL,FILESIZE, PROT_READ|PROT_WRITE,MAP_SHARED, fd, 0); signal(SIGBUS, handle_sigbus);
getchar();
for(int i=0;i<FILESIZE;i++){
	tmp = p[i];
}
printf("ok\n");
复制代码
```

- 访问未对⻬的内存地址, int *pi = (int*)(0x00001111); *pi = 17;

##### 场景:

mmap 映射了⼀个⽂件的内存，写入时越界。

##### 对比:

SIGSGV 访问的是⽆效的内存，就是该内存不属于我们的进程，或者没有权限，SIGBUS指的是 CPU ⽆法操作该地址，⼤部分是没有对⻬导致的。

### SIGILL

##### 原因:

- 执⾏⾮法指令
- 堆栈溢出

##### 典型场景:

iOS 上该问题有可能会随机产⽣在任何动态库、静态库的⽅法中，⼀旦出现之后，应⽤会⼀直崩溃

##### 解决方案:

app级别的代码没有修改可执⾏段的权限，⽆法污染代码段，判断是苹果增量的问题，用户重启⼿机

#### 定义:

程序结束接收中⽌信号，⼀般exit()会发⽣这个信号，当前应用不能捕获，也无法忽略，OOM，Watchdog最终都是这个异常信号。

##### 原因：

- ⻓时间占⽤太多 CPU 资源，被系统杀掉
- 应⽤启动的时候，在主线程做⻓时间操作，或者卡死，导致被 watchdog 杀死
- 线程切换过于频繁，被系统杀掉
- 应⽤占⽤过多内存，被 jetsam 杀掉

### SIGTRAP

##### 原因:

很多系统库例如 WebKit，libdispatch 等使⽤了__builtin_trap() ⽅法去触发断点异常，在debug 模式下，会触发调试器断点，这样开发可以实时查看问题，在 release 模式下，应⽤就会崩溃，然后产⽣ SIGTRAP 信号。

##### 典型场景:

dispatch_group_enter 和 dispatch_group_leave 调⽤不匹配，如果dispatch_group_leave 多调⽤了，会触发 DISPATCH_CLIENT_CRASH，在DISPATCH_CLIENT_CRASH 内部会调⽤__builtin_trap() 触发调式陷阱 。

# Mach 异常

Mach异常的好处就是可以捕获更多的Crash，⽐如循环递归导致的堆栈溢出crash。原本信号的⽅式回调会在崩溃的线程⾥⾯，但是因为循环递归已经堆栈溢出了，已经没有环境来执⾏crash捕获的逻辑了，但是Mach异常捕获可以定义单独的线程来处理Mach异常逻辑。 如何区分我们看到的⽇志是Mach异常的呢？ Exception Type: 是EXC_打头的话，就是Mach异常了，后⾯的Exception Subtype:其实是根据Exception Type:转了⼀下

##### Exception Type:

- EXC_BAD_ACCESS：内存不能访问,对应SIGBUS和SIGSEGV
- EXC_BAD_INSTRUCTION：⾮法的指令，对应捕获到的SIGILL问题
- EXC_ARITHMETIC：算术运算出错，对应SIGFPE
- EXC_EMULATION：对应SIGEMT
- EXC_SOFTWARE：软件出错，对应SIGSYS，SIGPIPE，SIGABRT，SIGKILL
- EXC_BREAKPOINT：对应SIGTRAP
- EXC_SYSCALL：不常⽤
- EXC_MACH_SYSCALL：不常⽤
- EXC_RPC_ALERT：不常⽤
- EXC_CRASH：对应SIGBART
- EXC_GUARD：⼀般是⽂件句柄防护，⽐如close到了⼀个内核的fd.
- EXC_RESOURCE：遇到了⼀些系统资源的限制，⼀般是CPU过载，线程调度太频繁，⽐如iOS中每秒⼦线程唤醒次数不能超过150

# Abort

##### Abort 包含哪些场景?

- 内存使⽤量过⾼、短时间内申请⼤量内存，系统发送signal9（signal9⽆法通过信号捕获）强制杀死进程（类似于Android端上的OOM），就是⼤家常说的Jetsam事件
- 主线程发⽣卡死超过⼀定时间watchdog强制杀死进程（不同系统版本卡死时间不同）
- 启动超时、后台切前台resume超时
- 部分死循环、递归等造成的栈溢出

##### Abort目标

- 现场及上下⽂捕获
- 定位 Abort 的业务场景、发⽣原因
- 基于现场及上下⽂捕获数据、Abort发⽣原因的⽅法形成⾼效的⼯具链，⽤于快速定位线上崩溃率发⽣的主因

#### Abort推导规则

需要根据可能导致客户端崩溃的原因设计推导规则，并基于线上⽤户的 Abort 数据快速聚合，从而发现并解决影响线上稳定性的问题



作者：好_好先生
链接：https://juejin.cn/post/7169193114844790791
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。