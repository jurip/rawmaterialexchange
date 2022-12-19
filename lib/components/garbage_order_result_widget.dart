import 'package:app/api/models/response_list_languages.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:app/screens/registration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'confirmation_button.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class GarbageOrderResultWidget extends StatelessWidget {
  final bool orderSent;

  const GarbageOrderResultWidget( this.orderSent, {
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: topPadding1),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: kColorGrey1,
                          ),
                          height: containerHeight1,
                          width: 42.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: topPadding2),
                      child: Center(
                          child:
                              orderSent?
                              Text('order_done'.tr(), style: kAlertTextStyle):
                        Text('order_error'.tr(), style: kAlertTextStyle)
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: 0,
                          maxWidth: double.infinity,
                          maxHeight: double
                              .infinity //definitionHeightBottomSheetSettings(),
                          ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //66 * 4
                            SizedBox(height: sizedBoxHeight1),
                            orderSent?Text("orded_done_text".tr()):SizedBox(height: sizedBoxHeight3),
                            SizedBox(height: sizedBoxHeight3),
                            Container(
                              width: double.infinity,
                              height: containerHeight2,
                              color: kColorGrey1,
                            ),
                            SizedBox(height: sizedBoxHeight4),
                            ConfirmationButton(
                              //46
                              text: 'to_main'.tr(),
                              onTap: () async {
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(height: sizedBoxHeight5),
                            SizedBox(height: 300),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
