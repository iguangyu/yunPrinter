import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printer/Constants/constants.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:printer/bloc/printer_bloc.dart';


TextEditingController _textEditingController = TextEditingController();


class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _textEditingController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (username) {},
              decoration: const InputDecoration(
                hintText: "用户名",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          //   child: TextFormField(
          //     textInputAction: TextInputAction.done,
          //     obscureText: true,
          //     cursorColor: kPrimaryColor,
          //     decoration: const InputDecoration(
          //       hintText: "Your password",
          //       prefixIcon: Padding(
          //         padding: const EdgeInsets.all(defaultPadding),
          //         child: Icon(Icons.lock),
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () => _loginClick(context),
              child: const Text(
                "进入",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }

  void _loginClick(BuildContext context){
    if (_textEditingController.text.isEmpty){
      BotToast.showText(text: "请输入用户名");
      return;
    } 
    String username = _textEditingController.text;
    // 改变登录状态
    context.read<PrinterBloc>().add(userLogin(userName: username));
    print("==============");
    print(context.read<PrinterBloc>().state.isLogged);
    print(context.read<PrinterBloc>().state.userName);
    Navigator.pushNamed(context, "/myHomePage");
  }
}
