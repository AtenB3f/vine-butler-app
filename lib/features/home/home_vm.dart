import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/core/router/app_router.dart';
import 'package:vine_butler/features/home/presentation/home_view_state.dart';

final homeVMProvider = NotifierProvider<HomeVM, HomeViewState>(HomeVM.new);
class HomeVM extends Notifier<HomeViewState> {
  @override
  HomeViewState build() => HomeViewState();

  void action(HomeViewAction action) {
    switch (action) {
      case HomeViewAction.find:
        state = HomeViewState(navigateTo: const FindPropertyRoute().location);
        break;
      case HomeViewAction.apply:
        state = HomeViewState(navigateTo: const ApplyPropertyRoute().location);
        break;
    }
  }

  void popNavigation() {
    state = HomeViewState(navigateTo: null);
  }
}