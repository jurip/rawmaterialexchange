part of 'language_bloc.dart';

@immutable
abstract class LanguageEvent {}
class LanguageSelected extends LanguageEvent{
  final String lang;
  LanguageSelected(this.lang);
}

