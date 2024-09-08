part of 'app_user_cubit.dart';

@immutable
sealed class UserStatusState {}


class UserStatusInitial extends UserStatusState {}

class UserOnline extends UserStatusState {}

class UserOffline extends UserStatusState {}

class UserAway extends UserStatusState {} // For cases when the app is in background or inactive