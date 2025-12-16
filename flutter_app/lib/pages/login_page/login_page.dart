import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/device_info.dart';
import 'package:note_app/pages/login_page/cubit/login_cubit.dart';
import 'package:note_app/pages/login_page/cubit/login_state.dart';
import 'package:note_app/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Widgets _widgets = Widgets();
  late final DeviceInfo _deviceInfo;
  late final LoginCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deviceInfo = DeviceInfo(context);
    _cubit = context.read<LoginCubit>();
  }

  @override
  Widget build(BuildContext context) {
    double height = _deviceInfo.height;
    double width = _deviceInfo.width;
    return BlocListener<LoginCubit, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/sign-up');
              },
              child: Text("Sign up"),
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _widgets.textField(
                        'Email',
                        'Enter email',
                        Icon(Icons.email),
                        _emailController,
                      ),
                      SizedBox(height: height * 0.02),
                      _widgets.textField(
                        'Password',
                        'Enter password',
                        Icon(Icons.password),
                        _passwordController,
                      ),
                      SizedBox(height: height * 0.03),
                      BlocSelector<LoginCubit, LoginState, bool>(
                        selector: (LoginState state) {
                          if (state is LoginLoading) {
                            return true;
                          }
                          return false;
                        },
                        builder: (BuildContext context, bool state) {
                          return MaterialButton(
                            onPressed: (state)
                                ? null
                                : () {
                                    _cubit.login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  },
                            minWidth: width * 0.25,
                            color: Colors.amber,
                            child: Text('Login'),
                          );
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      BlocBuilder<LoginCubit, LoginState>(
                        buildWhen: (previous, current) =>
                            current is LoginMessage,
                        builder: (BuildContext context, LoginState state) {
                          final message = state is LoginMessage
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
            BlocSelector<LoginCubit, LoginState, bool>(
              selector: (LoginState state) {
                if (state is LoginLoading) {
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
