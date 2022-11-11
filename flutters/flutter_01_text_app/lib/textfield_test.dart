import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldTest extends StatefulWidget {
  const TextFieldTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TextFieldTestState();
}

class _TextFieldTestState extends State<TextFieldTest> {
  final _textFieldController =
      TextEditingController(text: "_textFieldController");
  final _textSelectionControls = MaterialTextSelectionControls();
  final _scrollController = ScrollController();

  final _passFieldController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _pwdFocusNode = FocusNode();

  String name = '', pwd = '';
  late FocusScopeNode focusScopeNode;

  @override
  void initState() {
    super.initState();

    // 观察输入和选择操作
    _textFieldController.text = 'hello world'; // 默认值

    // 第三个字符开始选中后面的字符
    _textFieldController.selection = TextSelection(
        baseOffset: 2, extentOffset: _textFieldController.text.length);

    _textFieldController.addListener(() {
      print("_textFieldController ->");
    });

    _scrollController.addListener(() {
      print("滚动 ${_scrollController.offset}");
    });

    // 监听文本变化, onChanged是专门用于监听文本变化，而controller的功能却多一些，除了能监听文本变化外，它还可以设置默认值、选择文本
    _passFieldController.addListener(() {
      pwd = _passFieldController.text;
    });

    // 监听焦点状态改变事件
    // FocusNode继承自ChangeNotifier，通过FocusNode可以监听焦点的改变事件
    _nameFocusNode.addListener(() {
      print(
          "焦点改变 ${_nameFocusNode.hasFocus}, 焦点时focusNode.hasFocus值为true，失去焦点时为false");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(
          hintColor: Colors.grey[200], //定义下划线颜色
          inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.grey), //定义label字体样式
              hintStyle:
                  TextStyle(color: Colors.grey, fontSize: 14.0) //定义提示文本样式
              )),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('输入框及表单'),
        ),
        body: Column(
          children: [
            Column(
              children: [
                TextField(
                  controller:
                      _textFieldController, // 编辑框的控制器，通过它可以设置/获取编辑框的内容、选择编辑内容、监听编辑文本改变事件
                  focusNode:
                      FocusNode(), //控制TextField是否占有当前键盘的输入焦点。它是我们和键盘交互的一个句柄（handle
                  decoration: const InputDecoration(
                      hintText:
                          'InputDecoration'), //控制TextField的外观显示，如提示文本、背景颜色、边框等。
                  keyboardType: TextInputType.name, // 键盘输入类型
                  textInputAction:
                      TextInputAction.done, //键盘动作按钮图标(即回车键位图标)，它是一个枚举值
                  textCapitalization:
                      TextCapitalization.none, // 配置平台键盘如何选择大写或小写键盘
                  style: const TextStyle(color: Colors.black), //正在编辑的文本样式。
                  // strutStyle: StrutStyle(), // 用于垂直布局的支柱样式。
                  textAlign: TextAlign.start, // 文本对齐
                  textAlignVertical: TextAlignVertical.top, //竖直方向对齐方式
                  textDirection: TextDirection.ltr, // 书写方向
                  readOnly: false, // 只读
                  toolbarOptions: const ToolbarOptions(
                      copy:
                          true), // 长按或鼠标右击时出现的菜单，包括 copy、cut、paste 以及 selectAll。
                  showCursor: true, //是否显示光标。
                  cursorColor: Colors.red, // 光标颜色
                  cursorHeight: 12, // 光标高度
                  cursorWidth: 2, // 光标宽度
                  cursorRadius: const Radius.circular(1), // 光标圆角
                  autofocus: true, //是否自动获取焦点。
                  obscuringCharacter: '·', // 如果 [obscureText] 为真，则用于隐藏文本的字符。
                  obscureText: false, // 是否隐藏正在编辑的文本，如用于输入密码的场景等，文本内容会用“•”替换。
                  autocorrect: true, // 是否开启自动更正
                  // smartDashesType: SmartDashesType.disabled,
                  // smartQuotesType: SmartQuotesType.disabled,
                  enableSuggestions: true, // 启用建议
                  maxLines: 4,
                  minLines: 1,
                  expands: false, // 此小部件的高度是否将调整大小以填充其父级。
                  maxLength: 100, // 最多输入字符
                  maxLengthEnforcement:
                      MaxLengthEnforcement.enforced, // 确定应如何实施 [maxLength] 限制。
                  onChanged: (value) => print(value),
                  onEditingComplete: () => print("编辑完成"),
                  onSubmitted: (value) => print("提交 $value"),
                  onAppPrivateCommand: (p0, p1) =>
                      print("这用于从输入法接收私有命令 $p0, $p1"), // 这用于从输入法接收私有命令。
                  // inputFormatters: [FilteringTextInputFormatter('', allow: false)],  // 用于格式验证
                  enabled:
                      true, // 如果为false，则输入框会被禁用，禁用状态不接收输入和事件，同时显示禁用态样式（在其decoration中定义）

                  selectionHeightStyle: BoxHeightStyle.tight, // 控制计算选择高亮框的高度
                  selectionWidthStyle: BoxWidthStyle.tight, // 控制计算选择高亮框的宽度。
                  keyboardAppearance: Brightness.light, // 键盘外观。此设置仅适用于 iOS 设备
                  scrollPadding: const EdgeInsets.all(
                      20), // 当 Textfield 滚动到视图中时，为 [Scrollable] 周围的边缘配置填充。
                  dragStartBehavior: DragStartBehavior.start, //确定处理拖动开始行为的方式
                  enableInteractiveSelection: true,
                  selectionControls:
                      _textSelectionControls, // 用于构建文本选择句柄和工具栏的可选委托。
                  onTap: () => print("点击"),
                  mouseCursor: MouseCursor.uncontrolled, // 鼠标指针进入或悬停在小部件上时的光标。
                  // buildCounter:
                  //     (context, {currentLength, isFocused, maxLength}) => {},
                  scrollController: _scrollController, // 滚动控制
                  //scrollPhysics: null, // 垂直滚动输入时使用的 [ScrollPhysics]。如果未指定，它将根据当前平台运行。
                  // autofillHints: , //帮助自动填充服务识别此文本输入类型的字符串列表。
                  clipBehavior: Clip.hardEdge, // 内容将根据此选项被剪裁（或不剪裁）。
                  // restorationId: , // 恢复 ID 用于保存和恢复文本字段的状态。
                  scribbleEnabled: true, //是否为此小部件启用 iOS 14 Scribble 功能。
                  enableIMEPersonalizedLearning:
                      true, // 是否启用 IME 更新个性化数据，例如输入历史和用户字典数据。
                ),
                const Text("示例"),
                Column(
                  children: [
                    TextField(
                      autofocus: false,
                      focusNode: _nameFocusNode,
                      decoration: const InputDecoration(
                          labelText: '用户名',
                          hintText: '用户名或邮箱',
                          prefixIcon: Icon(Icons.person)),
                      onChanged: (value) {
                        // 获取输入内容, 监听文本变化
                        name = value;
                        print('变化 $value');
                      },
                    ),
                    TextField(
                      autofocus: true,
                      obscureText: true,
                      focusNode: _pwdFocusNode,
                      controller:
                          _passFieldController, // 获取输入内容, 通过 controller.text 获取输入框内容
                      onTap: () {
                        print("密码 $pwd");
                      },
                      decoration: const InputDecoration(
                          labelText: '密码',
                          hintText: '登录密码',
                          prefixIcon: Icon(Icons.person)),
                    ),
                    const Text("控制焦点"),
                    // 焦点可以通过FocusNode和FocusScopeNode来控制，默认情况下，焦点由FocusScope来管理，它代表焦点控制范围，可以在这个范围内可以通过FocusScopeNode在输入框之间移动焦点、设置默认焦点等。我们可以通过FocusScope.of(context) 来获取Widget树中默认的FocusScopeNode
                    Builder(builder: (ctx) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                //将焦点从第一个TextField移到第二个TextField
                                // 这是一种写法
                                // FocusScope.of(context).requestFocus(_pwdFocusNode);
                                // 这是第二种写法
                                focusScopeNode = FocusScope.of(context);
                                focusScopeNode.requestFocus(_pwdFocusNode);
                              },
                              child: const Text('移动焦点')),
                          OutlinedButton(
                              onPressed: () {
                                // 当所有编辑框都失去焦点时键盘就会收起
                                _nameFocusNode.unfocus();
                                _pwdFocusNode.unfocus();
                              },
                              child: const Text('隐藏键盘'))
                        ],
                      );
                    }),
                    const Text("自定义样式"),
                    // 通过decoration属性来定义输入框样式
                    const TextField(
                      decoration: InputDecoration(
                          labelText: '输入',
                          prefixStyle: TextStyle(color: Colors.red),
                          prefixIcon: Icon(Icons.person),
                          // 未获得焦点下划线设为灰色
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          //获得焦点下划线设为蓝色
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue))),
                    ),
                    const Text(
                        '通过主题来自定义输入框的样式，下面我们探索一下如何在不使用enabledBorder和focusedBorder的情况下来自定义下滑线颜色'),
                    // 由于TextField在绘制下划线时使用的颜色是主题色里面的hintColor，但提示文本颜色也是用的hintColor， 如果我们直接修改hintColor，那么下划线和提示文本的颜色都会变。值得高兴的是decoration中可以设置hintStyle，它可以覆盖hintColor，并且主题中可以通过inputDecorationTheme来设置输入框默认的decoration。所以我们可以通过主题来自定义
                    const TextField(
                        decoration: InputDecoration(
                            labelText: '输入2',
                            hintText: '提升2',
                            prefixIcon: Icon(Icons.person))),
                    const TextField(
                        decoration: InputDecoration(
                            labelText: '输入3',
                            prefixIcon: Icon(Icons.person),
                            hintText: '提示3',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 13.0))),
                    // 成功的自定义了下划线颜色和提问文字样式，通过这种方式自定义后，输入框在获取焦点时，labelText不会高亮显示了，正如上图中的"用户名"本应该显示蓝色，但现在却显示为灰色，并且我们还是无法定义下划线宽度。
                    // 另一种灵活的方式是直接隐藏掉TextField本身的下划线，然后通过Container去嵌套定义样式

                    // 通过这种组件组合的方式，也可以定义背景圆角等。一般来说，优先通过decoration来自定义样式，如果decoration实现不了，再用widget组合的方式
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.red, width: 1))),
                      child: const TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'email',
                            hintText: 'email',
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                            border: InputBorder.none), //隐藏下划线
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
