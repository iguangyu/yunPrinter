part of 'printer_bloc.dart';

@immutable
abstract class PrinterEvent {}

class userLogin extends PrinterEvent {
  String? userName;
  userLogin({this.userName});
}