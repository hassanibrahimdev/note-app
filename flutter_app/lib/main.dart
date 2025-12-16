import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_app/pages/forget_password_page/cubit/forget_password_cubit.dart';
import 'package:note_app/pages/forget_password_page/forget_password_page.dart';
import 'package:note_app/pages/home_page/home_page.dart';
import 'package:note_app/pages/login_page/cubit/login_cubit.dart';
import 'package:note_app/pages/login_page/login_page.dart';
import 'package:note_app/pages/reset_password_page/cubit/reset_password_cubit.dart';
import 'package:note_app/pages/reset_password_page/reset_password_page.dart';
import 'package:note_app/pages/sign_up_page/cubit/sign_up_cubit.dart';
import 'package:note_app/pages/sign_up_page/sign_up_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const HomePage(),
          '/sign-up': (context) => BlocProvider<SignUpCubit>(
            create: (BuildContext context) => SignUpCubit(),
            child: const SignUpPage(),
          ),
          '/login': (context) => BlocProvider<LoginCubit>(
            create: (BuildContext context) => LoginCubit(),
            child: const LoginPage(),
          ),
          '/reset-password': (context) => BlocProvider<ResetPasswordCubit>(
            create: (BuildContext context) => ResetPasswordCubit(),
            child: const ResetPasswordPage(),
          ),
          '/forget-password': (context) => BlocProvider<ForgetPasswordCubit>(
            create: (BuildContext context) => ForgetPasswordCubit(),
            child: const ForgetPasswordPage(),
          ),
        },
      ),
    );
  }
}
