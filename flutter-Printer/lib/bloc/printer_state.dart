part of 'printer_bloc.dart';


class UserState {
  UserState({
    this.isLogged = false,
    this.userName = "",
  });

  final bool isLogged;
  final String userName;

  UserState copyWith({
    bool? isLogged,
    String? userName,
  }) {
    return UserState(
      isLogged: isLogged ?? this.isLogged,
      userName: userName ?? this.userName,
    );
  }

}
