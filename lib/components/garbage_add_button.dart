import 'package:app/constants/style_constants.dart';
import 'package:flutter/material.dart';

class GarbageAddButton extends StatelessWidget {
  const GarbageAddButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  final text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(width: 1.0, color: Color(0xFFBEBEBE)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 14.0,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: kTextStyle2,
          ),
        ),
      ),
    );
  }
}
