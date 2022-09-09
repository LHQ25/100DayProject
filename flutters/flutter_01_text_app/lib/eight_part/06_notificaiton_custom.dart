import 'package:flutter/material.dart';

class NotificationCustomTest extends StatefulWidget {
  const NotificationCustomTest({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationCustomTestState();
}

class _NotificationCustomTestState extends State<NotificationCustomTest> {

  String _msg = '';
  @override
  void initState() {

    /*
    除了 Flutter 内部通知，我们也可以自定义通知
     */
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('EventBus'),
        ),
        body: NotificationListener<MyNotification>(
          onNotification: (notification){
            setState(() {
              _msg += notification.msg+'  ';
            });
            return true;
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(builder: (context){
                  return ElevatedButton(onPressed: (){
                    MyNotification('hi').dispatch(context);
                  }, child: const Text('Send Notification'));
                }),
                Text('$_msg')
              ],
            ),
          )
        )
    );
  }
}

class MyNotification extends Notification {

  MyNotification(this.msg);
  final String msg;

  /*
  分发通知。

  Notification有一个dispatch(context)方法，它是用于分发通知的，
  我们说过context实际上就是操作Element的一个接口，它与Element树上的节点是对应的，通知会从context对应的Element节点向上冒泡
   */
}