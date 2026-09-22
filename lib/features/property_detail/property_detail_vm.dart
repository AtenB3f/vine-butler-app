import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vine_butler/features/property_detail/presentation/property_detail_view_state.dart';

final propertyDetailVMProvider = NotifierProvider<PropertyDetailVM, PropertyDetailViewState>(PropertyDetailVM.new);

class PropertyDetailVM extends Notifier<PropertyDetailViewState>{
  @override
  PropertyDetailViewState build() => PropertyDetailViewState();

  void action(PropertyDetailAction action) {
    switch (action) {
      case PropertyDetailAction.fetch:
        break;
    }
  }

  void popNavigation() {
    state = PropertyDetailViewState(navigateTo: null);
  }

  void pushNavigation(String path) {
    state = PropertyDetailViewState(navigateTo: path);
  }
}