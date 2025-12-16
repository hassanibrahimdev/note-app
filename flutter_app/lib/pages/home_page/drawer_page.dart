import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/device_info.dart';
import 'package:note_app/pages/home_page/cubit/drawer_cubit.dart';
import 'package:note_app/pages/home_page/cubit/drawer_state.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  late final DeviceInfo _deviceInfo = DeviceInfo(context);
  late final DrawerCubit _cubit = context.read<DrawerCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit.checkSignUp();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade400,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade400,
                      child: Center(child: Text("Note App")),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          color: Colors.grey.shade300,
                          minWidth: double.infinity,
                          height: _deviceInfo.height * 0.07,
                          child: Text("Favorites"),
                        ),
                        Divider(
                          color: Colors.black,
                          height: _deviceInfo.height * 0.01,
                          thickness: 2,
                        ),
                        MaterialButton(
                          onPressed: () {},
                          color: Colors.grey.shade300,
                          height: _deviceInfo.height * 0.07,
                          minWidth: double.infinity,
                          child: Text("Archive"),
                        ),
                        Divider(
                          color: Colors.black,
                          height: _deviceInfo.height * 0.01,
                          thickness: 2,
                        ),
                        MaterialButton(
                          onPressed: () {},
                          color: Colors.grey.shade300,
                          height: _deviceInfo.height * 0.07,
                          minWidth: double.infinity,
                          child: Text("Trash"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey,
              width: double.infinity,
              child: BlocBuilder<DrawerCubit, DrawerState>(
                builder: (BuildContext context, DrawerState state) {
                  if (state is DrawerSuccess) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(state.id),
                        Text(state.name),
                        Text(state.email),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/reset-password');
                          },
                          color: Colors.redAccent,
                          child: Text("Reset password"),
                        ),
                        MaterialButton(
                          onPressed: () {
                            _cubit.logOut();
                          },
                          color: Colors.red,
                          child: Text("Logout"),
                        ),MaterialButton(
                          onPressed: () {
                            _cubit.deleteAccount();
                          },
                          color: Colors.red,
                          child: Text("Logout"),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("to backup your notes you need to "),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/sign-up");
                            },
                            child: Text("Sign Up"),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Or if you have account you can"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text("Login"),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
