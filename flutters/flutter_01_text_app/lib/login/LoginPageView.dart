import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/fluro_route/Routes.dart';

import '../main.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  var _isObscureText = true;

  late TextEditingController _userNameEditController;

  @override
  void initState() {
    super.initState();

    _userNameEditController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () => Application.router.navigateTo(
                  context, Routes.verificationCodePageView,
                  transition: TransitionType.cupertino),
              child: const Text(
                "验证码登录",
                style: TextStyle(color: Color(0xFF333333), fontSize: 14),
              ))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
            child: Text(
              "密码登录",
              style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 26,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: _userNameEditController,
              style: const TextStyle(color: Color(0xFF333333), fontSize: 14),
              decoration: InputDecoration(
                  hintText: "请输入账号",
                  hintStyle:
                      const TextStyle(color: Color(0xFF999999), fontSize: 14),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(4),
                    child: IconButton(
                        onPressed: () => setState(() {
                              _userNameEditController.clear();
                            }),
                        icon: const ImageIcon(
                          AssetImage("images/login/qyg_shop_icon_delete.png"),
                          size: 20,
                          color: Color(0xFF999999),
                        )),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFEEEEEE),
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: StrokeAlign.outside)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFEEEEEE),
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: StrokeAlign.outside))),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              style: const TextStyle(color: Color(0xFF333333), fontSize: 14),
              obscureText: _isObscureText,
              decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(4),
                    child: IconButton(
                        onPressed: () => setState(() {
                              _isObscureText = !_isObscureText;
                            }),
                        icon: ImageIcon(
                          AssetImage(_isObscureText
                              ? "images/login/qyg_shop_icon_hide.png"
                              : "images/login/qyg_shop_icon_display.png"),
                          size: 20,
                          color: const Color(0xFF999999),
                        )),
                  ),
                  hintText: "请输入密码",
                  hintStyle:
                      const TextStyle(color: Color(0xFF999999), fontSize: 14),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFEEEEEE),
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: StrokeAlign.outside)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFEEEEEE),
                          width: 1,
                          style: BorderStyle.solid,
                          strokeAlign: StrokeAlign.outside))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF96BBFA),
                  foregroundColor: Colors.white),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: const Text(
                  "登录",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: const Text("忘记密码",
                    style: TextStyle(color: Color(0xFF999999), fontSize: 12)),
              )),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 16),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  "还没账号？快去注册",
                  style: TextStyle(color: Color(0xFF4688FA), fontSize: 14),
                ),
              ))
        ],
      ),
    );
  }
}
