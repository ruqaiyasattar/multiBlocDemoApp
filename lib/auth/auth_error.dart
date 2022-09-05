import 'package:flutter/foundation.dart' show immutable;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

const Map<String, AuthError> authErrorMapping = {
  'user-not-found' : AuthErrorUserNotFound(),
  'email-already-in-use' : AuthErrorEmailAlreadyInUse(),
  'invalid-email'  : AuthErrorInvalidEmail(),
  'weak-password' :AuthErrorWeakPassword(),
  'operation-not-allowed' :AuthErrorOperationNotAllowed(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
          const AuthErrorUnknown();
}

@immutable
class AuthErrorUnknown extends AuthError{
  const AuthErrorUnknown() : super(
    dialogTitle:'Authentication Error',
    dialogText: 'Unknown Authentication Error',
  );
}

//no-current-user
@immutable
class AuthErrorNoCurrentUser extends AuthError{
  const AuthErrorNoCurrentUser() :
        super(
        dialogTitle: 'No Current User',
        dialogText: 'No current user with this information was found!',
  );
 }
//requires-recent-login
@immutable
class AuthErrorRequiresRecentLogin extends AuthError{
  const AuthErrorRequiresRecentLogin() :
        super(
        dialogTitle: 'Requires recent login',
        dialogText: 'You need to logout and log back in again in order to perform this operation',
      );
}
//operation-not-allowed
@immutable
class AuthErrorOperationNotAllowed extends AuthError{
  const AuthErrorOperationNotAllowed() :
        super(
        dialogTitle: 'Operation not allowed',
        dialogText: 'You cannot register using this method at this moment!',
      );
}

//user-not-found
@immutable
class AuthErrorUserNotFound extends AuthError{
  const AuthErrorUserNotFound() :
        super(
        dialogTitle: 'User Not Found',
        dialogText: 'The given user was not found on the server!',
      );
}
//weak-password
@immutable
class AuthErrorWeakPassword extends AuthError{
  const AuthErrorWeakPassword() :
        super(
        dialogTitle: 'Weak Password',
        dialogText: 'Please choose a strong password consisting of more characters!',
      );
}
//invalid-email
@immutable
class AuthErrorInvalidEmail extends AuthError{
  const AuthErrorInvalidEmail() :
        super(
        dialogTitle: 'Invalid Email',
        dialogText: 'Please double check your email and try again!',
      );
}
//email-already-in-use
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError{
  const AuthErrorEmailAlreadyInUse() :
        super(
        dialogTitle: 'Email Already in Use',
        dialogText: 'Please choose another email to register with!',
      );
}
