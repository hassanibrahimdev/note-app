import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:note_app/database/note.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/pages/notes_pages/add_note_page/add_note_page.dart';
import 'package:note_app/pages/notes_pages/add_note_page/cubit/add_note_cubit.dart';
import 'package:note_app/pages/notes_pages/archived_page.dart';
import 'package:note_app/pages/notes_pages/backup_page.dart';
import 'package:note_app/pages/notes_pages/cubit/backup_cubit.dart';
import 'package:note_app/pages/notes_pages/cubit/note_cubit.dart';
import 'package:note_app/pages/notes_pages/favorites_page.dart';
import 'package:note_app/pages/notes_pages/home_page.dart';
import 'package:note_app/pages/notes_pages/trash_page.dart';
import 'package:note_app/pages/registration_pages/forget_password_page/cubit/forget_password_cubit.dart';
import 'package:note_app/pages/registration_pages/forget_password_page/forget_password_page.dart';
import 'package:note_app/pages/registration_pages/login_page/cubit/login_cubit.dart';
import 'package:note_app/pages/registration_pages/login_page/login_page.dart';
import 'package:note_app/pages/registration_pages/reset_password_page/cubit/reset_password_cubit.dart';
import 'package:note_app/pages/registration_pages/reset_password_page/reset_password_page.dart';
import 'package:note_app/pages/registration_pages/sign_up_page/cubit/sign_up_cubit.dart';
import 'package:note_app/pages/registration_pages/sign_up_page/sign_up_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await deleteNote();
  runApp(const MyApp());
}

Future<void> deleteNote() async {
  List<Note> notes = await NoteDatabase().getAllNotes();
  for (Note note in notes) {
    if (note.isDeleted &&
        note.deletedAt! < DateTime.now().millisecondsSinceEpoch) {
      await NoteDatabase().deleteNotes([note.id]);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => BlocProvider<NoteCubit>(
            create: (BuildContext context) => NoteCubit(),
            child: const HomePage(),
          ),
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
          '/add-note': (context) => BlocProvider<AddNoteCubit>(
            create: (BuildContext context) => AddNoteCubit(),
            child: const AddNotePage(),
          ),
          '/archived': (context) => BlocProvider<NoteCubit>(
            create: (BuildContext context) => NoteCubit(),
            child: const ArchivedPage(),
          ),
          '/favorites': (context) => BlocProvider<NoteCubit>(
            create: (BuildContext context) => NoteCubit(),
            child: const FavoritesPage(),
          ),
          '/trash': (context) => BlocProvider<NoteCubit>(
            create: (BuildContext context) => NoteCubit(),
            child: const TrashPage(),
          ),
          '/backup': (context) => BlocProvider<BackupCubit>(
            create: (BuildContext context) => BackupCubit(),
            child: const BackupPage(),
          ),
        },
      ),
    );
  }
}
