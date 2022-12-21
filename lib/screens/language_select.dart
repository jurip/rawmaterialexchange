import 'package:app/screens/language_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _PopupItem1 {
  final String lang;
  final String title;
  final String image;

  _PopupItem1({required this.title, required this.image, required this.lang});
}
class LanguageSelect extends StatelessWidget {
  final List<PopupMenuEntry<_PopupItem1>> popUpMenuItem = [];
  String image(String lang) {
    return 'images/Ellipse ' + lang + '.png';
  }

  @override
  Widget build(BuildContext context) {
    ['ru','uz', 'kk'].forEach((element) {
      if(context.select((LanguageBloc b) => b.state.lang)!=element)
      popUpMenuItem.add(PopupMenuItem(
          value: _PopupItem1(
            lang: element,
            title: element.tr(),
            image: image(element),
          ),
          child: Row(children: [
            Image(image: AssetImage(image(element)), width: 20, height: 20),
            SizedBox(width: 10.0),
            Text(element.tr()),
          ])));
    });

    return PopupMenuButton<_PopupItem1>(
      offset: Offset(0, 46),
      onSelected: (e)=>{ context.read<LanguageBloc>().add(LanguageSelected(e.lang)) ,
      context.setLocale(Locale(e.lang))},
      enableFeedback: true,
      icon: Row(
        children: [
          Expanded(
            child: Container(
              child: Image(
                image: AssetImage(image(context.select((LanguageBloc b) => b.state.lang))),
                height: 54,
                width: 54,
              ),
            ),
          ),
          Expanded(child: Icon(Icons.keyboard_arrow_down)),
        ],
      ),
      itemBuilder: (context) => popUpMenuItem,
    );
  }
}
