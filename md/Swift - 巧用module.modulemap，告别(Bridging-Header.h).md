# 前言 项目背景

项目里面有这么一个需求，在一个App项目中创建多个Static Library，各司其职进行模块与职责划分。

别问为啥没有使用私有库Cocopods进行，反正目前就是为了方便后续各个Static Library，可以随便拖动到其他项目中进行复用。

然后，问题来了。

# 问题：在Static Library无法引用友盟的framework

为了便于说明与演示，我特别创建了一个Demo，通过截图进行讲解。

我有个项目叫做TestUM，里面包含一个SomeSDK，我希望在SomeSDK里面，包含高德地图和友盟统计的功能。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e99f0a1d3176496d8f1b78763f852ec0~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

于是乎，我在Podfile文件中进行了配置：

```ruby
target 'SomeSDK' do

  # Comment the next line if you don't want to use dynamic frameworks

  use_frameworks!

  pod 'AMapSearch', '= 8.1.0'
  pod 'AMapLocation', '= 2.8.0'

  pod 'UMCommon', '~> 1.3.4.P'
  pod 'UMSPM'
  pod 'UMCCommonLog'

end

target 'TestUM' do

  # Comment the next line if you don't want to use dynamic frameworks

  use_frameworks!

  # Pods for TestUM
end
复制代码
```

注意，进行Pod的target是`SomeSDK`而非`TestUM`，**但是实际上`TestUM`也是能引用高德与友盟的库。**

最后，根据友盟集成的文件，需要添加桥接文件进行处理：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/09076dbec0ab4b7bb484fec99856d9a0~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

在TestUM下，我通过`import AMapFoundationKit`，我们可以顺利的调用高德的相关API，因为桥接了友盟，我也可以顺利的调用友盟的相关API：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ce81d920ef62496b8bbd2294d2a7797c~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

然而，在SomeSDK下，因为可以`import AMapFoundationKit`，我依旧可以调用高德，但是友盟却怎么也点不出来了：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/022bed40c9344f1784d7befddb4560cb~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

我尝试在SomeSDK也创建一个类似主工程中`Bridging-Header.h`的文件，对友盟进行桥接，然而得到的却是编译错误`using bridging headers with framework targets is unsupported`。

不支持，这条路被堵死了。

如果桥接行不通，SomeSDK就无法使用友盟统计的功能，只能将其相关业务移植到主工程去，这明显不符合公司要求。

![4f9dd5d4aba06d291d7b1e4d05683724.jpeg](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3236cbe12a0b4f2daafd4ee020e3496b~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

> 领导就一句话：高德可以，友盟为什么不行？

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f41a66d9adc449da92295347f55ecf8b~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

现在回头看看，为何**高德地图的既可以在TestUM又可以在SomeSDK中进行引用——因为它能在工程中的`\*.swift`文件中进行`import`。**

而友盟在通过`TestUM-Bridging-Header.h`文件进行桥接后，在`TestUM`主工程的`.swift`文件中，无需import，直接调用即可，**但是在`SomeSDK`的子工程中无法调用。**

**高德与友盟的架包到底有何差异？🤔🤔🤔**

# AMapFoundationKit.framework与UMCommon.framework对比

其实高德与友盟的Pod引用还是非常相似的，因为都是封装的静态库，Pod集成的都是非开源的.framework架包。

这里我们将AMapFoundationKit.framework与UMCommon.framework做一下对比：

| 高德                                                         | 友盟                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/49c97420326e440c8030ed7a174595ca~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?) | ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/35112d12f0894350ac76b0c46350e250~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?) |
| ![Snip20220905_6.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/94c4ac66755a44a899cef384c31c70bc~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?) | ![Snip20220905_6.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/94c4ac66755a44a899cef384c31c70bc~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?) |
| ![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/30bc2deebaa147eea47fdb915d468d0c~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?) | ![Snip20220824_21.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a996e2e5a5134053b307496869b1940e~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?) |

1. 通过Xcode展开工程看，Pod中，`AMapFoundationKit.framework`不仅展示了Frameworks文件夹，同时暴露的.h文件也显示了，而`UMCommon.framework`没有显示.h文件。
2. 通过`AMapFoundationKit.podspec.json`与`UMCommon.podspec.json`，我们会发现虽然两者都是`.framework`的pod集成方式，但是在配置参数的差异方式决定了显示不同。
3. 看.framework的文件结构，**很明显的发现`AMapFoundationKit.framework`比`UMCommon.framework`多一个Module文件夹！**

就让我们看看，这个Module文件夹下面吧。

里面就只有一个`module.modulemap`文件，里面长这样：

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/43cc67a6b32e4ebabf1c91e473a6d555~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

**关于`umbrella header`大家可以看看参考文档[What is an umbrella header?](https://link.juejin.cn?target=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F31238761%2Fwhat-is-an-umbrella-header)，它的功能就是将`AMapFoundationKit.h`里面暴露的`.h`文件，通过循环都暴露出来。**

`AMapFoundationKit.h`里面长这样： ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e427107f4a974582bffc0620b058c8f9~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

回想一下，我们可以在`*.swift`文件中可以`import AMapFoundationKit`是不是因为有`module.modulemap`中的配置缘故？

带着这个问题，我去搜索了一下`module.modulemap`的相关资料。

在一篇文章中我找到相关的信息与灵感：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/920c6c76d58a4a05b6afdc14bfba3e35~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

> As **Bridging-Header** can help us in **App Target** and **App Test Target**, **not in static library or dynamic libraries** to use the Objective C / C APIs into Swift classes, **modulemap** can help us here.

**通过理解，Pod这种`.framework`的静态库，在主工程的应用可以通过桥接解决，而在主工程的的static library则需要通过modulemap来进行解决。**

# 为UMCommon.framework手搓一个`module.modulemap`

本着死马当活马医的想法，我想为UMCommon.framework手搓一个`module.modulemap`。

首先我特地看了一下UMCommon.framework中Headers里面的文件：

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f0a1ea2938ed4d7fa0b2fc87c6505149~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

抱着试一试的态度，我新建了Modules一个文件夹，并写了这样一个文件，**注意我并没添加所有的.h文件,只是为了方便测试。**

```arduino
framework module UMCommon {

   header "MobClick.h"

   header "UMConfigure.h"

   header "UMCommon.h"
   
   export *

}
复制代码
```

然后将其放到对应的UMCommon.framework。

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/06eb4858e0984981861833737dd79dcc~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

见证结果的时刻来了，编译，试着import，成功了！

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/758010c3e50c48d0a5eb8a179347c676~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

我们甚至可以，点击看看这个`import UMCommon`。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/91caafe82fa6479f9541c3b5f007f4ef~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.image?)

`MobClick`类已经完美通过Swift表示了。

而且此时，我们可以把主工程里面的`Bridging-Header.h`里面桥接文件注释掉（甚至将这个`.h`文件删除），在`*.swift`中`import`对应的类，即可成功引入与调用！

# 总结

- 将Pod中的某些需要桥接的库，通过手搓一个`module.modulemap`，我们完全有能力**抹去桥接操作**，但是同时这样有一个问题，一旦Pod的库，升级或者文件进行了变更，自行写的`module.modulemap`可能也需要更改。

  而且更改Pod下的库的文件，也不太符合操作规则。

  另外，大家可以尝试把`AlipaySDK.framework`通过这种方式去除桥接试试，原理都是一样的，就当练手。

- 还有一种方式就是自己创建一个私有的Spec，自己添加`module.modulemap`后，进行pod库管理，但是这样还是避免不了上游更新，私有库也要同步更新的问题。

**最好的Pod集成方式，就像高德的库，官方将`podspec`配置好，使用者直接傻瓜`pod install`就好了。**

# 参考文档

[What is an umbrella header?](https://link.juejin.cn?target=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F31238761%2Fwhat-is-an-umbrella-header)

[Swift Objective C interoperability, Static Libraries, Modulemap etc…](https://link.juejin.cn?target=https%3A%2F%2Fmedium.com%2F@mail2ashislaha%2Fswift-objective-c-interoperability-static-libraries-modulemap-etc-39caa77ce1fc)

# 自己写的项目，欢迎大家star⭐️

[RxStudy](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FseasonZhu%2FRxStudy)：RxSwift/RxCocoa框架，MVVM模式编写wanandroid客户端。

[GetXStudy](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2FseasonZhu%2FGetXStudy)：使用GetX，重构了Flutter wanandroid客户端。



作者：season_zhu
链接：https://juejin.cn/post/7139724115157450765
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。