import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multiproviderbloctesting/auth/auth_error.dart';
import 'package:multiproviderbloctesting/bloc/app_event.dart';
import 'package:multiproviderbloctesting/bloc/app_state.dart';
import 'package:multiproviderbloctesting/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent,AppState>{
  AppBloc() : super(
    const AppStateLoggedOut(
      isLoading: false,
    ),
  ){

    //
    on<AppEventGoToRegistration>((event, emit)  {
      emit(
        const AppStateIsInRegistrationView(
          isLoading: false,
        ),
      );
    });

    //
    on<AppEventLogIn>((event, emit) async {
      emit(
          const AppStateLoggedOut(
              isLoading: true,
          ),
      );

     try {
       final email = event.email;
       final password = event.password;
       final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: email,
         password: password,
       );
       final user = userCredential.user!;
       final images = await _getImages(user.uid);

       emit(
         AppStateLoggedIn(
             isLoading: false,
             user: user,
             images: images,
         ),
       );
     } on FirebaseAuthException catch (e){
       emit(
         AppStateLoggedOut(
           isLoading: false,
           authError: AuthError.from(e),
         ),
       );
     }
    },
    );

    //
    on<AppEventGoToLogin>((event, emit)  {
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });

    //register user
    on<AppEventRegister>((event, emit) async {
      //start loading
      emit(
        const AppStateIsInRegistrationView(
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try{
        //create the user
        final credentials = await FirebaseAuth
            .instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: credentials.user!,
            images: const [],
        ),
        );
      } on FirebaseAuthException catch (e){
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
      },
    );
    //initialze
    on<AppEventInitialize>((event, emit) async {
      //get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          const AppStateLoggedOut(
              isLoading: false,
          ),
        );
      }  else {
        //grab user's uploaded images
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: images,
          ),
        );
      }
    });

    //handle account deletion
    on<AppEventDeleteAccount>(
            (event, emit) async {
              final user = FirebaseAuth.instance.currentUser;
              //if not having current user, then please log the user out
              if (user == null) {
                emit(
                  const AppStateLoggedOut(
                    isLoading: false,
                  ),
                );
                return;
              }
              //start loading
              emit(
                AppStateLoggedIn(
                    isLoading: true,
                    user: user,
                    images: state.images ?? [],
                ),
              );

              //delete the user folder
              try{
                //delet user folder
                final folderContent = await FirebaseStorage.instance.ref(user.uid).listAll();
                 for(final item in folderContent.items){
                   await item.delete().catchError((_){}); //may be handle the error
                 }
                 //delet the flder itself
                 await FirebaseStorage
                     .instance
                     .ref(user.uid)
                     .delete()
                     .catchError((_){});

                 //delet user
                 await user.delete();

                 //logout user
                await FirebaseAuth.instance.signOut();
                //logout user in UI as well
                emit(const AppStateLoggedOut(
                    isLoading: true,
                ),
                );

              } on FirebaseAuthException catch (e){
                emit(
                  AppStateLoggedIn(
                    isLoading: false,
                    user: user,
                    images: state.images ?? [],
                    authError: AuthError.from(e),
                  ),
                );
              } on FirebaseException {
                //we might not be able to delete the folder
                //log the user out
                emit(
                  const AppStateLoggedOut(
                    isLoading: false,
                  ),
                );
              }

    });

    on<AppEventLogOut>((event, emit) async {
    emit(
      const AppStateLoggedOut(
        isLoading: true,
      ),
    );
    //log the user out
      await FirebaseAuth.instance.signOut();
      //log the user out in UI as well
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    },
    );

    //handle upload images
    on<AppEventUploadImage>((event, emit) async {
     final user = state.user;
     //log user out if we dnt have an actual user in app state
     if (user == null) {
       emit(
         const AppStateLoggedOut(
             isLoading: false,
         ),
       );
       return;
     }
     //start the loading process
     emit(
       AppStateLoggedIn(
         isLoading: true,
         user: user,
         images: state.images ?? [],
       ),
     );
     //upload the file
     final file = File(event.filePathToUpload);
     await uploadImage(
         file: file,
         userId: user.uid,
     );
     //after upload is complete, grab the latest file refrence
      final images = await _getImages(user.uid);
      //emit the new images and turn off loading
      emit(AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
      ),
      );
    });

  }


  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage
          .instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}

