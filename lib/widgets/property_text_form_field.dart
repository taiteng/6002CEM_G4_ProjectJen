import 'package:flutter/material.dart';

class PropertyTextFormField extends StatelessWidget {
  final controller;
  final String hintText;
  final String emptyText;

  const PropertyTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return emptyText;
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),),
      ),
    );
  }
}