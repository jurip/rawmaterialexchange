import 'package:flutter/material.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';

class ConfirmationButton extends StatelessWidget {
  const ConfirmationButton({
    Key? key,
    required this.text,
    required this.onTap
  }) : super(key: key);

  final text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: kColorGreen1,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0,),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: kTextStyle3,
          ),
        ),
      ),
    );
  }
}