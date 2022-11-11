import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef StringToVoidFunc = void Function(String);

class DateTimePicker {
  static void showSheetDate(
    BuildContext context, {
    required DateTime dateTime,
    required StringToVoidFunc onClicked,
    //required DateTime dateNow
  }) =>
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(actions: [
                Column(
                  children: [
                    SizedBox(
                      height: 180.0,
                      child: CupertinoDatePicker(
                          maximumDate: DateTime.now(),
                          backgroundColor: Colors.white,
                          initialDateTime: dateTime,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (newDateTime) =>
                              dateTime = newDateTime),
                    ),
                    Container(
                      color: kColorGreen1,
                      child: CupertinoButton(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            height: 57.0,
                            width: double.infinity,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Введите дату',
                                  style: kTextStyle4,
                                )),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0)),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            onClicked(
                                DateFormat("yyyy-MM-dd").format(dateTime));
                          }),
                    )
                  ],
                ),
              ]));

  static void showSheetDateAfter(
      BuildContext context, {
        required DateTime dateTime,
        required DateTime minimumDateTime,
        required StringToVoidFunc onClicked,
        //required DateTime dateNow
      }) =>
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(actions: [
            Column(
              children: [
                SizedBox(
                  height: 180.0,
                  child: CupertinoDatePicker(
                      minimumDate: minimumDateTime,
                      backgroundColor: Colors.white,
                      initialDateTime: dateTime,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (newDateTime) =>
                      dateTime = newDateTime),
                ),
                Container(
                  color: kColorGreen1,
                  child: CupertinoButton(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        height: 57.0,
                        width: double.infinity,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Введите дату',
                              style: kTextStyle4,
                            )),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onClicked(
                            DateFormat("yyyy-MM-dd").format(dateTime));
                      }),
                )
              ],
            ),
          ]));
}
