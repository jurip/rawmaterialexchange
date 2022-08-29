import 'package:flutter/material.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';

class ButtonSecondary extends StatelessWidget {
  const ButtonSecondary({
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
          borderRadius: BorderRadius.circular(15.0),
          color: kColorGrey1,
          border: Border.all()
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0,),
          child: Row(children: [Text(
            "-",
            textAlign: TextAlign.start,
            style: kTextStyle3,
          ),
            Text(
            "+",
            textAlign: TextAlign.center,
            style: kTextStyle3,
          ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: kTextStyle3,
            )],),
        ),
      ),
    );
  }
}