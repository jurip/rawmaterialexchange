import 'package:flutter/material.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';

class OrderButton extends StatelessWidget {
  const OrderButton({
    Key? key,
    required this.text1,
    required this.text2,
    required this.onTap
  }) : super(key: key);

  final text1;
  final text2;
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
        child:
          Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0,),
          child:
            Row(
              children: [
                Text(
                  text1,
                  textAlign: TextAlign.start,
                  style: kTextStyle3,
                ),
                Text(
                  text2,
                  textAlign: TextAlign.end,
                  style: kTextStyle3,
                ),
                Image(image: AssetImage("images/white_arrow"))
              ],
            )

        ),
      ),
    );
  }
}