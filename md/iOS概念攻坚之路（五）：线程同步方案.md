## 前言

多线程编程所处的环境是一个复杂的环境，线程之间穿插执行，需要使用一定的手段来保证程序的正确运行，这个手段就是同步。这篇文章分了两个部分，第一部分会先介绍同步的概念，第二部分是 iOS 中能使用到的同步方案的一个分析以及具体如何使用。

## 线程同步的概念

### 为什么要同步

线程之间的关系是合作关系，既然是合作，那就得有某种约定的规则，否则合作就会出现问题。例如，第一个线程在执行了一些操作后想检查当前的错误状态 `errno`，但在其做出检查之前，线程 2 却修改了 `errno`。这样，当第一个线程再次获得控制权后，检查结果将是线程 2 改写过的 `errno`，而这是不正确的：

| 线程 1        | 线程 2        |
| ------------- | ------------- |
| ...           | ...           |
| 读 errno 变量 | ...           |
| ...           | 写 errno 变量 |
| 从读操作返回  | ...           |
| 检查 errno 值 | ...           |

之所以出现上述问题，是基于两个原因：

- `errno` 是线程之间共享的全局变量
- 线程之间的相对执行顺序是不确定的

解决上述问题有两个方法：第一个是限制全局变量，给每个线程一个私有的 `errno` 变量。事实上，如果可以将所有的资源都私有化，让线程之间不共享，那么这种问题就不复存在。

问题是，如果所有的资源都不共享，那么就不需要发明线程了，甚至也没必要发明进程。线程和进程的设计初衷：共享资源，提高资源利用率。所以这种方式是不切实际的。

那剩下的方法就是解决线程之间的执行顺序，方法就是同步。

同步的目的就是不管线程之间的执行如何穿插，都保证运行结果是正确的。

### 锁的进化：金鱼生存

这个例子是《计算机的心智操作系统之哲学原理（第2版）》中举的例子，非常生动的描述了锁的由来。

养过金鱼的人都知道，金鱼有一个很大的特点，就是没有饱的感觉。因此，金鱼吃东西不会因为吃饱就停止。它们会不停的吃，直到胀死。因此，金鱼池多少得由养金鱼的人来确定，其死活也由人控制。

现在假定 A 和 B 两个人合住一套公寓，共同养了一条金鱼。该金鱼每天进食一次。两个人想把金鱼养活，一天只能喂一次，也只能喂一次。如果一天内两人都喂了鱼，鱼就胀死。如果一天内两人都没有喂鱼，鱼就饿死。

他们二人为了把鱼养好，既不让鱼胀死，也不让鱼饿死，做出如下约定：

- 每天喂鱼一次，且仅一次
- 如果今天 A 喂了鱼，B 几天就不能再喂；反之亦然
- 如果今天 A 没有喂鱼，B 今天就必须喂；反之亦然

显然，要想保持鱼活着，A 和 B 得进行某种合作。当然，最简单的情况是不进行任何沟通，每个人觉得需要喂鱼时，查看一下鱼的状态：如果感觉到鱼像是没进过食，则喂鱼；否则不喂。下图给出的是没有同步情况下 A 和 B 所执行的程序：

```css
A:                          B:
if (noFeed) {               if (noFeed) {
    feed fish;                  feed fish;
}                           }
复制代码
```

那上述程序里是如何判断 `noFedd` 的值的呢？程序里没有给出，因此只能依靠 A 和 B 的高超养鱼技术，即通过查看鱼的外形来判断金鱼当天是否进食了。当然，只有高手才能达到这个水平，一般的人是看不出来的。万一 A 或者 B 没有看出对方已经喂过鱼了，再喂一次，鱼就胀死了。或者，没有看出对方没有喂过鱼，而没有喂，鱼就饿死了。

即使假设 A 和 B 都是养鱼高手，通过查看鱼的外形就可以判断鱼是否喂过，上述程序也能正确执行吗？答案是否定的。由于线程的执行可以任意穿插，A 可以先检查鱼，发现没有喂，就准备喂鱼。但就在 A 准备喂但尚未喂的时候，程序切换，轮到 B 执行。B 一看，鱼还没有喂（确实如此），就喂鱼。在喂完鱼后，线程再次切换到 A。此时 A 从检查完鱼状态后的指令开始执行，就是喂鱼。这样鱼被喂了两次，鱼就胀死了。

| 事件时序表 |              |              |
| ---------- | ------------ | ------------ |
| 时序       | A            | B            |
| 13:00      | 查看鱼(没喂) | ...          |
| 13:05      | ...          | 查看鱼(没喂) |
| 13:10      | ...          | 喂鱼         |
| 13:25      | 喂鱼         | ...          |
| 鱼胀死     |              |              |

为什么这个程序会出现鱼胀死的情况呢？因为 A 和 B 两个人同时执行了同一段代码（`if (noFeed) feed fish`）。两个或多个线程争相执行同一段代码或访问同一资源的现象称为 **竞争(race)**。这个可能造成竞争的共享代码段或资源称为 **临界区(critical section)**。

当然，我们知道两个线程不可能真的在同一时刻执行（单核情况）。但有可能在同一时刻两个线程都在同一段代码上。这个例子里竞争的是代码，是代码竞争。如果是两个线程同时访问一个数据就叫做数据竞争。这个程序造成鱼胀死的就是因为两个线程同时进入了临界区。

以人类进化来说，此程序只相当与氨基酸阶段，胡乱竞争，并不具备任何协调能力。

#### 变形虫阶段

要防止鱼胀死，就需要防止竞争，要想避免竞争，就需要防止两个或多个线程同时进入临界区。要达到这一点，就需要某种协调手段。

协调的目的就是在任何时刻都只能有一个人在临界区里，这称为 **互斥（mutual exclusion）**。互斥就是说一次只有一个人使用共享资源，其他人皆排除在外。正确互斥需要满足 4 个条件：

- 不能有两个进程同时在临界区里面
- 进程能够在任何数量和速度的 CPU 上正确执行
- 在互斥区域外不能阻止另一个进程的运行
- 进程不能无限制的等待进入临界区

如果任何一个条件不满足，那么设计的互斥就是不正确的。

那么有没有办法确保一次只有一个人在临界区呢？有，让两个线程协调。当然，最简单的协调方法是交谈。问题是 A 和 B 不一定有时间碰面，那么剩下的办法是留纸条。由此，获得第一种同步方式：A 和 B 商定，每个人在喂鱼之前先留下字条，告诉对方自己将检查鱼缸并在需要时喂鱼：

```scss
A:                          B:
if (noNote) {               if (noNote) {
    leave note;                 leave note;
    if (noFeed) {               if (noFeed) {
        feed fish;                  feed fish;
    }                           }
    remove note;                remove note;
}                           }
复制代码
```

上述机制能否避免鱼胀死呢？不能，如果 A 和 B 交叉执行上述程序，还是会造成鱼胀死的结局，这是因为虽然使用的是互斥的手段，即留字条，却没有达到互斥的目的。因为字条并没有方式 A 和 B 两个人同时进入临界区。当然，与第一个解决方案比起来，本方案还是有所改善，即鱼胀死的概率降低了。

只有在 A 和 B 严格交叉执行的情况下，才可能发生鱼胀死的现象。因此，我们并非完全在白费力气。

| 事件时序表 |                  |                  |
| ---------- | ---------------- | ---------------- |
| 时序       | A                | B                |
| 3:00       | 检查字条(没有)   | ...              |
| 3:05       | ...              | 检查字条(没有)   |
| 3:10       | ...              | 留下字条         |
| 3:25       | 留下字条         | ...              |
| 3:50       | 查看鱼(没有喂过) | ...              |
| 4:05       | ...              | 查看鱼(没有喂过) |
| 4:10       | ...              | 喂鱼             |
| 4:25       | 喂鱼             | ...              |
| 鱼胀死     |                  |                  |

此程序虽然加入了一点同步机制，但这个机制太原始，达不到真正的同步目的。以人类进化来比喻，此程序相当于变形虫阶段。

#### 鱼阶段

仔细分析可以发现，上述程序不解决问题的原因是我们先检查有没有字条，后留字条。这样在检查字条和留字条之间就留下了空当。那么我们就修改一下顺序，先留字条，再检查有没有对方的字条。如果没有对方的字条，那么就喂鱼，喂完把字条拿掉。不过这种方法需要区分字条是谁的，我们得到如下程序（第二种同步方案）：

```scss
A:                          B:
leave noteA;                leave noteB;
if (no noteB) {             if (no noteA) {
    if (no feed) {              if (noFeed) {
        feed fish;                  feed fish;
    }                           }
}                           }
remove noteA;               remove noteB;
复制代码
```

上述程序能够保证鱼不会被胀死，因为无论按照什么顺序穿插，总有一个人的留字条指令在另一个人的检查字条指令前执行，从而将防止两个人同时进入临界区，因而鱼不会因为两个人都喂而胀死。

但是，鱼却有可能饿死：

| 事件时序表         |                    |                    |
| ------------------ | ------------------ | ------------------ |
| 时序               | A                  | B                  |
| 3:00               | ...                | 留字条 noteB       |
| 3:05               | 留字条 A           | 检查字条(没有)     |
| 3:10               | 检查字条 noteB(有) | ...                |
| 3:25               | ...                | 检查字条 noteA(有) |
| 3:50               | ...                | 移除字条 noteB     |
| 4:05               | 移除字条 noteA     | ...                |
| 没有人喂鱼，鱼饿死 |                    |                    |

虽然存在饿死的情况，但是我们的力气并没有白费。对于一个计算机系统来说，饿死好于胀死。如果胀死，则程序的运行很可能出错：几个线程同时获得同一个资源，出现不一致性及结果不确定性几乎是难以避免的。但如果是饿死，即大家都拿不到某个资源，线程处于饥饿状态，至多是停止推进，而这不一定产生错误结果，或许只是推迟结果的出现。

虽然饿死比胀死好受一点，但毕竟还是存在死的可能，还是在很原始的阶段。以人类进化来比，相当于鱼阶段。因此，我们需要继续进化，或者说努力。

#### 猴阶段

那么为什么鱼会饿死呢？是因为没有人进入临界区。虽然互斥确保了没有两个人同时进入临界区，但这种没有人进入临界区的情况则有点互斥过了头。要想鱼不饿死，还要保证有一个人进入临界区来喂鱼。那用什么办法来保证呢？

办法就是让某个人等着，直到确认有人为了鱼才离去，不要一见到对方的字条就开溜走人。也就是说，在两个人同时留下字条的情况下，必须选择某个人来喂鱼，于是得出第 3 种同步方式：

```scss
A:                          B:
leave noteA;                leave noteB;
while(noteB) {              
    do nothing;
}
                            if (no noteA) {
if (noFeed) {                   if (noFeed) {
    feed fish;                      feed fish;
}                               }
                            }
remove noteA;               remove noteB;
复制代码
```

鱼显然不会胀死，因为使用的办法包括了第 2 种同步方式。那么鱼会不会饿死呢？也不会，因为前面说过，鱼饿死的唯一情况是两个人同时留字条，并且又都走人。而上述程序在两个人都留字条的情况下，A 不会走人，而是一直循环等待直到对方删除字条后，再检查鱼有没有喂，并在没有喂的情况下喂鱼。因此，该同步方式既防止了胀死，又防止了饿死。

这一阶段算是猴阶段，鱼既不会胀死，也不会饿死，但这还不够。

#### 锁

猴阶段的同步机制虽然正确，但存在很多问题。

首先是程序不对称。A 执行的程序和 B 执行的程序并不一样。那不对称有什么问题吗？当然有，不对称造成程序编写困难，为了追求程序的正确性，即使是做同样操作的线程也得编写得不同，这自然就增加了编程的难度。不对称还造成程序证明的困难，要想从理论上证明第 3 种同步方式程序的正确性是一件十分复杂的事情，这一点研究程序证明的人是很清楚的。

上述程序的另一个大问题是浪费，A 执行的循环等待是一种很大的浪费，但浪费还不是循环等待的唯一问题，它还可能造成 CPU 调度的 **优先级反转（倒挂）**。优先级反转就是高优先级的线程等待低优先级的线程。例如，假如 B 先于 A 启动，留下字条后正准备检查是否有 A 的字条时，A 启动。由于 A 的优先级高于 B，因此 A 获得 CPU，留下字条，进入循环等待。由于 A 的优先级高，因此 B 无法获得 CPU 而完成剩下的工作，进而造成 A 始终处于循环等待阶段无法推进。这样高优先级的 A 就被低优先级的 B 所阻塞。由于优先级反转完全违反了设立优先级的初衷，所以令人无法容忍。

那我们只能对同步方案进行改进，那么在哪一个方案的基础上改进呢？我们自然会想到最后一个方案，因为它已经满足了鱼既不饿死也不胀死的条件，无非就是不好看和循环等待。关键是这两点可以改进吗？答案是否定的，循环等待不能去掉，一去掉就变成第 2 个方案；若想使其对称、美观，就需要将 B 改为和 A 同样，而这样同样会造成鱼饿死的可能。因此对最后一个方案进行修改似乎不是明智之举。

新的思路就是直接最开始的两个方案进行修改。由于最开始的两个方案均达不到既不饿死又不胀死的条件，因此我们自然选择一个较为美观、简单的方案来修改。在两个方案之间，第 1 个方案完全对称，而第 2 个方案不完全对称，因为每个人的字条不同。因此，我们选择第 1 个方案作为修改的基础。但如何修改呢？

要想知道如何修改，就得知道第 1 个方案为什么不满足条件。

那么第 1 个方案为什么不满足条件呢？我们说过，是因为检查字条和留字条是两个步骤，中间留有被别的线程穿插的空当，从而造成字条作用的丧失。我们就想，能否将这两个步骤并为一个步骤，或者变成一个原子操作，使其中间不留空当，不就解决问题了吗？

换句话说，我们之所以到现在还没把金鱼问题处理掉，是因为我们一直在非常低的层次上打转。因为我们试图工作的层面是鱼和鱼缸这个层面，即留字条是为了防止两个人同时查看鱼缸。我们仅仅在指令层上进行努力。由于控制的单元是一条条的指令，因此对指令之间的空当无能为力。而解决这种问题的办法就是提高抽象的层次，将控制的层面上升到对一组指令的控制。

例如，在金鱼问题里，如果我们将抽象层次从保护鱼和鱼缸的层次提高到保护放置鱼缸的房间的层次，这个问题就可以解决。这样，检查字条和留字条的两步操作就变成将房间锁上的一步操作。

那么如何保证这个房间一次只进入一个人呢？我们先看看生活当中我们是如何确保一个房间只能进入一个人的。例如，两个教师都想使用同一个教室来为学生补课，怎么协调呢？进到教室后将门锁上，另外一个教师就无法进来使用教室了。即教室是用锁来保证互斥的。那么在操作系统里，这种可以保证互斥的同步机制称为 **锁**。

有了锁，金鱼问题就可以解决了。当一个人进来想喂鱼时，就把放有鱼缸的房间锁住，这样另外一个人进不来，自然无法喂鱼，如下所示：

```scss
A:                          B:
lock();                     lock()
if (noFeed) {               if (noFeed) {
    feed fish;                  feed fish;
}                           }
unlock();                   unlock();
复制代码
```

从上面程序我们可以看到，基于锁的互斥性，A 和 B 只能有一个人进入房间来喂鱼，因此鱼不会胀死。并且，如果两人都同时执行上述程序时，由于先拿到锁的人会进入房间喂鱼，因此鱼也不会饿死。更为重要的是，两个人执行完全同样的代码。既对称，也容易写，证明起来也不困难。这样，金鱼问题从而得到解决。

一个正常锁应该具备的特性：

- 锁的初始状态是打开状态
- 进临界区时必须获得锁
- 出临界区时必须打开锁
- 如果别人持有锁则必须等待

第一种方案之所谓没有将资源锁住，是因为违反了第 4 个条件，即在别人持有锁（留下字条）的情况下，也照样进入了临界区（因为检查是否别人持有锁在别人留锁之前进行）。因此，这个字条无法起到锁的作用。

以人类进化来比喻，上述程序相当于人阶段了。

那么这个程序还有什么问题没有？如果 A 正在喂鱼的话，B 能干什么事情吗？只能等待（等待锁变为打开状态）。如果 A 喂鱼的动作很慢，B 等待的事件就会很长。而这种繁忙等待不仅将造成浪费，而且将降低系统效率。那有没有办法消除锁的繁忙等待呢？答案是否定的，因为锁的特性就是在别人持有锁的情况下需要等待。不过还是可以减少繁忙等待的时间长度。怎么缩短等待的时间呢？

仔细分析发现，A 喂鱼并不需要在持有锁的状态下进行。我们就希望喂鱼的这段时间不要放在锁里面，而是获得锁后留下字条说它喂鱼去了，然后释放锁，再喂鱼。而 B 在拿到锁后先检查有没有字条，有字条就释放锁，干别的去。没有就留字条，然后释放锁，再喂鱼。这样，由于持锁的时间只限于设置字条的事件，因此，对方循环等待的时间会很短，而真正的操作（在这里是喂鱼）则随便多慢也没有问题了。

```scss
A:                              B:
lock();                         lock();
if (no NoteB) {                 if (no NoteA) {
    leave noteA;                    leave noteB;
}                               }
unlock();                       unlock();
if (no NoteB) {                 if (no NoteA) {
    if (noFeed) {                   if (noFeed) {
        feed fish;                      feed fish;
    }                               }
    remove note;                    remove note;
}                               }
复制代码
```

这个方法使得锁上的繁忙等待时间变得很少。但不管怎样，终究还是需要等待的。那有没有办法不用进行任何繁忙等待呢？有，答案就是睡觉与叫醒，即 `sleep` 和 `wakeup`。

### 睡觉与叫醒：生产者与消费者问题

什么是睡觉与唤醒呢？就是如果对方持有锁，你就不需要等待锁变为打开状态，而是去睡觉，锁打开后对方再来把你叫醒。我们下面用生产者与消费者的问题来演示这个机制。

生产者生产的产品由消费者来消费，但消费者一般不直接从生产者手里获取产品，而是通过一个中介机构，比如商店。生产者把东西放在这里，消费者到这里来拿。为什么需要这个中介机构呢？这是因为商店的存在使得生产者和消费者能够相对独立的运行，而不必亦步亦趋的跟在另一方后面。

用计算机来模拟生产者和消费者是件很简单的事：一个进程代表生产者，一个进程代表消费者，一片内存缓冲区代表商店。生产者生产的物品从一端放入缓冲区，消费者从另外一段获取物品，如下图：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/6/16b2b8eb8ead1589~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



一个非常好的例子是校园中的售货机。售货机是缓冲区，负责装载售货机的送货员是生产者，而购买可乐、糖果的学生是消费者。只要售货机不满也不空，送货员和学生就可以继续他们的送货和消费。问题是，如果学生来买可乐，却发现售货机空了，怎么办？学生当然有两个选择：一是坐在售货机前面等待，直到送货员来装货为止；二是回宿舍睡觉，等售货员装货后再来买。第 1 种方式显然效率很低，估计没有什么人愿意这么做。比较起来，第 2 种方式要好些。只不过睡觉中的学生不可能知道售货员来了，因此我们需要送货员来了后将学生叫醒。

同样，如果送货员来送货发现售货机满时也有两种应对办法：一是等有人来买走一些东西，然后将售货机填满；二是回家睡觉，等有人买了后再来补货。当然，这个时候购买者需要将送货员叫醒。以程序来表示生产者和消费者问题的解决方案如下：

```ini
#define N 100   // 售货机最大商品数
Int count = 0;  // 售货机当前商品数

void producer(void) 
{
    int item;
    while(TRUE) {
        item = produce_item();
        if (count == N) sleep();
        insert_item(item);
        count = count+1;
        if (count == 1) wakeup(consumer);
    }
}

void consumer(void) 
{
    int item;
    while(TRUE) {
        if (count == 0) sleep();
        item = remove_item();
        count = count-1;
        if (count == N-1) wakeup(producer);
        consume_item(item);
    }
}
复制代码
```

`sleep` 和 `wakeup` 就是操作系统里的睡觉和叫醒操作原语。一个程序调用 `sleep` 后将进入休眠状态，将释放其所占用的 CPU。一个执行 `wakeup` 的程序将发送一个信号给指定的接收进程，如 `wakeup(producer)` 就发送一个信号给生产者。

我们仔细来看上面的程序。最上面两行定义了缓冲区的大小（可容纳 100 件商品）和当前缓冲区里面的商品个数，初始化为 0。生产者程序的运行如下：每生产一件商品，检查当前缓冲区的商品数，如果缓冲区已满，则该程序进入睡眠状态；否则将商品放入缓冲区，将计数加 1。然后判断计数是否等于 1 ，如果是，说明在放这件商品前缓冲区中的商品个数为 0，有可能存在消费者见到空缓冲区而去睡觉，因此需要发送叫醒信号给消费者。

消费者程序运行如下：先检查当前商品计数，如果是 0，没有商品，当然去睡觉。否则，从缓冲区拿走一件商品，将计数减 1 。然后判断计数是否等于 `N-1`。如果是，则说明在拿这件商品前缓冲区的商品计数为 N，有可能存在生产者见到满缓冲区而去睡觉，因此需要发送叫醒信号给生产者。然后尽情地享用商品。

这个程序看上去似乎正确无误，但实际上还是存在问题。

第一个问题：变量 `count` 没有被保护，可能发生数据竞争。即生产者和消费者可能同时对该数据进行修改。例如，假定 `count` 现在等于 1。那么生产者先运行，对 `count` 加 1 操作后 `count` 变为 2，但在判断 `count` 是否等于 1 之前，CPU 被消费者获得，随后对 `count` 进行了减 1 的操作后切换回生产者，这个时候 `count` 等于 1，因此生产者将发出叫醒消费者的信号。显然，这个信号是不应该发出的。

第二个问题：上述程序可能造成生产者和消费者均无法往前推进的情况，即死锁。例如，假定消费者先来，这个时候 `count = 0`，于是去睡觉，但是在判断 `count == 0` 后并且在执行 `sleep` 语句前 CPU 发生切换，生产者开始运行，它生产一件商品后，给 `count` 加 1，发现 `count` 结果为 1，因此发出叫醒消费者信号。但这个时候消费者还没有睡觉（正准备要睡），所以该信号没有任何效果，浪费了。而生产者一直运行直到缓冲区满了后也去睡觉。这个时候 CPU 切换到消费者，而消费者执行的第 1 个操作就是 `sleep`，即睡觉。至此，生产者和消费者都进入睡觉状态，从而无法相互叫醒而继续往前推进。系统死锁发生。

那我们如何解决上述两个问题呢？对第 1 个问题，解决方案很简单：用锁！在进行对 `count` 的操作前后分别加上开锁和闭锁即可防止生产者和消费者同时访问 `count` 情况的出现。不过，我们不就是因为锁存在繁忙等待才发明 `sleep` 和 `wakeup` 的吗？怎么又把锁请回来了呢？

确实，我们不喜欢锁所采用的繁忙等待，因而发明了 `sleep` 和 `wakeup`，但是，我们不喜欢等待，并不是一刻都不能等，只要等待的事件够短，就是可以接受的。而在 `count` 的访问前后加上锁所造成的繁忙等待是很短的。（iOS SideTable 中的自旋锁也是这样的锁，因为引用计数的增减是很迅速的操作）

勉强解决了第 1 个问题，第 2 个问题怎么解决呢？

显然，生产者和消费者都不会自己从睡觉中醒过来。所以如果二者同时去睡觉了，自然也无法叫醒对方。那解决的方案就是不让二者同时睡觉。而造成二者同时睡觉的原因是生产者发出的叫醒信号丢失（因为消费者此时还没睡觉）。那我们就想，如果用某种方法将发出的信号累积起来，而不是丢掉，问题不就解决了吗？在消费者获得 CPU 并执行 `sleep` 语句后，生产者在这之前发送的叫醒信号还保留，因此消费者将马上获得这个信号而醒过来。而能够将信号量累积起来的操作系统原语就是信号量。

### 信号量

**信号量(semphore)** 可以说是所有原语里面功能最强大的。它不仅是一个同步原语，还是一个通信原语。而且，它还能作为锁来使用！前面已经讨论过作为通信原语的信号量，现在我们来看其作为同步原语和锁的能力。

简单来说，信号量就是一个计数器，其取值为当前累积的信号数量。它支持两个操作：加法操作 up 和减法操作 down，分别描述如下：

down 减法操作：

1. 判断信号量的取值是否大于等于 1
2. 如果是，将信号量的值减去 1，继续往下执行
3. 否则在该信号量上等待（线程被挂起）

up 加法操作：

1. 将信号量的值加 1（此操作将叫醒一个在该信号量上面等待的线程）
2. 线程继续往下执行

这里需要注意的是，down 和 up 两个操作虽然包含多个步骤，但这些操作是一组原子操作，它们之间是不能分开的。

如果将信号量的取值限制为 0 和 1 两种情况，则获得的就是一把锁，也被称为 **二元信号量（binary semaphore）**，其操作如下：

down 减法操作：

1. 等待信号量的值变为 1
2. 将信号量的值设置为 0
3. 继续往下执行

up 加法操作：

1. 将信号量的值设置为 1
2. 叫醒在该信号量上面等待的第 1 个线程
3. 线程继续往下执行

由于二元信号量的取值只有 0 和 1，因此上述程序防止任何两个程序同时进入临界区。

二元信号量具备锁的功能，实际上它与锁很相似：down 就是获得锁，up 就是释放锁。但它又比锁更为灵活，因为在信号量上等待的线程不是繁忙等待，而是去睡觉，等待另外一个线程执行 up 操作来叫醒。因此，二元信号量从某种意义上说就是锁和睡觉与叫醒两种原语操作的合成。

有了信号量，我们就可以轻而易举地解决生产者和消费者的同步问题。具体说来就是，我们先设置 3 个信号量，分别如下：

```makefile
mutex:
一个二元信号量，用来防止两个线程同时对缓冲区进行操作。
初始值为 1。

full:
记录缓冲区里商品的件数。
初始值为 0。

empty:
记录缓冲区里空置空间的数量。
初始值为 N（缓冲区大小）
复制代码
```

我们的生产者和消费者程序如下：

```scss
const int N = 100;          // 定义缓冲区大小
typedef int semaphore;      // 定义信号量类型
semaphore mutex = 1;        // 互斥信号量
semaphore empty = N;        // 缓冲区计数信号量，用来计数缓冲区里的空位数量
semaphore full = 0;         // 缓冲区计数信号量，用来计数缓冲区里的商品数量

void producer(void)                 
{
    int item;
    while(TRUE) {
        item = produce_item();
        down(empty);
        down(mutex);
        insert_item(item);
        up(mutex);
        up(full);
    }
}

void consumer(void) 
{
    int item;
    while(TRUE) {
        down(full);
        down(mutex);
        item = remove_item();
        up(mutex);
        up(empty);
        consume_item(item);
    }
}
复制代码
```

该程序解决了前一个版本的问题吗？很显然，上述程序中生产者和消费者不可能同时睡觉而造成死锁。因为两个人同时睡觉就意味着：`full=0`（生产者才睡觉），并且 `empty=0`（消费者睡觉的条件）。那么 `empty` 和 `full` 能够同时为 0 吗？当然不会，因为初始值是 `empty = N` 而 `full = 0`。要使 `empty=0`，生产者就必须生产，而一旦生产者开始生产，`full` 就不能为 0 了。所以两个不会同时睡觉。

这样上述程序既保护了缓冲区不会被生产者和消费者同时访问，又防止了生产者或消费者发送的信号丢失。生产者生产了多少商品，信号量 `full` 就取多大的值，这就相当于前一个版本里面发送的信号的个数。因为消费者等待的地方就是 `full` 这个信号量，因此，生产者生产了多少商品，就可以最多这么多次叫醒消费者。反之亦然，消费者消费了多少商品，信号量 `empty` 就记录了多少数量，也就是可以多少次叫醒生产者。这样就解决了信号丢失的问题。

那为什么需要 3 个信号量呢？一个二元信号量用来互斥，一个信号量用来记录缓冲区里商品的数量不就可以了吗？缓冲区里空格的数量不是可以由缓冲区大小和缓冲区里商品的数量计算得出吗？为什么需要一个 `full` 和一个 `empty` 来记录满的和空的呢？这是因为生产者和消费者等待的信号不同，它们需要在不同的信号上睡觉。

## iOS 线程同步方案

先列举一下上面提到的概念：

- 同步：解决线程之间的执行顺序，不管线程之间的执行如何穿插，都保证运行结果是正确的
- 竞争：两个或多个线程争相执行同一段代码或访问同一资源的现象称为竞争
- 临界区：造成竞争的共享代码或资源
- 互斥：一次只有一个人使用共享资源，其他人皆排除在外
- 锁：一种操作系统中保持互斥的同步机制
- 优先级反转（倒挂）：高优先级的线程被低优先级线程阻塞
- 睡觉与叫醒（sleep 和 wakeup）：睡觉指让线程休眠，不占用 CPU 资源，叫醒指唤醒线程；为解决繁忙等待问题而被提出的方案
- 信号量：一个计数器，其取值为当前累积的信号数量；为解决信号丢失提出的方案
  - down 操作
    - 判断信号量的值是否大于等于1
    - 如果是，将信号量的值减 1，继续往下执行
    - 否则在该信号量上等待（线程被挂起）
  - up 操作
    - 将信号量的值加 1（此操作将叫醒一个在该信号量上面等待的线程）
    - 线程继续往下执行
- 二元信号量（互斥量）：信号量取值限制为 0 和 1，相当于锁和睡觉与叫醒操作的一个合成

iOS 中的线程同步方案，其实是 iOS 对锁、信号量、互斥量、条件变量的实现。因为 iOS 中使用了 GCD，所以还可以使用 GCD 的串行队列来实现同步。iOS 中有原子操作，就是在属性中使用 `atomic`，但是它有局限性，只能保证在设置和获取时是原子操作，但不能保证设置和获取操作是在哪一个线程中进行，下面先列举一下 iOS 中的那些线程同步方案：

- `OSSpinLock`

- `os_unfair_lock`

- ```
  pthread_mutex
  ```

  - `PTHREAD_MUTEX_NORMAL`
  - `PTHREAD_MUTEX_ERRORCHECK`
  - `PTHREAD_MUTEX_RECURSIVE`
  - `PTHREAD_MUTEX_DEFAULT`

- `dispatch_semaphore`

- `dispatch_queue(DISPATCH_QUEUE_SERIAL)`

- `NSLock`

- `NSRecursiveLock`

- `NSCondition`

- `NSConditionLock`

- `@synchronized`

来分别看一下它们的具体含义与如何使用，在下面的例子中我们统一使用下面这个异步方法：

```scss
- (void)doSomeThingForFlag:(NSInteger)flag finish:(void(^)(void))finish {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"do:%ld",(long)flag);
        sleep(2+arc4random_uniform(4));
        NSLog(@"finish:%ld",flag);
        if (finish) finish();
    });
}
复制代码
```

### OSSpinLock

`OSSPinlock` 就是自旋锁，速度应该是最快的锁，等待锁的线程会处于 **忙等（busy-wait）** 状态，一直占用着 CPU 资源，因为它需要不断的去尝试获取锁。这种忙等状态的锁会造成一个很严重的问题，那就是优先级反转，也称为优先级倒挂，前面的猴阶段中也提到这个问题，另外 YYKit 的作者专门写了一篇 [不再安全的 OSSpinLock](https://link.juejin.cn?target=https%3A%2F%2Fblog.ibireme.com%2F2016%2F01%2F16%2Fspinlock_is_unsafe_in_ios%2F) 来解释这个问题：

在 iOS 中，系统维护了 5 个不同的线程优先级/Qos：`background`、`utility`、`default`、`user-initiated`、`user-interactive`。高优先级线程始终会在低优先级线程前执行，一个线程不会受到比它更低优先级线程的干扰。这种线程调度算法存在潜在的优先级反转的问题。

具体来说，在使用自旋锁的情况，如果一个低优先级的线程获得锁并访问共享资源，这时一个高优先级的线程也尝试获得这个锁，它会处于忙等状态状态从而占用大量 CPU。此时低优先级线程无法与高优先级线程争夺 CPU 时间（抢不过），从而导致任务迟迟完不成，无法释放 `lock`。这并不只是理论上的问题，`lobobjc` 已经遇到很多次这个问题，于是苹果的工程师停用了 `OSSpinLock`。

不过还是有解决方案，也是 `libobjc` 目前正在使用的：锁的持有者把线程 ID 保存到锁内部，锁的等待着会临时贡献出它的优先级来避免优先级反转的问题。理论上这种模式会在比较复杂的多锁条件下产生问题，但实践上目前还一切都好。

`libobjc` 里用的是 `Mach` 内核的 `thread_switch()` 然后传递了一个 `mach thread port` 来避免优先级反转，另外它还用了一个私有的参数选项，所以开发者无法自己实现这个锁。另一方面，由于二进制兼容问题，`OSSpinLock` 也不能有改动。

所以，除非开发者能保证访问锁的线程全部都处于同一优先级，否则 iOS 系统中所有类型的自旋锁都不能再使用了。当然苹果还在用，SideTable 中就包含了一个自旋锁，用于对引用计数的增减操作，这种轻量操作也是自旋锁的使用场景。

来看一下 `OSSpinLock` 的使用，要导入 `<libkern/OSAtomic.h>`：

```ini
#import <libkern/OSAtomic.h>

/**
 OSSpinLock
 */
- (void)useOSSpinlock {
    
    __block OSSpinLock oslock = OS_SPINLOCK_INIT;
    
    OSSpinLockLock(&oslock);
    [self doSomeThingForFlag:1 finish:^{
        OSSpinLockUnlock(&oslock);
    }];
    
    OSSpinLockLock(&oslock);
    [self doSomeThingForFlag:2 finish:^{
        OSSpinLockUnlock(&oslock);
    }];
    
    OSSpinLockLock(&oslock);
    [self doSomeThingForFlag:3 finish:^{
        OSSpinLockUnlock(&oslock);
    }];
    
    OSSpinLockLock(&oslock);
    [self doSomeThingForFlag:4 finish:^{
        OSSpinLockUnlock(&oslock);
    }];
    
}
复制代码
```

### os_unfair_lock

`os_unfair_lock` 是作为 `OSSpinLock` 的替代方案被提出来的，iOS 10.0 之后开始支持。不过从底层调用来看，等待 `os_unfair_lock` 的线程会处于休眠状态，而并非 `OSSpinLock` 的忙等状态，线程的切换是需要资源的，所以它的效率不如 `OSSpinLock`。

它的使用与 `OSSpinLock` 很类似：

```objective-c
#import <os/lock.h>

- (void)viewDidLoad {
    [super viewDidLoad];
    [self useOS_Unfair_Lock];
}

// 定义锁变量
os_unfair_lock unfairLock;
- (void)useOS_Unfair_Lock {
    // 初始化锁
    unfairLock = OS_UNFAIR_LOCK_INIT;

    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(request1) object:nil];
    [thread1 start];

    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(request2) object:nil];
    [thread2 start];
}

- (void)request1 {
    // 加锁
    os_unfair_lock_lock(&unfairLock);
    NSLog(@"do:1");
    sleep(2+arc4random_uniform(4));
    NSLog(@"finish:1");
    // 解锁
    os_unfair_lock_unlock(&unfairLock);
}

- (void)request2 {
    // 加锁
    os_unfair_lock_lock(&unfairLock);
    NSLog(@"do:2");
    sleep(2+arc4random_uniform(4));
    NSLog(@"finish:2");
    // 解锁
    os_unfair_lock_unlock(&unfairLock);
}
复制代码
```

### pthread_mutex

`pthread_mutex` 有几种类型：

```arduino
/*
 * Mutex type attributes
 */
#define PTHREAD_MUTEX_NORMAL		0
#define PTHREAD_MUTEX_ERRORCHECK	1
#define PTHREAD_MUTEX_RECURSIVE		2
#define PTHREAD_MUTEX_DEFAULT		PTHREAD_MUTEX_NORMAL
复制代码
```

`PTHREAD_MUTEX_NORMAL` 是缺省类型，所以只有三种类型。

- `PTHREAD_MUTEX_NORMAL`：默认类型，普通锁，当一个线程加锁后，其余请求锁的线程将形成一个等待队列，并在解锁后按优先级获得锁。这种锁策略保证了资源分配的公平性。
- `PTHREAD_MUTEX_ERRORCHECK`：检错锁，如果同一个线程请求同一个锁，则抛出一个错误，否则与 `PTHREAD_MUTEX_NORMAL` 类型动作一致。这样就保证当不允许多次加锁时不会出现最简单情况下的死锁。
- `PTHREAD_MUTEX_RECURSIVE`：递归锁，允许同一个线程对同一个锁成功获得多次，并通过多次 `unlock` 解锁。如果是不同线程请求，则在加锁线程解锁时重新竞争。

`PTHREAD_MUTEX_NORMAL` 的使用：

```scss
#import <pthread.h>

- (void)viewDidLoad {
    [super viewDidLoad];
    [self usePthread_mutex_normal];
}

pthread_mutex_t pNormalLock;
- (void)usePthread_mutex_normal {
    
    // 初始化锁的属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
    
    // 初始化锁
    pthread_mutex_init(&pNormalLock, &attr);
    
    // 销毁 attr
    pthread_mutexattr_destroy(&attr);
    
    pthread_mutex_lock(&pNormalLock);
    [self doSomeThingForFlag:1 finish:^{        pthread_mutex_unlock(&pNormalLock);    }];
    
    pthread_mutex_lock(&pNormalLock);
    [self doSomeThingForFlag:2 finish:^{        pthread_mutex_unlock(&pNormalLock);    }];
    
    pthread_mutex_lock(&pNormalLock);
    [self doSomeThingForFlag:3 finish:^{        pthread_mutex_unlock(&pNormalLock);    }];
    
    pthread_mutex_lock(&pNormalLock);
    [self doSomeThingForFlag:4 finish:^{        pthread_mutex_unlock(&pNormalLock);    }];
    
}
复制代码
```

`PTHREAD_MUTEX_ERRORCHECK` 与 `PTHREAD_MUTEX_NORMAL` 只是多了个同线程对同一把锁加锁的话会抛出一个错误，我们来看一下递归锁。递归锁意思是同一个线程可以多次获得同一个锁，其他线程如果想要获取这把锁，必须要等待，这种锁一般都是用于递归函数的情况。

递归锁的使用：

```scss
#import <pthread.h>

- (void)viewDidLoad {
    [super viewDidLoad];
    [self usePthread_mutex_recursive];
}

pthread_mutex_t pRecursiveLock;
- (void)usePthread_mutex_recursive {
    // 初始化锁属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    
    // 初始化锁
    pthread_mutex_init(&pRecursiveLock, &attr);
    
    // 销毁attr
    pthread_mutexattr_destroy(&attr);
    
    [self thread1];
    
}

- (void)thread1 {
    pthread_mutex_lock(&pRecursiveLock);
    static int count = 0;
    count ++;
    if (count < 10) {
        NSLog(@"do:%d",count);
        [self thread1];
    }
    pthread_mutex_unlock(&pRecursiveLock);
    NSLog(@"finish:%d",count);
}

- (void)dealloc {
    // 销毁锁
    pthread_mutex_destroy(&pRecursiveLock);
}

@end
复制代码
```

### dispatch_semaphore

`dispatch_semaphore` 是 GCD 实现的信号量，信号量是基于计数器的一种多线程同步机制，内部有一个可以原子递增或递减的值，关于信号量的 API 主要是三个，`create`、`wait` 和 `signal`。

信号量在初始化时要指定 `value`，随后内部将这个 `value` 存储起来。实际操作会存在两个 `value`，一个是当前的 `value`，一个是记录初始 `value`。

信号的 `wait` 和 `signal` 是互逆的两个操作。如果 `value` 大于 0，前者将 `value` 减一，此时如果 `value` 小于 0 就一直等待。后者将 `value` 加一。

初始 `value` 必须大于等于 0，如果为 0 并随后调用 `wait` 方法，线程将被阻塞直到别的线程调用了 `signal` 方法。

简单来讲，信号量为 0 则阻塞线程，大于 0 则不会阻塞，可以通过改变信号量的值，来控制是否阻塞线程，从而达到线程同步。

```arduino
// 创建信号量，参数：信号量的初始值，如果小于 0 会返回 NULL
dispatch_semaphore_t dispatch_semaphore_create(long value);

// 等待降低信号量，接收一个信号和时间值（多为 DISPATCH_TIME_FOREVER）
// 若信号的信号量为 0，则会阻塞当前线程，直到信号量大于 0 或者经过输入的时间值
// 若信号量大于 0，则会使信号量减 1 并返回，程序继续往下执行
long dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout);

// 增加信号量，使信号量加 1 并返回
long dispatch_semaphore_signal(dispatch_semaphore_t dsema);
复制代码
```

在 `dispatch_semaphore_wait` 和 `dispatch_semaphore_signal` 这两个函数中间的执行代码，每次只会允许限定数量的线程进入。我们一般需要控制线程数量的时候使用信号量，下面介绍信号量的几个使用场景。

#### 保持线程同步，将异步操作转换为同步操作

```ini
/**
 保持线程同步，将异步操作转换为同步操作
 */
- (void)semaphoreTest1 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int i = 0;
    dispatch_async(queue, ^{
        i = 100;
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"i = %d",i);
}
复制代码
```

结果输出 `i = 100`。`block` 异步执行添加到了全局并发队列里，所以程序在主线程会跳过 `block` 块（同时开辟子线程异步执行 `block`），执行 `block` 外的代码 `dispatch_semaphore_wait`，因为 `semaphore` 信号量为 0，且时间为 `DISPATCH_TIME_FOREVER`，所以会阻塞当前线程（主线程），进而只执行子线程的 `block`，直到 `block` 内部的 `dispatch_semaphore_signal` 使得信号量 `+1`。正在被阻塞的线程（主线程）会恢复继续执行，这样就保证了线程之间的同步。

#### 为线程加锁

```scss
/**
 为线程加锁
 */
- (void)semaphoreTest2 {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self doSomeThingForFlag:1 finish:^{        dispatch_semaphore_signal(semaphore);    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self doSomeThingForFlag:2 finish:^{        dispatch_semaphore_signal(semaphore);    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self doSomeThingForFlag:3 finish:^{        dispatch_semaphore_signal(semaphore);    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    [self doSomeThingForFlag:4 finish:^{        dispatch_semaphore_signal(semaphore);    }];
    
}
复制代码
```

#### 限制线程最大并发数

```scss
/**
 限制线程最大并发数
 */
- (void)semaphoreTest3 {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 100; i++) {
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"running");
            sleep(1);
            NSLog(@"completed...................");
            dispatch_semaphore_signal(semaphore);
        });
    }
}
复制代码
```

看控制台打印可以看到线程的最大并发数被限制在了 3。不过更好的做法是使用 `NSOperationQueue` 和 `NSOperation` 来实现，而不是通过 GCD 和信号量来构建自己的解决方案。

### dispatch_queue(DISPATCH_QUEUE_SERIAL)

```ini
- (void)dispatch_queue_serial {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    
    for (NSInteger i = 0; i < 100; i++) {
        dispatch_async(queue, ^{
            dispatch_suspend(queue);
            [self doSomeThingForFlag:i finish:^{
                dispatch_resume(queue);
            }];
        });
    }
}
复制代码
```

关键是使用 `dispatch_suspend()` 和 `dispatch_resume()`。

既然 GCD 可以实现，那么封装了 GCD 的 `NSOperationQueue` 自然也能够实现。

```ini
- (void)userOperationQueue {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    
    __weak typeof(self) weakSekf = self;
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [queue setSuspended:YES];
        [weakSekf doSomeThingForFlag:1 finish:^{
            [queue setSuspended:NO];
        }];
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [queue setSuspended:YES];
        [weakSekf doSomeThingForFlag:2 finish:^{
            [queue setSuspended:NO];
        }];
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [queue setSuspended:YES];
        [weakSekf doSomeThingForFlag:3 finish:^{
            [queue setSuspended:NO];
        }];
    }];
    
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        [queue setSuspended:YES];
        [weakSekf doSomeThingForFlag:4 finish:^{
            [queue setSuspended:NO];
        }];
    }];
    
    [operation4 addDependency:operation3];
    [operation3 addDependency:operation2];
    [operation2 addDependency:operation1];
    
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperation:operation4];
    
}
复制代码
```

### NSLock

`NSLock` 是对 `PTHREAD_MUTEX_ERRORCHECK` 类型的 `pthread_mutex_t` 的封装。

```ini
- (void)useNSLock {
    NSLock *nsLock = [[NSLock alloc] init];
    
    [nsLock lock];
    [self doSomeThingForFlag:1 finish:^{
        [nsLock unlock];
    }];
    
    [nsLock lock];
    [self doSomeThingForFlag:2 finish:^{
        [nsLock unlock];
    }];
    
    [nsLock lock];
    [self doSomeThingForFlag:3 finish:^{
        [nsLock unlock];
    }];
    
    [nsLock lock];
    [self doSomeThingForFlag:4 finish:^{
        [nsLock unlock];
    }];
}
复制代码
```

### NSRecursiveLock

```ini
NSRecursiveLock *recursiveLock;
- (void)useNSRecursiveLock {
    recursiveLock = [[NSRecursiveLock alloc] init];
    [self thread2];
}

- (void)thread2 {
    [recursiveLock lock];
    static int count = 0;
    count ++;
    if (count < 10) {
        NSLog(@"do:%d",count);
        [self thread2];
    }
    [recursiveLock unlock];
    NSLog(@"finish:%d",count);
}
复制代码
```

### pthread_cond_t & NSCondition

条件变量，可以看看上文中关于睡觉与叫醒那部分，意为当满足条件时，唤醒线程，不满足时线程会进行休眠。

以一个 生产-消费者 模式来看看 `pthread_cond_t` 如何使用：

```scss
pthread_mutex_t pMutex;
pthread_cond_t pCond;
NSData *data;
int count = 1;
- (void)usePthreadCond {
//    // 初始化锁属性
    pthread_mutexattr_t mutexAttr;
    pthread_mutexattr_init(&mutexAttr);
    pthread_mutexattr_settype(&mutexAttr, PTHREAD_MUTEX_NORMAL);

    // 初始化条件变量属性
    pthread_condattr_t condAttr;
    pthread_condattr_init(&condAttr);

    // 初始化条件变量
    pthread_cond_init(&pCond, &condAttr);
    // 初始化锁
    pthread_mutex_init(&pMutex, &mutexAttr);

    // 销毁 attr
    pthread_mutexattr_destroy(&mutexAttr);
    pthread_condattr_destroy(&condAttr);
    
    data = nil;
    [self producter];  // 保证模型能走动，先执行一次生产者的操作
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self consumer];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self producter];
        });
    }

}

- (void)consumer {  // 消费者
    pthread_mutex_lock(&pMutex);
    while (data == nil) {
        pthread_cond_wait(&pCond, &pMutex);  // 等待数据
    }
    
    // 处理数据
    NSLog(@"data is finish");
    data = nil;
    
    pthread_mutex_unlock(&pMutex);
}

- (void)producter {  // 生产者
    pthread_mutex_lock(&pMutex);
    // 生产数据
    data = [[NSData alloc] init];
    NSLog(@"preparing data");
    sleep(1);
    
    pthread_cond_signal(&pCond);  // 发出信号，数据已完成
    pthread_mutex_unlock(&pMutex);
}
复制代码
```

然后来看看 `NSCondition`，它是对 `pthread_cond_t` 和 `pthread_mutex_t` 的一个封装：

```ini
NSCondition *cond;
NSData *ns_data;
- (void)useNSCondition {
    
    cond = [[NSCondition alloc] init];
    ns_data = nil;
    
    [self ns_producter];
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self ns_consumer];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self ns_producter];
        });
    }

}

- (void)ns_consumer {
    [cond lock];
    while (ns_data == nil) {
        [cond wait];  // 等待数据
    }
    // 处理数据
    NSLog(@"data is finish");
    [cond unlock];
}

- (void)ns_producter {
    [cond lock];
    // 生产数据
    ns_data = [[NSData alloc] init];
    NSLog(@"preparing data");
    sleep(1);
    
    [cond signal];  // 发出信号，数据已完成
    [cond unlock];
}
复制代码
```

使用 `NSCondition` 不需要另外创建一个锁，直接使用 `[cond lock]` 即可。

### NSConditionLock

`NSConditionLock` 借助 `NSCondition` 来实现，它的本质就是一个「生产-消费者」模型。“条件被满足” 可以理解为生产者提供了新的内容。`NSConditionLock` 的内部持有一个 `NSCondition` 对象，以及 `_condition_value` 属性，在初始化时就会对这个属性进行赋值。

```ini
// 简化版代码
- (id)initWithCondition:(NSInteger)value {
    if (nil != (self = [super inir])) {
        _condition = [NSCondition new];
        _condition_value = value;
    }
    return self;
}
复制代码
```

它的 `lockWhenCondition:` 其实就是消费者方法：

```scss
- (void)lockWhenCondition:(NSInteger)value {
    [_condition lock];
    while (value != _condition_value) {
        [_condition wait];
    }
}
复制代码
```

对应的 `unlockWhenCondition:` 方法则是生产者，使用了 `boardcast` 方法通知所有的消费者：

```ini
- (void)unlockWithCondition:(NSInteger)value {
    _condition_value = value;
    [_condition broadcast];
    [_condition unlock];
}
复制代码
```

下面是一个完整的例子：

```ini
- (void)useNSConditionLock {
    NSConditionLock *condLock = [[NSConditionLock alloc] initWithCondition:1];
    
    [condLock lockWhenCondition:1];
    [self doSomeThingForFlag:1 finish:^{
        [condLock unlockWithCondition:2];
    }];
    
    [condLock lockWhenCondition:2];
    [self doSomeThingForFlag:2 finish:^{
        [condLock unlockWithCondition:3];
    }];
    
    [condLock lockWhenCondition:3];
    [self doSomeThingForFlag:3 finish:^{
        [condLock unlockWithCondition:4];
    }];
    
    [condLock lockWhenCondition:4];
    [self doSomeThingForFlag:4 finish:^{
        [condLock unlock];
    }];
    
}
复制代码
```

`NSConditionLock` 是对 `NSCondition` 的进一步封装，可以对条件变量赋值，这样我们就可以用它来实现顺序执行线程。

### @synchronized

是对 `pthread_mutex_t` 中递归锁的一个封装，苹果不推荐使用，因为性能差。

```objectivec
- (void)useSynchronized {
    [self thread5];
}

- (void)thread5 {
    static int count = 0;
    @synchronized (self) {
        count ++;
        if (count < 10) {
            NSLog(@"%d",count);
            [self thread5];
        }
    }
    NSLog(@"finish:%d",count);
}
复制代码
```

`@synchronized` 后面要跟一个 OC 对象，底层会以这个对象对大括号中的代码进行加锁，它实际上是把这个对象当做锁来使用，通过一个哈希表来实现，在 OC 的底层使用了一个互斥锁的数组（可以理解为锁池），通过对象的哈希值来获取对应的互斥锁。所以这其实是一个 OC 层面的锁，主要是通过牺牲性能换来语法上的简洁和可读性。

### 小结

以上的这些 Demo 我放到了 [github](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FJJCrystalForest%2FMultiThreadSync) 中。

### 同步方案的性能

由高到低排序（不绝对，情况不一样性能也有有区别）：

- `OSSpinLock`
- `os_unfair_lock`
- `dispatch_semaphore`
- `pthread_mutex`
- `dispatch_queue(DISPATCH_QUEUE_SERIAL)`
- `NSLock`
- `NSCondition`
- `pthread_mutex(recursive)`
- `NSRecursiveLock`
- `NSConditionLock`
- `@synchronized`

OC 对 `pthread` 的同种类型的锁、信号量的封装出来的对象，性能都不如直接使用 `pthread`，主要是因为 OC 多了一个消息传递的过程。

最后贴一下 YYKit 作者的一个性能比较图：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/11/16b45808b6267cbf~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



## 参考文章

《计算机的心智操作系统之哲学原理（第2版）》

[Linux线程-互斥锁pthread_mutex_t](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fzmxiangde_88%2Farticle%2Fdetails%2F7998458)

[深入理解 GCD](https://link.juejin.cn?target=https%3A%2F%2Fbestswifter.com%2Fdeep-gcd%2F)

[iOS GCD之dispatch_semaphore（信号量）](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fliuyang11908%2Farticle%2Fdetails%2F70757534)

[iOS简单优雅的实现复杂情况下的串行需求(各种锁、GCD 、NSOperationQueue...)](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2FSYH523364%2Farticle%2Fdetails%2F71106625)

[不再安全的 OSSpinLock](https://link.juejin.cn?target=https%3A%2F%2Fblog.ibireme.com%2F2016%2F01%2F16%2Fspinlock_is_unsafe_in_ios%2F)



作者：_Terry
链接：https://juejin.cn/post/6844903863422550024
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。