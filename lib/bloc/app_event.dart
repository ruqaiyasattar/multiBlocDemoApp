import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventInitialize implements AppEvent{
  const AppEventInitialize();
}

@immutable
class AppEventGoToRegistration implements AppEvent{
  const AppEventGoToRegistration();
}

@immutable
class AppEventGoToLogin implements AppEvent{
  const AppEventGoToLogin();
}

@immutable
class AppEventRegister implements AppEvent{
  final String email;
  final String password;

  const AppEventRegister({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventLogIn implements AppEvent{
  final String email;
  final String password;

  const AppEventLogIn({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventLogOut implements AppEvent{
  const AppEventLogOut();
}

@immutable
class AppEventUploadImage implements AppEvent{
 final String filePathToUpload;

 const AppEventUploadImage({
   required this.filePathToUpload,
 });
}

@immutable
class AppEventDeleteAccount implements AppEvent{
  const AppEventDeleteAccount();
}
