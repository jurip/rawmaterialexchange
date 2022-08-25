import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';

class MyWillPop {

  BuildContext context;

  MyWillPop({required this.context});


  Future<bool> onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: 160.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 2.0, color: kColorGreen2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 10.0),
              Text(
                'are_you_sure'.tr(),
                textAlign: TextAlign.center,
                style: kAlertTextStyle,
              ),
              Text(
                'do_you_want_exit_app'.tr(),
                textAlign: TextAlign.center,
                style: kAlertTextStyle2,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: kColorGreen1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'no'.tr(),
                          style: kAlertTextStyle3,
                        ),
                      ),
                      Container(
                        height: 30.0,
                        width: 1.0,
                        color: Colors.white,
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: new Text(
                          'yes'.tr(),
                          style: kAlertTextStyle3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )) ??
        false;
  }


}