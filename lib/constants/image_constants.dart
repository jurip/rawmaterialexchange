import 'package:flutter/material.dart';

String imageDefinitionInFilter(int id) {
  var assetImage;
  switch (id) {
    case 1:
      assetImage = 'images/paperboard.png';
      break;
    case 2:
      assetImage = 'images/tape.png';
      break;
    case 3:
      assetImage = 'images/plastic.png';
      break;
    case 4:
      assetImage = 'images/glass.png';
      break;
    case 5:
      assetImage = 'images/metal.png';
      break;
    case 6:
      assetImage = 'images/alyuminiy.png';
      break;
    case 7:
      assetImage = 'images/lead.png';
      break;
    case 8:
      assetImage = 'images/copper.png';
      break;
    case 101:
      assetImage = 'images/garbage.png';
      break;
    default:
      assetImage = 'images/Frame 54.png';
  }
  return assetImage;
}