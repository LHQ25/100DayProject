import 'package:flutter/material.dart';

class WillPopScopeTest extends StatefulWidget {
  const WillPopScopeTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WillPopScopeTestState();
}

class _WillPopScopeTestState extends State<WillPopScopeTest> {
/* 
为了避免用户误触返回按钮而导致 App 退出，在很多 App 中都拦截了用户点击返回键的按钮，然后进行一些防误触判断，比如当用户在某一个时间段内点击两次时，才会认为用户是要退出（而非误触）。Flutter中可以通过WillPopScope来实现返回按钮拦截
*/

  /// 上次点击时间
  DateTime? _last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('导航返回拦截（WillPopScope）'),
        ),
        body: WillPopScope(
            // onWillPop是一个回调函数，当用户点击返回按钮时被调用（包括导航返回按钮及Android物理返回按钮）。该回调需要返回一个Future对象，如果返回的Future最终值为false时，则当前路由不出栈(不会返回)；最终值为true时，当前路由出栈退出
            onWillPop: (() async {
              if (_last == null ||
                  DateTime.now().difference(_last!) >
                      const Duration(seconds: 1)) {
                //两次点击间隔超过1秒则重新计时
                _last = DateTime.now();
                return false;
              }
              return true;
            }),
            child: Container(
              alignment: Alignment.center,
              child: const Text('1秒内连续点击两次返回键退出'),
            )));
  }
}
