import 'package:flutter/material.dart';
import 'package:flutter_state_app/get_state.dart';
import 'package:flutter_state_app/statelessapp.dart';

// void main() {
//   runApp(const StatelessTest(
//     text: "title",
//   ));
// }
// void main() {
//   runApp(const CounterWidget());
// }

void main() {
  runApp(const GetStateTest());
}

class CounterWidget extends StatefulWidget {
  final int initValue;

  const CounterWidget({Key? key, this.initValue = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    print('build');
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            child: Text('$_counter'),
            onPressed: () {
              setState(() {
                ++_counter;
              });
            },
          ),
        ),
      ),
    );
  }

  // State 生命周期
  @override
  void initState() {
    super.initState();
    print('initState');
  }

  @override
  void didUpdateWidget(covariant CounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('didUpdateWidget');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('deactivate');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  @override
  void reassemble() {
    super.reassemble();
    print("reassemble");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }
}

class StateLeftcycleTest extends StatelessWidget {
  const StateLeftcycleTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CounterWidget();
  }
}
