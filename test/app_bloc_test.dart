import 'dart:typed_data' show Uint8List;
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:multiproviderbloctesting/app_state.dart';
import 'package:multiproviderbloctesting/bloc/app_bloc.dart';
import 'package:multiproviderbloctesting/bloc/bloc_events.dart';

extension ToList on String{
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Baz'.toUint8List();

enum Errors {dummy}

void main() {
  blocTest<AppBloc,AppState>(
      'Initial state of the Bloc should be empty',
      build: () => AppBloc(
          urls: [],
      ),
    verify: (appBloc) => expect(
        appBloc.state,
        const AppState.empty(),
    ),
  );


  blocTest<AppBloc,AppState>(
    'Load valid data and compare states',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
          isLoading: true,
          data: null,
          error: null,
      ),
      AppState(
        isLoading: false,
        data: text1Data,
        error: null,
      ),
    ],
  );


  //test thowing error from url loader
  blocTest<AppBloc,AppState>(
    'test the ability to load a URL',
    build: () => AppBloc(
      urls: [],
    ),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
  );


  blocTest<AppBloc,AppState>(
    'Throw an error in url loader and catch it',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        data: null,
        error: Errors.dummy,
      ),
    ],
  );


  //
  blocTest<AppBloc,AppState>(
    'test the ability to load more than one url',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2Data),
    ),
    act: (appBloc) {
      appBloc.add(
      const LoadNextUrlEvent(),
    );
      appBloc.add(
      const LoadNextUrlEvent(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
       AppState(
        isLoading: false,
        data: text2Data,
        error: null,
      ),
      const AppState(
        isLoading: true,
        data: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        data: text2Data,
        error: null,
      ),
    ],
  );
}

