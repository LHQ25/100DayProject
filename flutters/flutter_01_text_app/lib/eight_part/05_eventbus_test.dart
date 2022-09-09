import 'package:flutter/material.dart';

class EventBusTest extends StatefulWidget {
  const EventBusTest({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _EventBusTestState();
}

class _EventBusTestState extends State<EventBusTest> {

  int _changeTxt = 0;

  /*
  在 App 中，我们经常会需要一个广播机制，用以跨页面事件通知，比如一个需要登录的 App 中，页面会关注用户登录或注销事件，来进行一些状态更新。
  这时候，一个事件总线便会非常有用，事件总线通常实现了订阅者模式，订阅者模式包含发布者和订阅者两种角色，可以通过事件总线来触发事件和监听事件
   */
  @override
  void initState() {

    bus.on('login', (arg) {
      setState(() {
        _changeTxt = arg;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('EventBus'),
      ),
      body: Column(
        children: [
          Text('_changeTxt $_changeTxt'),
          ElevatedButton(onPressed: (){
            _changeTxt += 1;
            bus.emit('login', _changeTxt);
          }, child: const Text('change'))
        ],
      ),
    );
  }
}


typedef void EventCallBack(arg);

/*
  Dart中实现单例模式的标准做法就是使用static变量+工厂构造函数的方式，这样就可以保证EventBus()始终返回都是同一个实例
 */
class EventBus {
  // 私有构造函数
  EventBus._internal();

  // 保存单例
  static final EventBus _singleton = EventBus._internal();

  // 工厂构造函数
  factory EventBus() => _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _emap = <Object, List<EventCallBack>?>{};

  // 添加订阅者
   void on(eventName, EventCallBack f) {
     _emap[eventName] ??= <EventCallBack>[];
     _emap[eventName]?.add(f);
   }

   // 移除订阅者
  void off(eventName, [EventCallBack? f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  // 触发事件
  void emit(eventName, [arg]){
     var list = _emap[eventName];
     if(list == null) return;
     int len = list.length - 1;
     for (var i = len; i > -1; --i) {
       list[i](arg);
     }
  }
}

//定义一个top-level（全局）变量，页面引入该文件后可以直接使用bus
var bus = EventBus();