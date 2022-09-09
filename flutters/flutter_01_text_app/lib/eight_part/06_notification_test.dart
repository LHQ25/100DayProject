import 'package:flutter/material.dart';

class NotificationTest extends StatefulWidget {
  const NotificationTest({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationTestState();
}

class _NotificationTestState extends State<NotificationTest> {

  /*
  通知（Notification）是Flutter中一个重要的机制，在widget树中，每一个节点都可以分发通知，通知会沿着当前节点向上传递，
  所有父节点都可以通过NotificationListener来监听通知。Flutter中将这种由子向父的传递通知的机制称为通知冒泡（Notification Bubbling）。
  通知冒泡和用户触摸事件冒泡是相似的，但有一点不同：通知冒泡可以中止，但用户触摸事件不行
   */
  @override
  void initState() {

    /*
    Flutter中很多地方使用了通知，如前面介绍的 Scrollable 组件，
    它在滑动时就会分发滚动通知（ScrollNotification），而 Scrollbar 正是通过监听 ScrollNotification 来确定滚动条位置的
     */
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('EventBus'),
      ),
      body: NotificationListener(
        onNotification: (notification){
          switch (notification.runtimeType){
            case ScrollStartNotification: print("开始滚动"); break;
            case ScrollUpdateNotification: print("正在滚动"); break;
            case ScrollEndNotification: print("滚动停止"); break;
            case OverscrollNotification: print("滚动到边界"); break;
          }
          // 当返回值为true时，阻止冒泡，其父级Widget将再也收不到该通知；当返回值为false 时继续向上冒泡通知
          return true;
        },
        child: ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: Text('$index index'),
          );
        },
        itemCount: 100,
        itemExtent: 30,),
      )
    );
  }
}