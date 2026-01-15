import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/device_info.dart';
import 'package:note_app/pages/registration_pages/sign_up_page/cubit/sign_up_cubit.dart';
import 'package:note_app/pages/registration_pages/sign_up_page/cubit/sign_up_state.dart';
import 'package:note_app/widgets/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final DeviceInfo _deviceInfo;
  late final SignUpCubit _cubit;
  final Widgets _widgets = Widgets();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _deviceInfo = DeviceInfo(context);
    _cubit = context.read<SignUpCubit>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verifyCodeController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double w8 = _deviceInfo.width * 0.8;
    final double w25 = _deviceInfo.width * 0.25;
    final double h02 = _deviceInfo.height * 0.02;
    final double h03 = _deviceInfo.height * 0.03;
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        if (state is SignUpSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text("Login"),
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: w8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _widgets.textField(
                        'Name',
                        'Enter your name',
                        const Icon(Icons.person),
                        _nameController,
                      ),
                      SizedBox(height: h02),
                      _widgets.textField(
                        'Email',
                        'Enter email',
                        Icon(Icons.email),
                        _emailController,
                      ),
                      SizedBox(height: h02),
                      _widgets.textField(
                        'Password',
                        'Enter password',
                        const Icon(Icons.password),
                        _passwordController,
                      ),
                      SizedBox(height: h02),
                      _widgets.textField(
                        'Confirm password',
                        'Enter confirm password',
                        const Icon(Icons.password),
                        _confirmPasswordController,
                      ),

                      SizedBox(height: h02),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _widgets.textField(
                              'Verify code',
                              'Enter verify code',
                              const Icon(Icons.verified),
                              _verifyCodeController,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: MaterialButton(
                              onPressed: () {
                                _cubit.sendVerificationCode(
                                  _emailController.text,
                                );
                              },
                              color: Colors.lightGreen,
                              height: 50,
                              child: Text("send code"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h03),
                      BlocSelector<SignUpCubit, SignUpState, bool>(
                        selector: (SignUpState state) {
                          if (state is SignUpLoading) {
                            return true;
                          }
                          return false;
                        },
                        builder: (BuildContext context, bool state) {
                          return MaterialButton(
                            onPressed: (state)
                                ? null
                                : () {
                                    _cubit.signUp(
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                      _confirmPasswordController.text,
                                      _verifyCodeController.text,
                                    );
                                  },
                            minWidth: w25,
                            color: Colors.amber,
                            child: Text('Sign up'),
                          );
                        },
                      ),

                      SizedBox(height: h02),
                      BlocBuilder<SignUpCubit, SignUpState>(
                        buildWhen: (previous, current) =>
                            current is SignUpMessage,
                        builder: (BuildContext context, state) {
                          final message = state is SignUpMessage
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
            BlocSelector<SignUpCubit, SignUpState, bool>(
              selector: (SignUpState state) {
                if (state is SignUpLoading) {
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
