import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'printer_event.dart';
part 'printer_state.dart';

class PrinterBloc extends Bloc<PrinterEvent, UserState> {
  PrinterBloc() : super(UserState()) {
    on<userLogin>((event, emit) {
      if(event.userName != null){
        emit(UserState(userName: event.userName!, isLogged: true));
      }
    });
  }
}
