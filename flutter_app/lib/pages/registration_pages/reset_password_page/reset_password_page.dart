import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/device_info.dart';
import 'package:note_app/pages/registration_pages/reset_password_page/cubit/reset_password_cubit.dart';
import 'package:note_app/pages/registration_pages/reset_password_page/cubit/reset_password_state.dart';
import 'package:note_app/widgets/widgets.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final DeviceInfo _deviceInfo = DeviceInfo(context);
  late final ResetPasswordCubit _cubit = context.read<ResetPasswordCubit>();
  late double height = _deviceInfo.height;
  late double width = _deviceInfo.width;
  final Widgets _widgets = Widgets();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (BuildContext context, ResetPasswordState state) {
        if (state is ResetPasswordSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Reset password")),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _widgets.textField(
                        'Password',
                        'Enter password',
                        Icon(Icons.password),
                        _passwordController,
                      ),
                      SizedBox(height: height * 0.02),
                      _widgets.textField(
                        'Confirm password',
                        'Enter confirm password',
                        Icon(Icons.password),
                        _confirmPasswordController,
                      ),
                      SizedBox(height: height * 0.02),
                      BlocSelector<
                        ResetPasswordCubit,
                        ResetPasswordState,
                        bool
                      >(
                        selector: (ResetPasswordState state) {
                          if (state is ResetPasswordLoading) {
                            return true;
                          }
                          return false;
                        },
                        builder: (BuildContext context, bool state) {
                          return MaterialButton(
                            onPressed: (state)
                                ? null
                                : () {
                                    _cubit.resetPassword(
                                      _passwordController.text,
                                      _confirmPasswordController.text,
                                    );
                                  },
                            child: Text('Reset password'),
                          );
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                        buildWhen: (previous, current) =>
                            current is ResetPasswordMessage,
                        builder:
                            (BuildContext context, ResetPasswordState state) {
                              String message = (state is ResetPasswordMessage)
                                  ? state.message
                                  : "";
                              return Text(message);
                            },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BlocSelector<ResetPasswordCubit, ResetPasswordState, bool>(
              selector: (ResetPasswordState state) {
                if (state is ResetPasswordLoading) {
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
