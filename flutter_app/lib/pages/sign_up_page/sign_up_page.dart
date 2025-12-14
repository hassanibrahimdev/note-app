import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/device_info.dart';
import 'package:note_app/pages/sign_up_page/cubit/sign_up_cubit.dart';
import 'package:note_app/pages/sign_up_page/cubit/sign_up_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final DeviceInfo _deviceInfo;
  late final SignUpCubit _cubit;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deviceInfo = DeviceInfo(context);
    _cubit = context.read<SignUpCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit,SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        if(state is SignUpSuccess){
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Sign Up")),
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: _deviceInfo.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: _deviceInfo.width * 0.8,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: _nameController,
                    ),
                  ),
                  SizedBox(height: _deviceInfo.height * 0.02),
                  SizedBox(
                    width: _deviceInfo.width * 0.8,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                        labelText: 'Email',
                        hintText: 'Enter email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      controller: _emailController,
                    ),
                  ),
                  SizedBox(height: _deviceInfo.height * 0.02),
                  SizedBox(
                    width: _deviceInfo.width * 0.8,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                        labelText: 'Password',
                        hintText: 'Enter password',
                        prefixIcon: Icon(Icons.password),
                      ),
                      controller: _passwordController,
                    ),
                  ),
                  SizedBox(height: _deviceInfo.height * 0.02),
                  SizedBox(
                    width: _deviceInfo.width * 0.8,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                        labelText: 'Confirm password',
                        hintText: 'Enter confirm password',
                        prefixIcon: Icon(Icons.password),
                      ),
                      controller: _confirmPasswordController,
                    ),
                  ),
                  SizedBox(height: _deviceInfo.height * 0.02),
                  SizedBox(
                    width: _deviceInfo.width * 0.8,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                              ),
                              labelText: 'Verify code',
                              hintText: 'Enter verify code',
                              prefixIcon: Icon(Icons.verified),
                            ),
                            controller: _verifyCodeController,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: MaterialButton(
                            onPressed: () {
                              _cubit.sendVerificationCode(_emailController.text);
                            },
                            color: Colors.lightGreen,
                            height: 50,
                            child: Text(
                              "send code",

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: _deviceInfo.height * 0.03),
                  MaterialButton(
                    onPressed: () {
                      _cubit.signUp(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _confirmPasswordController.text,
                        _verifyCodeController.text,
                      );
                    },
                    minWidth: _deviceInfo.width * 0.25,
                    color: Colors.amber,
                    child: Text(
                      "Sign Up",
                    ),
                  ),
                  SizedBox(height: _deviceInfo.height * 0.02),
                  BlocSelector<SignUpCubit, SignUpState, String>(
                    selector: (SignUpState state) {
                      if (state is SignUpMessage) {
                        return state.message;
                      }
                      return "";
                    },
                    builder: (BuildContext context, String state) {
                      return Text(
                        state,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: _deviceInfo.width * 0.02,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
