import 'dart:async';

import 'package:piecyfer_test/core/network/connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'app_user_state.dart';
class UserStatusCubit extends Cubit<UserStatusState> {
  final ConnectionChecker _connectionChecker;
  late final StreamSubscription subscription;

  UserStatusCubit(this._connectionChecker) : super(UserStatusInitial()) {
    _monitorConnection();
  }

  void _monitorConnection() {
    // Cast ConnectionChecker to ConnectionCheckerImpl to use onStatusChange if necessary
    subscription = (_connectionChecker as ConnectionCheckerImpl).internetConnection.onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        emit(UserOnline());
      } else if (status == InternetStatus.disconnected) {
        emit(UserOffline());
      }
    });
  }


  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}