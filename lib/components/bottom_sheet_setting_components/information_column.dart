import 'package:flutter/material.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';

class InformationColumn extends StatelessWidget {
  const InformationColumn({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text1, style: kAlertTextStyle4,),
          SizedBox(height: 4.0),
          Text(text2, style: kTextStyle2,),
          SizedBox(height: 8.0),
          Container(width: double.infinity, height: 2.0, color: kColorGrey1,),
        ],
      ),
    );
  }
}
