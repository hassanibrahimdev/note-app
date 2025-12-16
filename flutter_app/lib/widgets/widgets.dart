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

}
