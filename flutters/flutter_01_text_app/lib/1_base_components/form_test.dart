import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTest extends StatefulWidget {
  const FormTest({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FormTestState();
}

class _FormTestState extends State<FormTest> {
  final _unameController = TextEditingController();
  final _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  /* 
    实际业务中，在正式向服务器提交数据前，都会对各个输入框数据进行合法性校验，但是对每一个TextField都分别进行校验将会是一件很麻烦的事。还有，如果用户想清除一组TextField的内容，除了一个一个清除有没有什么更好的办法呢？为此，Flutter提供了一个Form 组件，它可以对输入框进行分组，然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存
  */
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('表单 Form'),
      ),
      body: Column(children: [
        Form(
            key: _formKey,
            // 是否自动校验输入内容；当为true时，每一个子 FormField 内容发生变化时都会自动校验合法性，并直接显示错误信息。否则，需要通过调用FormState.validate()来手动校验
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // 决定Form所在的路由是否可以直接返回（如点击返回按钮），该回调返回一个Future对象，如果 Future 的最终结果是false，则当前路由不会返回；如果为true，则会返回到上一个路由。此属性通常用于拦截返回按钮
            onWillPop: null,
            onChanged: () {
              print("改变");
            },
            // Form的子孙元素必须是FormField类型，FormField是一个抽象类
            // 为了方便使用，Flutter 提供了一个TextFormField组件，它继承自FormField类，也是TextField的一个包装类，所以除了FormField定义的属性之外，它还包括TextField的属性
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: _unameController,
                  decoration: const InputDecoration(
                    labelText: '用户名',
                    hintText: '用户名或邮箱',
                    icon: Icon(Icons.person),
                  ),
                  // 校验用户名
                  validator: (value) {
                    return value!.trim().isNotEmpty ? null : '用户名不能为空';
                  },
                ),
                TextFormField(
                  autofocus: true,
                  obscureText: true,
                  controller: _pwdController,
                  decoration: const InputDecoration(
                    labelText: '密码',
                    hintText: '登录密码',
                    icon: Icon(Icons.lock),
                  ),
                  //校验密码
                  validator: (value) {
                    return value!.trim().length > 5 ? null : '用户名不能为空';
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              // 通过_formKey.currentState 获取FormState后，
                              // 调用validate()方法校验用户名密码是否合法，校验
                              // 通过后再提交数据。
                              if ((_formKey.currentState as FormState)
                                  .validate()) {
                                print('提交数据');
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('登录'),
                            )),
                      ),
                      //注意，登录按钮的onPressed方法中不能通过Form.of(context)来获取FormState，原因是，此处的context为FormTestRoute的context，而Form.of(context)是根据所指定context向根去查找，而FormState是在FormTestRoute的子树中，所以不行。正确的做法是通过Builder来构建登录按钮，Builder会将widget节点的context作为回调参数
                      Expanded(child: Builder(builder: (ctx) {
                        return ElevatedButton(
                            onPressed: () {
                              //由于本widget也是Form的子代widget，所以可以通过下面方式获取FormState

                              // 其实context正是操作Widget所对应的Element的一个接口，由于Widget树对应的Element都是不同的，所以context也都是不同的。Flutter中有很多“of(context)”这种方法，在使用时一定要注意context是否正确
                              if (Form.of(ctx)!.validate()) {
                                print('提交数据');
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('登录'),
                            ));
                      }))
                    ],
                  ),
                )
              ],
            ))
      ]),
    );
  }
}
