import 'package:flutter/material.dart';
import 'colors.dart';

class CustomizedFormField extends StatelessWidget {
  final TextEditingController controller; //is basically what we use to access what the user types in
  final String hintText;
  final bool obsecureText;
  final Widget suffixIcon;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final int maxLines;

  const CustomizedFormField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.obsecureText,
      required this.suffixIcon,
      required this.textInputType,
      required this.textInputAction,
      required this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container( //TextField
          margin: const EdgeInsets.only(left: 30, right: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            obscureText: obsecureText,
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 201, 201, 201)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.rosetaupe),
                ),
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.hintText, fontSize: 14, fontWeight: FontWeight.w500
                ),
                border: InputBorder.none,
                suffixIcon: suffixIcon
            ),
          ),
        )
      ],
    );
  }
}
