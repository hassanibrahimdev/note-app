import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/device_info.dart';
import 'package:note_app/pages/home_page/cubit/drawer_cubit.dart';
import 'package:note_app/pages/home_page/drawer_page.dart';
import 'package:note_app/pages/note_page/note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final DeviceInfo _deviceInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deviceInfo = DeviceInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BlocProvider<DrawerCubit>(
        create: (BuildContext context) => DrawerCubit(),
        child: DrawerPage(),
      ),
      appBar: AppBar(title: Text("Notes"), centerTitle: true),
      body: const NotePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
