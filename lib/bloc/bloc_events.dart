
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent{
  const AppEvent();
}

class LoadNextUrlEvent implements AppEvent{
  const LoadNextUrlEvent();
}