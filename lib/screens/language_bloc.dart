import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../utils/user_session.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<LanguageSelected>((event, emit) {
      UserSession.setLanguageFromSharedPref(
          event.lang);
      emit(LanguageState(event.lang));
    });
  }
}
