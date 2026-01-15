import 'package:flutter/material.dart';

class Widgets {
  TextField textField(
    String label,
    String hint,
    Icon icon,
    TextEditingController controller,
  ) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        labelText: label,
        hintText: hint,
        prefixIcon: icon,
      ),
      controller: controller,
    );
  }

  AlertDialog alert(String message, BuildContext context) {
    return AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"),
        ),
      ],
    );
  }

  Row actionInAppBar(
    VoidCallback cancel,
    VoidCallback moveToTrash,
    VoidCallback archive,
    Icon archiveIcon,
  ) {
    return Row(
      children: [
        IconButton(onPressed: moveToTrash, icon: Icon(Icons.delete_outline)),
        IconButton(onPressed: archive, icon: archiveIcon),

        IconButton(onPressed: () {}, icon: Icon(Icons.backup_outlined)),
        IconButton(
          onPressed: () {
            cancel();
          },
          icon: Icon(Icons.cancel_outlined),
        ),
      ],
    );
  }
}
