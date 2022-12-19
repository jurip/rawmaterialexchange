part of 'language_bloc.dart';

@immutable
class LanguageState {
  LanguageState(this.lang);
  final String lang;
}

class LanguageInitial extends LanguageState {
  LanguageInitial() : super('ru');
}

