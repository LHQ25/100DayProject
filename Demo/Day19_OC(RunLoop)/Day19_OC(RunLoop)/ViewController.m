//
//  ViewController.m
//  Day19_OC(RunLoop)
//
//  Created by 亿存 on 2020/8/14.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic , strong) NSThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end

//MARK: - 什么事RunLoop
//Run表示运行，Loop循环。结合在一起就是运行的循环的意思。通俗的来说就是「跑圈」

//MARK: - RunLoop和现成
//RunLoop和现成是息息相关额。我们知道线程的作用就是用来执行特定的一个或多个任务。在默认情况下，线程执行完就会退出，就不能再执行任务了，这时我们就需要采用一种方式来让线程能够不断的处理任务而不会退出。这就是RunLoop。
// 1. 一个线程对应一个RunLoop对象。每个线程都有唯一一个与之对应的RunLoop对象。
// 2. RunLoop并不能保证线程的安全。稚嫩恶搞在当前线程呢你不操作当前线程的RunLoop对象，而不能再当前线程内部去操作其它线程的RunLoop对象方法。
// 3. RunLoop对象在第一次获取RunLoop时创建，销毁则是在线程结束的时候。
// 4. 主线程的RunLoop对象系统自动帮我门创建好了，而子线程的RunLoop对象则需要我们主动创建和维护
