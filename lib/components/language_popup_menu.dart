import 'package:app/screens/registration.dart';
import 'package:flutter/material.dart';

class LanguagePopupMenu extends StatefulWidget {
  LanguagePopupMenu({
    Key? key,
    required this.onSelected,
    required this.assetImage,
    required this.itemBuilder,
  }) : super(key: key);

  final Function(PopupItem)? onSelected;
  final AssetImage assetImage;
  final List<PopupMenuEntry<PopupItem>> Function(BuildContext) itemBuilder;

  @override
  _LanguagePopupMenuState createState() => _LanguagePopupMenuState();
}

class _LanguagePopupMenuState extends State<LanguagePopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupItem>(
      offset: Offset(0, 46),
      onSelected: widget.onSelected,
      enableFeedback: true,
      icon: Row(
        children: [
          Expanded(
            child: Container(
              child: Image(
                image: widget.assetImage,
                height: 54,
                width: 54,
              ),
            ),
          ),
          Expanded(child: Icon(Icons.keyboard_arrow_down)),
        ],
      ),
      itemBuilder: widget.itemBuilder,
    );
  }
}
