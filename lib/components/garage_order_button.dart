import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:flutter/material.dart';

class GarbageOrderButton extends StatelessWidget {
  const GarbageOrderButton(
      {Key? key, required this.text1, required this.text2, required this.onTap})
      : super(key: key);

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
        child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      text1,
                      textAlign: TextAlign.center,
                      style: kTextStyle3,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                Column(
                  children: [
                    Text(
                      "                ",
                      textAlign: TextAlign.center,
                      style: kTextStyle3,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                Column(
                  children: [
                    Text(
                      text2+"    ",
                      textAlign: TextAlign.center,
                      style: kTextStyle3,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
                Image(height: 20,
                    image: AssetImage("images/white_arrow.png"))],
            )),
      ),
    );
  }
}
