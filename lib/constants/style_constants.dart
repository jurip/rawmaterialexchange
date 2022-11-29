import 'package:flutter/material.dart';

import 'color_constants.dart';

const kTextStyle1 = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.w900,
  fontFamily: 'GothamProNarrow-Medium',
);

Color colorDefinitionInFilter(int id) {
  var colorFilterElement;
  switch (id) {
    case 1:
      colorFilterElement = kColorGrey1InFilter;
      break;
    case 2:
      colorFilterElement = kColorGrey2InFilter;
      break;
    case 3:
      colorFilterElement = kColorBlueInFilter;
      break;
    case 4:
      colorFilterElement = kColorYellowInFilter;
      break;
    case 5:
      colorFilterElement = kColorGrey3InFilter;
      break;
    case 6:
      colorFilterElement = kColorYellow2InFilter;
      break;
    case 7:
      colorFilterElement = kColorGreyInFilter;
      break;
    case 8:
      colorFilterElement = kColorOrangeInFilter;
      break;
    case 9:
      colorFilterElement = Color(0xFFF2F2F2);
      break;
    case 10:
      colorFilterElement = Color(0xFFF2F2F2);
      break;
  }
  return colorFilterElement;
}

const kTextStyle2 = TextStyle(
    color: Colors.black,
    fontSize: 18.0,
    fontFamily: 'GothamProNarrow-Medium',
    fontWeight: FontWeight.w600);

const kHintStyle = TextStyle(
  color: kColorGrey2,
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
  fontFamily: 'GothamProNarrow-Medium',
);
const grey = TextStyle(
  color: kColorGrey2,
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
  fontFamily: 'GothamProNarrow-Medium',
);

const kTextStyle3 = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const kTextStyle4 = TextStyle(
  color: kColorGreen1,
  fontWeight: FontWeight.w600,
  fontFamily: 'GothamProNarrow-Medium',
  fontSize: 18.0,
);

const kTextStyle5 = TextStyle(
  color: kColorGrey2,
  fontWeight: FontWeight.w600,
  fontFamily: 'GothamProNarrow-Medium',
  fontSize: 16.0,
);

const kTextStyle6 = TextStyle(
  color: kColorGrey3,
  fontWeight: FontWeight.w600,
  fontFamily: 'GothamProNarrow-Medium',
  fontSize: 16.0,
);

const kTextStyle7 = TextStyle(
  fontWeight: FontWeight.w600,
  fontFamily: 'GothamProNarrow-Medium',
  fontSize: 13.0,
);

const kTextStyle8 = TextStyle(
    color: kColorGreen1,
    fontSize: 18.0,
    fontFamily: 'GothamProNarrow-Medium',
    fontWeight: FontWeight.w600);

const kTextStyle9 = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontSize: 18.0,
  color: kColorGreen1,
);

const kTextStyle10 = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  color: kColorGreen1,
);

const kAlertTextStyle = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w700,
  fontSize: 20.0,
);
const header = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w700,
  fontSize: 22.0,
);
const linkStyle = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
  color: kColorGreen1,
  decoration: TextDecoration.underline,
);

const kAlertTextStyle2 = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w600,
);

const kAlertTextStyle3 = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

const kAlertTextStyle4 = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w700,
  color: kColorGrey3,
  fontSize: 12.0,
);
const bigWhite = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w700,
  color: kColorGrey4,
  fontSize: 26.0,
);

const kTextStyle11 = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w600,
  color: kColorGrey3,
  fontSize: 14.0,
);
const kTextStyle12 = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w600,
  fontSize: 14.0,
);

const kBottomSheetTextStyle = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w600,
  color: Colors.black,
  fontSize: 14.0,
);

const kBottomSheetTextStyle2 = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w600,
  color: kColorGrey2,
  fontSize: 14.0,
);

const kBottomSheetTextStyle3 = TextStyle(
  fontFamily: 'GothamProNarrow-Medium',
  fontWeight: FontWeight.w600,
  color: kColorGrey5,
  fontSize: 16.0,
);
