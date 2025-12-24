import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/device_info.dart';
import 'package:note_app/pages/forget_password_page/cubit/forget_password_cubit.dart';
import 'package:note_app/pages/forget_password_page/cubit/forget_password_state.dart';
import 'package:note_app/widgets/widgets.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late final ForgetPasswordCubit _cubit = context.read<ForgetPasswordCubit>();
  late final DeviceInfo _deviceInfo = DeviceInfo(context);
  late final double _height = _deviceInfo.height;
  late final double _width = _deviceInfo.width;
  final Widgets _widgets = Widgets();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forget Password")),
      body: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (BuildContext context, ForgetPasswordState state) {
          if (state is ForgetPasswordSuccess) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        },
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: _width * 0.8,
                  child: Column(
                    children: [
                      _widgets.textField(
                        'Email',
                        'Enter email',
                        Icon(Icons.email),
                        _emailController,
                      ),
                      SizedBox(height: _height * 0.02),
                      _widgets.textField(
                        'Password',
                        'Enter password',
                        Icon(Icons.password),
                        _passwordController,
                      ),
                      SizedBox(height: _height * 0.02),
                      _widgets.textField(
                        'Confirm password',
                        'Enter confirm password',
                        Icon(Icons.password),
                        _confirmPasswordController,
                      ),
                      SizedBox(height: _height * 0.02),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _widgets.textField(
                              'Verify code',
                              'Enter verify code',
                              Icon(Icons.verified),
                              _verifyCodeController,
                            ),
                          ),
                          SizedBox(width: _width * 0.01),
                          Expanded(
                            flex: 1,
                            child: MaterialButton(
                              onPressed: () {
                                _cubit.sendCode(_emailController.text);
                              },
                              height: 50,
                              color: Colors.amberAccent,
                              child: Text("Send code"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: _height * 0.03),
                      BlocSelector<
                        ForgetPasswordCubit,
                        ForgetPasswordState,
                        bool
                      >(
                        selector: (ForgetPasswordState state) {
                          if (state is ForgetPasswordLoading) {
                            return true;
                          }
                          return false;
                        },
                        builder: (BuildContext context, bool state) {
                          return MaterialButton(
                            onPressed: () {
                              _cubit.resetPassword(
                                _emailController.text,
                                _passwordController.text,
                                _confirmPasswordController.text,
                                _verifyCodeController.text,
                              );
                            },
                            color: Colors.amber,
                            child: Text("Reset password"),
                          );
                        },
                      ),
                      SizedBox(height: _height * 0.02),
                      BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                        buildWhen: (previous, current) =>
                            current is ForgetPasswordMessage,
                        builder:
                            (BuildContext context, ForgetPasswordState state) {
                              final message = state is ForgetPasswordMessage
                                  ? state.message
                                  : '';
                              return Text(
                                message,
                                style: TextStyle(color: Colors.red),
                              );
                            },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BlocSelector<ForgetPasswordCubit, ForgetPasswordState, bool>(
              selector: (ForgetPasswordState state) {
                if (state is ForgetPasswordLoading) {
                  return true;
                }
                return false;
              },
              builder: (BuildContext context, bool state) {
                return Visibility(
                  visible: state,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
