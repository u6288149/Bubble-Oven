import 'package:flutter/material.dart';
import '../components/colors.dart';

class AuthButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const AuthButton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell( //While GestureDetector provides more controls like dragging, InkWell offers ripple effect tap in which we want
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 50),
        decoration: const BoxDecoration(
            color: AppColors.rosevale,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.whiteshade
            ),
          ),
        ),
      ),
    );
  }
}
