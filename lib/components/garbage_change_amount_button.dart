import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:flutter/material.dart';

class GarbageChangeAmountButton extends StatelessWidget {
  const GarbageChangeAmountButton(
      {Key? key,
      required this.text,
      required this.onMinusTap,
      required this.onPlusTap})
      : super(key: key);

  final text;
  final GestureTapCallback onMinusTap;
  final GestureTapCallback onPlusTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: kColorGrey1,
        border: Border.all(width: 1.0, color: Color(0xFFBEBEBE)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 1.0,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          InkWell(
              onTap: onMinusTap,
              child: Container(
                  margin: const EdgeInsets.all(3.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    Text(
                      "-",
                      textAlign: TextAlign.start,
                      style: kTextStyle2,
                    ),
                  ], crossAxisAlignment: CrossAxisAlignment.start))),
          Column(
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: kTextStyle2,
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          InkWell(
            onTap: onPlusTap,
            child: Container(
                margin: const EdgeInsets.all(3.0),
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Text(
                    "+",
                    textAlign: TextAlign.end,
                    style: kTextStyle2,
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.end)),
          ),
        ]),
      ),
    );
  }
}
