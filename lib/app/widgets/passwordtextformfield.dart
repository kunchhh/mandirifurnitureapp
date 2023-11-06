import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  final String name;
  final dynamic validator;
  final dynamic prefixIcon;
  final TextEditingController controller;
  final dynamic onSaved;
  final bool obscureText;
 

  PasswordTextFormField({
    required this.controller,
    required this.onSaved,
    required this.name,
    required this.validator, 
    this.prefixIcon,
    this.obscureText = false,
  });
  @override
  Widget build(BuildContext context) {

   

    return TextFormField(
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: true,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: name, 
        hintStyle: TextStyle(color: Colors.grey[700],),
      ),  
    );
  }
}