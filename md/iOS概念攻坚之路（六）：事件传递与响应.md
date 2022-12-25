## 前言

这篇文章主要想弄清楚事件（如触摸屏幕）产生后，系统是如何通知到你的 App，在 App 内部是如何进行传递，最终又是如何确定最终的响应者的。

这些肯定是有规则的，在 App 内部，一个事件会按照一个规则（视图层级关系）去遍历寻找这个事件的最佳响应者，但是这个响应者有可能不处理事件，那么它又需要沿着一定的规则（响应者链）去传递这个事件，如果最终都无人处理，那么将这个事件抛弃，也就是不处理。

## 事件

先来看看什么是事件。

事件对应的对象为 `UIEvent`，它有一个属性为 `type`，是 `EventType` 类型，`EventType` 是一个枚举类型：

```swift
public enum EventType : Int {
    case touches    // 触摸事件
    case motion     // 运动事件
    case remoteControl  // 远程控制事件
    @available(iOS 9.0, *)
    case presses    // 按压事件
}
复制代码
```

所以 iOS 中的事件有四种：

- touch events（触摸事件）
- motion events（运动事件）
- remote-control events（远程控制事件）
- press events（按压事件）

### 1.触摸事件

触摸事件就是我们的手指或者苹果的 Pencil（触笔）在屏幕中所引发的互动，比如轻点、长按、滑动等操作，是我们最常接触到的事件类型。触摸事件对象可以包含一个或多个触摸，并且每个触摸由 `UITouch` 对象表示。当触摸事件发生时，系统会将其沿着线路传递，找到适当的响应者并调用适当的方法，例如 `touchedBegan:withEvent:`。响应者对象会根据触摸来确定适当的方法。

触摸事件分为以下几类：

- 手势事件
  - 长按手势（`UILongPressGestureRecognizer`）
  - 拖动手势（`UIPanGestureRecognizer`）
  - 捏合手势（`UIPinchGestureRecognizer`）
  - 响应屏幕边缘手势（`UIScreenEdgePanGestureRecognizer`）
  - 轻扫手势（`UISwipeGestureRecognizer`）
  - 旋转手势（`UIRotationGestureRecognizer`）
  - 点击手势（`UITapGestureRecognizer`）
- 自定义手势
- 点击 `button` 相关

触摸事件对应的对象为 `UITouch`。

### 2.运动事件

iPhone 内置陀螺仪、加速器和磁力仪，可以感知手机的运动情况。iOS 提供了 `Core Motion` 框架来处理这些运动事件。根据这些内置硬件，运动事件大致分为三类：

- 陀螺仪相关：陀螺仪会测量设备绕 `X-Y-Z` 轴的自转速率、倾斜角度等。通过 `Core Motion` 提供的一些 API 可以获取到这些数据，并进行处理；通过系统可以通过内置陀螺仪获取设备的朝向，以此对 App UI 做出调整
- 加速器相关：设备可以通过内置加速器测量设备在 `X-Y-Z` 轴速度的改变；`Core Motion` 提供了高度计（`CMAltimeter`）、计步器（`CMPedometer`）等对象，来获取处理这些产生的数据
- 磁力仪相关：使用磁力仪可以获取当前设备的磁极、方向、经纬度等数据，这些数据多用于地图导航开发

不过官方文档中指出，这些都是属于 `Core Motion` 库框架，`Core Motion` 库中的事件直接由 `Core Motion` 内部进行处理，不会通过响应者链，所以 `UIKit` 框架能接收的事件暂时只包括摇一摇（`EventSubtype.motionShake`）。

### 3.远程控制事件

远程控制事件允许响应者对象从外部附件或耳机接受命令，以便它可以管理音频和视频。目前 iOS 仅提供我们远程控制音频和视频的权限，即对音频实现暂停/播放、上一曲/下一曲、快进/快退操作。以下是它能识别的类型：

```arduino
public enum EventSubtype : Int {
    case remoteControlPlay
    case remoteControlPause
    case remoteControlStop
    case remoteControlTogglePlayPause
    case remoteControlNextTrack
    case remoteControlPreviousTrack
    case remoteControlBeginSeekingBackward
    case remoteControlEndSeekingBackward
    case remoteControlBeginSeekingForward
    case remoteControlEndSeekingForward
}
复制代码
```

### 4.按压事件

iOS 9.0 之后提供了 3D Touch 事件，通过使用这个功能可以做如下操作：

- Quick Actions：重压 App icon 可以进行很多快捷操作
- Peek and Pop：使用这个功能对文件进行预览和其他操作，可以在手机自带 “信息” 里面试验
- Pressure Sensitivity：压力响应敏感，可以在备忘录中选择画笔，按压不同力度画出来的颜色深浅不一样

## 事件传递到 App 之前

我们一般说的事件传递的起点在于 `UIApplication` 所管理的事件队列中开始分发的时候，但事件真正的起点在于你手指触摸到屏幕的那一刻开始（以触摸事件为例），那么在触摸屏幕到事件队列开始分发发生了什么？我们就以一个触摸事件来说明这个过程。

1. 手指触摸屏幕，`IOKit.framework` 将事件封装成一个 `IOHIDEvent` 对象
2. 将这个对象通过 `mach port`（IPC 进程间通信）转发到 Springboard
3. Springboard 通过 `mach port`（IPC 进程间通信）转发给当前 App 的主线程
4. 前台 App 主线程的 `RunLoop` 接收到 Springboard 转发过来的消息之后，触发对应的 `mach port` 的 `Source1` 回调 `__IOHIDEventSystemClientQueueCallback()`
5. `Source1` 回调内部触发了 `Source0` 的回调 `__UIApplicationHandleEventQueue()`
6. `Source0` 回调内部，封装 `IOHIDEvent` 为 `UIEvent`
7. `Source0` 回调内部调用 `UIApplication` 的 `+sendEvent:` 方法，将 `UIEvent` 传给当前 `UIWindow`

> IOKit.framework 
>  是一个系统框架的集合，用来驱动一些系统事件。`IOHIDEvent` 中的 `HID` 代表 Human Interface Device，即人机交互驱动

> SpringBoard 
>  是一个应用程序，用来管理 iOS 的主屏幕，除此之外像 `WindowServer(窗口服务器)`、`bootstrapping(引导应用程序)`，以及在启动时候系统的一些初始化设置都是由这个特定的应用程序负责的。它是我们 iOS 程序中，事件的第一个接收者。它只能接受少数的事件，比如：按键（锁屏/静音等）、触摸、加速、接近传感器等几种 Event，随后使用 `mach port` 转发给需要的 App 进程

`UIApplication` 管理了一个事件队列，之所以是队列而不是栈，是因为队列的特点是先进先出，先产生的事件先处理。`UIApplication` 会从事件队列中取出最前面的事件，并将事件分发下去以便处理，通常，先发送事件给应用程序的主窗口（`keyWindow`），主窗口会在视图层次结构中找到一个最合适的视图来处理触摸事件，这也是整个处理过程的第一步。

流程图（图1）：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/12/16b4a5f1c445a71b~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



## 事件传递

`UIWindow` 接收到的事件，有的是通过响应者链传递，找到合适的响应者进行处理；有的不需要传递，直接用 `first responder` 来处理。这里我们主要说需要沿着响应者链传递的过程。

事件的传递大致可以分为三个阶段：

1. Hit-Test（寻找合适的 view）
2. Gesture Recognizer（手势识别）
3. Response Chain（响应链，touch 事件传递）

通过手或触笔触摸屏幕所产生的事件，都是通过这三步去传递的，如前面提到的触摸事件和按压事件。

### 1.Hit-Test（寻找合适的 view）

其实这是确定第一响应者的过程，第一响应者也就是作为首先响应此次事件的对象。对于每次事件发生之后，系统会去找能处理这个事件的第一响应者。根据不同的事件类型，第一响应者也不同：

- 触摸事件：被触摸的那个 `view`
- 按压事件：被聚焦按压的那个对象
- 摇晃事件：用户或者 `UIKit` 指定的那个对象
- 远程事件：用户或者 `UIKit` 指定的那个对象
- 菜单编辑事件：用户或者 `UIKit` 指定的那个对象

> 与加速计、陀螺仪、磁力仪相关的运动事件，是不遵循响应链机制传递的。Core Motion 会将事件直接传递给你所指定的第一响应者。

#### 原理

当点击一个 `view`，事件传递到 `UIWindow` 后，会去遍历 `view` 层级，直到找到合适的响应者来处理事件，这个过程也叫做 Hit-Test。

既然是遍历，就会有一定的顺序。系统会根据添加 `view` 的前后顺序，确定 `view` 在 `subviews` 中的顺序，然后根据这个顺序将视图层级转化为图层树，针对这个树，使用倒序、深度遍历的算法，进行遍历。之所以要倒叙，是因为最顶层的 `view` 最有可能成为响应者。

Hit-Test 在代码中对应的方法为：

```swift
func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
// hitTest 内部调用下面这个方法
func point(inside point: CGPoint, with event: UIEvent?) -> Bool
复制代码
```

详细步骤：

1. `keyWindow` 接收到 `UIApplication` 传递过来的事件，首先判断自己能否接受触摸事件，如果能，那么判断触摸点在不在自己身上
2. 如果触摸点在 `keyWindow` 身上，那么 `keyWindow` 会从后往前遍历自己的子控件（为了寻找最合适的 `view`）
3. 遍历的每一个子控件都会重复上面的两个步骤（1.判断子控件是否能接受事件；2.触摸点在不在子控件上）
4. 如此循环遍历子控件，直到找到最合适的 `view`，如果没有更合适的子控件，那么自己就是最合适的 `view`

每当手指接触屏幕，`UIApplication` 接收到手指的事件之后，就会去调用 `UIWindow` 的 `hitTest:withEvent:`，看看当前点击的点是不是在 `window` 内，如果是则继续依次调用 `subView` 的 `hitTest:withEvent:` 方法，直到找到最后需要的 `view`。调用结束并且 `hit-test view` 确定之后，这个 `view` 和 `view` 上面依附的手势，都会和一个 `UITouch` 的对象关联起来，这个 `UITouch` 会作为事件传递的参数之一，我们可以看到 `UITouch` 的头文件中有一个 `view` 和 `gestureRecognizers` 的属性，就是 `hit-test view` 和它的手势。

如下图（图2）：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/12/16b4af4a494e25d0~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



Hit-Test 是采用递归的方法从 `view` 层级的根节点开始遍历，来通过一个例子看一下它是如何工作的（图3）：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/12/16b4ad35d4519290~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



`UIWindow` 有一个 `MainView`，`MainView` 里面有三个 `subView`：`viewA`、`viewB`、`viewC`。它们各自有两个 `subView`，它们的层级关系是：`viewA` 在最下面，`viewB` 在中间，`viewC` 最上（也就是 `addSubview` 的顺序，越晚 `add` 进去越在上面），其中 `viewA` 和 `viewB` 有一部分重叠。

如果手指在 `viewB.1` 和 `viewA.2` 重叠的方面点击，按照上面的递归方式，顺序如下图所示（图4）：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/12/16b4aeb85170bdc5~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



当点击图中位置时，会从 `viewC` 开始遍历，先判断点在不在 `viewC` 上，不在。转向 `viewB`，点在 `viewB` 上。转向 `viewB.2`，判断点在不在 `viewB.2` 上，不在。转向 `viewB.1`，点在 `viewB.1` 上，且 `viewB.1` 没有子视图了，那么 `viewB.1` 就是最合适的 `view`。遍历到这里也就结束了。

#### 实现

来看一下 `hitTest:withEvent:` 的实现原理，`UIWindow` 拿到事件之后，会先将事件传递给图层树中距离最靠近 `UIWindow` 那一层最后一个 `view`，然后调用其 `hitTest:withEvent:` 方法。注意这里是先将视图传递给 `view`，再调用其 `hitTest:withEvent:` 方法，并遵循以下原则：

- 如果 `point` 不在这个视图内，则去遍历其他视图
- 如果 `point` 在这个视图内，但是这个视图还有子视图，那么将事件传递给子视图，并且调用子视图的 `hitTest:withEvent:`
- 如果 `point` 在这个视图内，并且这个视图没有子视图，那么 `return self`，即它就是那个最合适的视图
- 如果 `point` 在这个视图内，并且这个视图没有子视图，但是不想作为处理事件的 `view`，那么可以 `return nil`，事件由父视图处理

另外， `UIView` 有些情况下是不能接受触摸事件的：

- 不允许交互：`userInteractionEnabled = NO`
- 隐藏：如果把父控件隐藏，那么子控件也会隐藏，隐藏的控件不能接受事件
- 透明度：如果设置一个控件的 `alpha < 0.01`，会直接影响子控件的透明度。`alpha` 在 0 到 0.01 之间会被当成透明处理

注：如果父控件不能接受触摸事件，那么子控件就不可能接受到事件。

综上，我们可以得出 `hitTest:withEvent:` 方法的大致实现如下：

```swift
override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    // 是否能响应 touch 事件
    if !isUserInteractionEnabled || isHidden || alpha <= 0.01 { return nil }
    if self.point(inside: point, with: event) {  // 点击是否在 view 内
        for subView in subviews.reversed() {
            // 转坐标
            let convertdPoint = subView.convert(point, from: self)
            // 递归调用，直到有返回值，否则返回 nil
            let hitTestView = subView.hitTest(convertdPoint, with: event)
            if hitTestView != nil {
                return hitTestView!
            }
        }
        return self
    }
    return nil
}
复制代码
```

用一张图来表示 `hitTest:withEvent:` 的调用过程（图是 OC 语法）（图5）：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/12/16b4b234c1768336~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



### 2.Gesture Recognizer（手势识别）

确定了最合适的 `view`，接下来就是识别是何种事件，在触摸事件中，对应的就是何种手势。`Gesture Recognizer`（手势识别器）是系统封装的一些类，用来识别一系列常见的手势，例如点击、长按等。在上一步中确定了合适的 `view` 之后，**`UIWindow` 会将 `touches` 事件先传递给 `Gesture Recognizer`，再传递给视图**。可以自定义一个手势验证一下。

Gesture Recognizer 拥有的状态如下：

```swift
public enum State : Int {
    // 尚未识别是何种手势操作（但可能已经触发了触摸事件），默认状态
    case possible   
    // 手势已经开始，此时已经被识别，但是这个过程中可能发生变化，手势操作尚未完成
    case began
    // 手势状态发生改变
    case changed
    // 手势识别完成（此时已经松开手指）
    case ended
    // 手势被取消，恢复到默认状态
    case cancelled
    // 手势识别失败，恢复到默认状态
    case failed
    // 手势识别完成，同 end
    public static var recognized: UIGestureRecognizer.State { get }
}
复制代码
```

Gesture Recognizer 有一套自己的 `touches` 方法和状态转换机制。一个手势总是以 `possible` 状态开始，表明它已经准备好开始处理事件。从该状态开始，开始识别各种手势，直到它们到达 `ended`、`cancelled` 或 `failed` 状态。手势识别器会保持在其中的一个最终状态，直到当前事件序列结束，此时 UIKit 重置手势识别器并将其返回 `possible` 状态。

再来看看触摸事件的类型：

- 长按手势（`UILongPressGestureRecognizer`）
- 拖动手势（`UIPanGestureRecognizer`）
- 捏合手势（`UIPinchGestureRecognizer`）
- 响应屏幕边缘手势（`UIScreenEdgePanGestureRecognizer`）
- 轻扫手势（`UISwipeGestureRecognizer`）
- 旋转手势（`UIRotationGestureRecognizer`）
- 点击手势（`UITapGestureRecognizer`）

苹果将手势识别器分为两种大类型，一个是离散型手势识别器（Discrete Gesture Recognizer），一个是连续型手势识别器（Continuous Gesture Recognizer）。离散型手势一旦识别就无法取消，而且只会调用一次操作事件，而连续型手势会多次调用操作事件，并且可以取消。在以上手势中，只有点击手势（`UITapGestureRecognizer`）属于离散型手势。

离散型手势识别示意图（图6）：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/13/16b4e82ca1b3f85a~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



连续型手势识别的状态转换一般可分为三个阶段：

1. 初始事件序列将手势识别器移动到 `began` 或 `failed` 状态
2. 后续事件将手势识别器移动到 `changed` 或 `cancelled` 状态
3. 最终事件将手势识别器移动到 `ended` 状态

如下图（图7）：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/13/16b4e86257dc0e05~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



### Response Chain（响应链、touch 事件传递）

识别出手势之后，就要确定由谁来响应这个事件了，最有机会处理事件的对象就是通过 Hit-Test 找到的视图或者第一响应者，如果两个都不能处理，就需要传递给下一位响应者，然后依次传递，该过程与 Hit-Test 过程正好相反。Hit-Test 过程是从上向下（从父视图到子视图）遍历，`touch` 事件处理传递是从下向上（从子视图到父视图）传递。下一位响应者是由响应者链决定的，那我们先来看看什么是响应者链。

Response Chain，响应链，一般我们称之为响应者链。在我们的 app 中，所有的视图都是按照一定的结构组织起来的，即树状层次结构，每个 `view` 都有自己的 `superView`，包括 `controller` 的 `topmost view`(即 `controller` 的 `self.view`)。当一个 `view` 被 `add` 到 `superView` 上的时候，它的 `nextResponder` 属性就会被指向它的 `superView`。当 `controller` 被初始化的时候，`self.view`(`topmost view`) 的 `nextResponder` 会被指向所在的 `controller`，而 `controller` 的 `nextResponder` 会被指向 `self.view` 的 `superView`，这样，整个 app 就通过 `nextResponder` 串成了一条链，这就是我们所说的响应者链。所以响应者链式一条虚拟的链，并没有一个对象来专门存储这样的一条链，而是通过 `UIResponder` 的属性串联起来的。

响应者链示意图（图8）：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/12/16b4ac843171700b~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



即（右图）：

1. 初始视图（`initial view`）尝试处理事件，如果不能处理，则将事件传递给其父视图（`superView1`）
2. `superView1` 尝试处理事件，如果不能处理，传递给它所属的视图控制器（`viewController1`）
3. `viewController1` 尝试处理事件，如果不能处理，传递给 `superView1` 的父视图（`superView2`）
4. `superView2` 尝试处理事件，如果不能处理，传递给 `superView2` 所属的视图控制器（`viewController2`）
5. `viewController2` 尝试处理事件，如果不能处理，传递给 `UIWindow`
6. `UIWindow` 尝试处理事件，如果不能处理，传递给 `UIApplication`
7. `UIApplication` 尝试处理事件，如果不能处理，抛弃该事件

再附一个苹果官方的图（图9）：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/13/16b4ea66ac49e055~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



## UIResponder（响应者）

在 iOS 中，只有继承于 `UIResponder` 的对象、或者它本身才能成为响应者。很多常见的对象都可以相应事件，比如 `UIApplication` 、`UIViewController`、所有的 `UIView`（包括 `UIWindow`）。

`UIResponder` 提供了以下方法来处理事件：

```swift
// 触摸事件
open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
@available(iOS 9.1, *)
open func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>)

// 运动事件
open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
open func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?)

// 远程控制事件
open func remoteControlReceived(with event: UIEvent?)

// 按压事件
open func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?)
复制代码
```

提供以下属性和方法来管理响应链：

```swift
// 负责事件传递，默认返回 nil，子类必须实现此方法。
open var next: UIResponder? { get }
// 判断是否可以成为第一响应者
open var canBecomeFirstResponder: Bool { get } // default is NO
// 将对象设置为第一响应者
open func becomeFirstResponder() -> Bool // default is NO
// 判断是否可以放弃第一响应者
open var canResignFirstResponder: Bool { get } // default is YES
// 放弃对象的第一响应者身份
open func resignFirstResponder() -> Bool // default is YES
// 判断对象是否为第一响应者
open var isFirstResponder: Bool { get }
复制代码
```

补充一下 `next`：`UIResponder` 类并不自动保存或设置下一个响应者，该方法的默认实现是返回 `nil`。子类的实现必须重写这个方法来设置下一响应者。`UIView` 的实现是返回管理它的 `UIViewController` 对象（如果它有）或其父视图；`UIViewController` 的实现是返回它的视图（`self.view`）的父视图；`UIWindow` 的实现是返回 `UIApplication`

另外说一下 `UITouch`，对于触摸事件（对应的对象为 `UITouch`），系统提供了四个方法来处理：

```swift
open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
@available(iOS 9.1, *)
open func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>)
复制代码
```

解释一下 `touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>)`，当无法获取真实的 touches 时，UIKit 会提供一个预估值，并设置到 UITouch 对应的 estimatedProperties 中监测更新。当收到新的属性更新时，会通过调用此方法来传递这些更新值。当使用 Apple Pencil 靠近屏幕边缘时，传感器无法感应到准确的值，此时会获取一个预估值赋给 estimatedProperties 属性。不断去更新数据，直到获取到准确的值。

上面的前四个方法，是由系统自动调用的：

- 默认情况下，当发生一个事件时，`view` 只接收到一个 `UITouch` 对象。当你使用多个手指同时触摸时，会接收多个 `UITouch` 对象，每个手指对应一个。多个手指分开触摸，会调用多次 `touches` 系列方法，每个 `touches` 里面有一个 `UITouch` 对象
- 如果你想处理一些额外的事件，可以重写以上四个方法，处理你想处理的事件。之后不要忘记调用 `super.touchesxxx` 方法，否则事件处理就中断于此，不会继续传递

来看一下 `UITouch` 对象，它保存了事件的相关信息：

```swift
// 触摸事件产生或变化的时间，单位是秒
open var timestamp: TimeInterval { get }
// 当前触摸事件所处的状态
open var phase: UITouch.Phase { get }
// 短时间内点按屏幕的次数
open var tapCount: Int { get }
// 触摸产生时所处的视图
open var view: UIView? { get }
// 触摸产生时所处的窗口
open var window: UIWindow? { get }
// 依附在 view 上的手势
open var gestureRecognizers: [UIGestureRecognizer]? { get }
// 使用硬件设备点击时，以点为圆心的 touch 半径，以此确定 touch 范围的大小
open var majorRadius: CGFloat { get }
// 半径公差
open var majorRadiusTolerance: CGFloat { get }

// 一些方法
/**
返回值表示触摸点在 view 上的位置
调用时传入的 view 参数为 nil 的话，返回的是触摸点在 UIWindow 的位置
*/
open func location(in view: UIView?) -> CGPoint
// 记录了前一个触摸点的位置
open func previousLocation(in view: UIView?) -> CGPoint
复制代码
```

## 实际运用

以几个例子来说明事件传递与响应在项目中的运用，其实运用主要是围绕 `hitTest:withEvent:` 和 `pointInside:` 的使用，这里简单举个例子。

### 1.增加视图的 `touch` 区域

在实际开发中，有些 `button` 面积很小，不容易点击上。这时候你想扩大 `button` 的响应区域，可以通过重写 `hitTest:withEvent:` 方法实现，如下图的情况（图10）：



![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/6/13/16b4fa9db7f5106f~tplv-t2oaga2asx-zoom-in-crop-mark:4536:0:0:0.image)



实现代码：

```swift
class MyButton: UIButton {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isUserInteractionEnabled || isHidden || alpha <= 0.01 { return nil }
        let inset : CGFloat = 45 - 78
        let touchRect = bounds.insetBy(dx: inset, dy: inset)
        if (touchRect.contains(point)) {
            for subView in subviews.reversed() {
                let convertdPoint = subView.convert(point, from: self)
                let hitTestView = subView.hitTest(convertdPoint, with: event)
                if hitTestView != nil {
                    return hitTestView!
                }
            }
            return self
        }
        return nil
    }

}
复制代码
```

或者直接改 `pointIndside` 方法：

```swift
class MyButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: 45-78, dy: 45-78).contains(point)
    }
}
复制代码
```

### 2.摇一摇事件

之前没做过摇一摇，感觉还挺好玩的，就放在这里，其实很简单。

```swift
import UIKit

class ShakeView : UIView {
    
    override var canBecomeFirstResponder: Bool {  // 记得重写这个方法
        return true
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("摇一摇")
        }
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("取消")
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("结束")
        }
    }
    
}

class ViewController: UIViewController {
    
    lazy var shakeView : ShakeView? = {
        let shakeView = ShakeView(frame: view.bounds)
        shakeView.backgroundColor = #colorLiteral(red: 0.08779912442, green: 0.6471169591, blue: 0.9447124004, alpha: 1)
        return shakeView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置支持摇一摇
        UIApplication.shared.applicationSupportsShakeToEdit = true
        
        view.addSubview(shakeView!)
        
        shakeView?.becomeFirstResponder()
        
    }
    
}
复制代码
```

## 总结

来个总结吧。

**iOS 中的事件：**

- 触摸事件
- 运动事件
- 远程控制事件
- 按压事件

**事件从产生到系统传递到 App 的 `keyWindow`：**

1. 手指触摸屏幕，`IOKit.framework` 将事件封装成一个 `IOHIDEvent` 对象
2. 将这个对象通过 `mach port`（IPC 进程间通信）转发到 Springboard
3. Springboard 通过 `mach port`（IPC 进程间通信）转发给当前 App 的主线程
4. 前台 App 主线程的 `RunLoop` 接收到 Springboard 转发过来的消息之后，触发对应的 `mach port` 的 `Source1` 回调 `__IOHIDEventSystemClientQueueCallback()`
5. `Source1` 回调内部触发了 `Source0` 的回调 `__UIApplicationHandleEventQueue()`
6. `Source0` 回调内部，封装 `IOHIDEvent` 为 `UIEvent`
7. `Source0` 回调内部调用 `UIApplication` 的 `+sendEvent:` 方法，将 `UIEvent` 传给当前 `UIWindow`

**事件传递分为三步：**

1. Hit-Test（寻找最合适的 `view`，即第一响应者）
2. Gesture Recognizer（手势识别）
3. Response Chain（响应链，传递 `touch` 事件）

**1.Hit-Test：**

1. `keyWindow` 接收到 `UIApplication` 传递过来的事件，首先判断自己能否接受触摸事件，如果能，那么判断触摸点在不在自己身上
2. 如果触摸点在 `keyWindow` 身上，那么 `keyWindow` 会倒序遍历自己的子控件
3. 遍历的每一个子控件都会重复上面两个操作（1.判断子控件是否能接受事件；2.触摸点在不在子控件上）
4. 如此循环遍历子控件，直到找到最合适的 `view`，如果没有，那么自己就是最合适的 `view`

可以看看图2。

**2.Gesture Recognizer：**

`UIWindow` 会首先将 `touches` 事件传递给 `Gesture Recognizer`，再传递给视图。

触摸事件的具体类型有：

- 长按手势（`UILongPressGestureRecognizer`）
- 拖动手势（`UIPanGestureRecognizer`）
- 捏合手势（`UIPinchGestureRecognizer`）
- 响应屏幕边缘手势（`UIScreenEdgePanGestureRecognizer`）
- 轻扫手势（`UISwipeGestureRecognizer`）
- 旋转手势（`UIRotationGestureRecognizer`）
- 点击手势（`UITapGestureRecognizer`）

苹果又将手势识别器分为两大类型，离散型和连续型，上述类型中只有点击手势（`UITapGestureRecognizer`）属于离散型。

手势识别器拥有的状态：

```swift
public enum State : Int {
    // 尚未识别是何种手势操作（但可能已经触发了触摸事件），默认状态
    case possible   
    // 手势已经开始，此时已经被识别，但是这个过程中可能发生变化，手势操作尚未完成
    case began
    // 手势状态发生改变
    case changed
    // 手势识别完成（此时已经松开手指）
    case ended
    // 手势被取消，恢复到默认状态
    case cancelled
    // 手势识别失败，恢复到默认状态
    case failed
    // 手势识别完成，同 end
    public static var recognized: UIGestureRecognizer.State { get }
}
复制代码
```

**3.Response Chain**

事件沿着响应链传递，传递顺序与寻找第一响应者的顺序正好相反。

传递顺序：

1. 初始视图（`initial view`）尝试处理事件，如果不能处理，则将事件传递给其父视图（`superView1`）
2. `superView1` 尝试处理事件，如果不能处理，传递给它所属的视图控制器（`viewController1`）
3. `viewController1` 尝试处理事件，如果不能处理，传递给 `superView1` 的父视图（`superView2`）
4. `superView2` 尝试处理事件，如果不能处理，传递给 `superView2` 所属的视图控制器（`viewController2`）
5. `viewController2` 尝试处理事件，如果不能处理，传递给 `UIWindow`
6. `UIWindow` 尝试处理事件，如果不能处理，传递给 `UIApplication`
7. `UIApplication` 尝试处理事件，如果不能处理，抛弃该事件

## 参考文章

[iOS 中的事件响应与处理](https://link.juejin.cn?target=https%3A%2F%2Fblog.boolchow.com%2F2018%2F03%2F25%2FiOS-Event-Response%2F)

[深入浅出iOS事件机制](https://link.juejin.cn?target=https%3A%2F%2Fzhoon.github.io%2Fios%2F2015%2F04%2F12%2Fios-event.html)

[你真的了解UIGestureRecognizer吗？](https://link.juejin.cn?target=https%3A%2F%2Fwww.cnblogs.com%2Fwujy%2Fp%2F5821991.html)

[官方文档 About the Gesture Recognizer State Machine](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Fdocumentation%2Fuikit%2Ftouches_presses_and_gestures%2Fimplementing_a_custom_gesture_recognizer%2Fabout_the_gesture_recognizer_state_machine)

[官方文档 Implementing a Discrete Gesture Recognizer](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Fdocumentation%2Fuikit%2Ftouches_presses_and_gestures%2Fimplementing_a_custom_gesture_recognizer%2Fimplementing_a_discrete_gesture_recognizer)

[官方文档 Implementing a Continuous Gesture Recognizer](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Fdocumentation%2Fuikit%2Ftouches_presses_and_gestures%2Fimplementing_a_custom_gesture_recognizer%2Fimplementing_a_continuous_gesture_recognizer)

[官方文档 Using Responders and the Responder Chain to Handle Events](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Fdocumentation%2Fuikit%2Ftouches_presses_and_gestures%2Fusing_responders_and_the_responder_chain_to_handle_events)



作者：_Terry
链接：https://juejin.cn/post/6844903865414844424
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。