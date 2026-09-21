import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/features/home/home_view_state.dart';

final homeVMProvider = NotifierProvider<HomeVM, HomeViewState>(HomeVM.new);
class HomeVM extends Notifier<HomeViewState> {
  @override
  HomeViewState build() => HomeViewState();

  void action(HomeViewAction action) {
    switch (action) {
      case HomeViewAction.find:
        state = HomeViewState(navigateTo: '/find-property');
        break;
      case HomeViewAction.apply:
        state = HomeViewState(navigateTo: '/apply-property');
        break;
    }
  }

  void consumeNavigation() {
    state = HomeViewState(navigateTo: null);
  }
}