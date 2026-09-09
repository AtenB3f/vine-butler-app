import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/features/home/home_view_state.dart';

class HomeViewModel {
  void action(HomeViewAction action) {
    switch (action) {
      case HomeViewAction.find:
        // Handle find action
        break;
      case HomeViewAction.apply:
        // Handle apply action
        break;
    }
  }
}
