import 'package:app/constants/style_constants.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class MaterialCardWidget extends StatelessWidget {
  const MaterialCardWidget({
    Key? key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.assetImage,
    required this.colorShadow,
  }) : super(key: key);

  final String text;
  final Function() onTap;
  final Color? color;
  final String assetImage;
  final Color colorShadow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(children: [
        Row(children: [
          Container(
            constraints: BoxConstraints(minWidth: 70, maxWidth: 70),
            //margin: EdgeInsets.only(bottom: 10.0, left: 4, right: 4),
            //width: 62.0,
            //height: 64.0,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: colorShadow, width: 3),
              borderRadius: BorderRadius.circular(16.0),
            //  boxShadow: [
              //  BoxShadow(
               //   color: colorShadow,
              //    spreadRadius: 3,
                //  blurRadius: 6,
              //  ),
             //  ],
            ),
            child:
                //Padding(
                //padding: const EdgeInsets.only(left: 8.0),
                //child:
                //Stack(
                //children: [
                // Align(
                //alignment: Alignment.topRight,
                //child:
                Image(
              image: AssetImage(assetImage),
              //fit: BoxFit.cover,
            ),
            // ),

            //],
            //),
          ),
          //),
        ]),
        Row(
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 70, maxWidth: 70),
              child: Text(
                text,
                style: kTextStyle7,
                //softWrap: true,
              ),
            ),
          ],
        )
        //Padding(
        // padding: EdgeInsets.only(top: 10.0, left: 2.0),
        //child:

        //  ),
      ]),
    );
  }
}
