import 'package:flutter/cupertino.dart';

import '../constants/style_constants.dart';

const double _kItemExtent = 32.0;
const List<String> _fruitNames = <String>[
  '00.00-02.00',
  '02.00-04.00',
  '04.00-06.00',
  '06.00-08.00',
  '08.00-10.00',
  '10.00-12.00',
  '12.00-14.00',
  '14.00-16.00',
  '16.00-18.00',
  '18.00-20.00',
  '20.00-22.00',
  '22.00-00.00',
];


class CupertinoPickerSample extends StatefulWidget {
  const CupertinoPickerSample({Key? key}) : super(key: key);

  @override
  State<CupertinoPickerSample> createState() => _CupertinoPickerSampleState();
}

class _CupertinoPickerSampleState extends State<CupertinoPickerSample> {
  int _selectedFruit = (DateTime.now().hour/2).toInt();

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22.0,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.zero,
                // Display a CupertinoPicker with list of fruits.
                onPressed: () => _showDialog(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: _kItemExtent,
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) {
                      setState(() {
                        _selectedFruit = selectedItem;
                      });
                    },
                    children:
                    List<Widget>.generate(_fruitNames.length, (int index) {
                      return Center(
                        child: Text(
                          _fruitNames[index],
                        ),
                      );
                    }),
                  ),
                ),
                // This displays the selected fruit name.
                child: Text(
                  _fruitNames[_selectedFruit],
                  style: kTextStyle2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
