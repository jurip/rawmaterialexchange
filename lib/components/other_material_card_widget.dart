import 'package:app/constants/style_constants.dart';
import 'package:flutter/material.dart';

class OtherMaterialCardWidget extends StatelessWidget {
  const OtherMaterialCardWidget({
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
            constraints: BoxConstraints(minWidth: 80, maxWidth: 80),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: colorShadow, width: 3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child:
                Image(
              image: AssetImage(assetImage),
              //fit: BoxFit.cover,
            ),
          ),
        ]),
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(minWidth: 40, maxWidth: 80),
              child: Text(
                text,
                style: kTextStyle7,
                softWrap: false,
              ),
            ),
          ],
        )
      ]),
    );
  }
}
