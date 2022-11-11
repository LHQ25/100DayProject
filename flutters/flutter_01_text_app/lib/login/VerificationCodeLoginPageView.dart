import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_01_text_app/main.dart';

class VerificationCodeLoginPageView extends StatefulWidget {
  const VerificationCodeLoginPageView({Key? key}) : super(key: key);

  @override
  State<VerificationCodeLoginPageView> createState() =>
      _VerificationCodeLoginPageViewState();
}

class _VerificationCodeLoginPageViewState
    extends State<VerificationCodeLoginPageView> {
  late TextEditingController _userNameEditController;
  late TextEditingController _codeEditController;
  late TapGestureRecognizer _registerTap;
  late MaterialStatesController _codeButtonController;

  @override
  void initState() {
    super.initState();

    _userNameEditController = TextEditingController();
    _codeEditController = TextEditingController();

    _registerTap = TapGestureRecognizer();
    _registerTap.onTap = () {
      Application.router.pop(context);
    };

    _codeButtonController = MaterialStatesController();
    _codeButtonController.addListener(() {
      print("状态改变 ${_codeButtonController.value}");
    });
  }

  @override
  void dispose() {
    super.dispose();

    _userNameEditController.dispose();
    _codeEditController.dispose();
    _registerTap.dispose();
    _codeButtonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
            child: Text(
              "验证码登录",
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
              controller: _codeEditController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(4),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFCCCCCC),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4)),
                      onPressed: () => setState(() {
                        _codeButtonController.update(
                            MaterialState.disabled, true);
                      }),
                      statesController: _codeButtonController,
                      child: const Text(
                        "获取验证码",
                        style:
                            TextStyle(color: Color(0xFF689EFD), fontSize: 12),
                      ),
                    ),
                  ),
                  hintText: "请输入验证码",
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text.rich(TextSpan(
                text: "提示：未注册账号的手机号，请先",
                style: const TextStyle(color: Color(0xFF999999), fontSize: 12),
                children: [
                  TextSpan(
                      text: "注册",
                      style: const TextStyle(
                          color: Color(0xFFFF4759), fontSize: 12),
                      recognizer: _registerTap)
                ])),
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
          )
        ],
      ),
    );
  }
}

extension TextStyleSimple on TextStyle {
  static TextStyle simple({Color c = Colors.red, double s = 16}) {
    return TextStyle(color: c, fontSize: s);
  }
}
