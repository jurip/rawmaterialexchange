import 'package:flutter/material.dart';
import 'package:app/constants/style_constants.dart';

class BlockWithMaterial extends StatelessWidget {
  const BlockWithMaterial({
    Key? key,
    required this.text,
    required this.price,
    required this.assetImage,
  }) : super(key: key);

  final String text;
  final String price;
  final String assetImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, left: 4, right: 4),
      width: 160.0,
      height: 64.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
              child: Image(image: AssetImage(assetImage), fit: BoxFit.cover,),
          ),
          ListTile(
            title: Text(text, style: kTextStyle7,),
            subtitle: Text(price, style: kTextStyle11,),
          ),
        ],
      ),
    );
  }
}
