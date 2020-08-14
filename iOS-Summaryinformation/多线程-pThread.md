# 1. pthread

## 1.1 pthread 简介

pthread 是一套通用的多线程的 API，可以在Unix / Linux / Windows 等系统跨平台使用，使用 C 语言编写，需要程序员自己管理线程的生命周期，使用难度较大，我们在 iOS 开发中几乎不使用 pthread，但是还是来可以了解一下的。

## 1.2 pthread 使用方法

1. 首先要包含头文件`#import `
2. 其次要创建线程，并开启线程执行任务

```c
// 1. 创建线程: 定义一个pthread_t类型变量
pthread_t thread;
// 2. 开启线程: 执行任务
pthread_create(&thread, NULL, run, NULL);
// 3. 设置子线程的状态设置为 detached，该线程运行结束后会自动释放所有资源
pthread_detach(thread);

void * run(void *param)    // 新线程调用方法，里边为需要执行的任务
{
    NSLog(@"%@", [NSThread currentThread]);

    return NULL;
}
```

* `pthread_create(&thread, NULL, run, NULL);` 中各项参数含义：
  * 第一个参数`&thread`是线程对象，指向线程标识符的指针
  * 第二个是线程属性，可赋值`NULL`
  * 第三个`run`表示指向函数的指针(run对应函数里是需要在新线程中执行的任务)
  * 第四个是运行函数的参数，可赋值`NULL`

## 1.3 pthread 其他相关方法

* `pthread_create()` 创建一个线程
* `pthread_exit()` 终止当前线程
* `pthread_cancel()` 中断另外一个线程的运行
* `pthread_join()` 阻塞当前的线程，直到另外一个线程运行结束
* `pthread_attr_init()` 初始化线程的属性
* `pthread_attr_setdetachstate()` 设置脱离状态的属性（决定这个线程在终止时是否可以被结合）
* `pthread_attr_getdetachstate()` 获取脱离状态的属性
* `pthread_attr_destroy()` 删除线程的属性
* `pthread_kill()` 向线程发送一个信号

