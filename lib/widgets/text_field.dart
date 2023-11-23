import 'package:flutter/material.dart';

Widget customTextField(String hint, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    expands: true,
    maxLines: null,
    decoration: InputDecoration(
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      hintText: hint,
    ),
  );
}
