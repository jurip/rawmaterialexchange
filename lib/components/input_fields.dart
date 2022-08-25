import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/constants/color_constants.dart';
import 'package:app/constants/style_constants.dart';


//Поле ввода для имени и фамилии
class NameInputField extends StatelessWidget {
  const NameInputField({
    Key? key,
    required this.hintText,
    this.svgPicture,
    this.controller,
    this.textChange,
    this.validator,
  }) : super(key: key);

  final String hintText;
  final Widget? svgPicture;
  final TextEditingController? controller;
  final String? Function(String?)? textChange;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      keyboardType: TextInputType.name,
      onChanged: (str) {
        if (textChange != null) textChange!(str);
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[a-z A-Z á-ú Á-Ú а-я А-Я а-ҳ А-Ҳ а-я А-Я ә Ә а-ю А-Ю Ӯ ӯ Ҷ ҷ Ӣ ӣ]")),
      ],
      style: kTextStyle2,
      decoration: InputDecoration(
        suffixIcon: svgPicture,
        suffixIconConstraints: BoxConstraints(
            minHeight: 22,
            minWidth: 22
        ),
        hintText: hintText,
        hintStyle: kHintStyle,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: kColorGrey1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: kColorGreen1),
        ),
      ),
    );
  }
}



//поле для ввода номера телефона
class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    Key? key,
    this.svgPicture,
    this.controller,
    this.textChange,
    this.inputFormatters,
    this.hintText,
  }) : super(key: key);

  final Widget? svgPicture;
  final TextEditingController? controller;
  final String? Function(String?)? textChange;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      keyboardType: TextInputType.phone,
      onChanged: (str) {
        if (textChange != null) textChange!(str);
      },
      inputFormatters: inputFormatters,
      style: kTextStyle2,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: kHintStyle,
        suffixIcon: svgPicture,
        suffixIconConstraints: BoxConstraints(
            minHeight: 22,
            minWidth: 22
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: kColorGrey1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: kColorGreen1),
        ), floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}