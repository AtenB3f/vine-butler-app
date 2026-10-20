import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/features/apply_property/presentation/apply_property_address_view_state.dart';
import 'package:vine_butler/shared/utils/utils.dart';

enum EditPropertyAddressStep {
  detail,
  search,
  confirm,
}

class EditPropertyAddressViewState {
  final EditPropertyAddressStep step;
  final Address? currentAddress;
  final String query;
  final List<AddressResultViewState> results;
  final AddressResultViewState? selected;
  final Address? located;
  final String detailAddress;
  final bool isLocating;
  final bool isSearching;
  final bool isLoading;
  final bool isSaving;
  final int page;
  final int totalCount;
  final String? errorMessage;
  final bool isCompleted;

  const EditPropertyAddressViewState({
    this.step = EditPropertyAddressStep.detail,
    this.currentAddress,
    this.query = '',
    this.results = const [],
    this.selected,
    this.located,
    this.detailAddress = '',
    this.isLocating = false,
    this.isSearching = false,
    this.isLoading = false,
    this.isSaving = false,
    this.page = 0,
    this.totalCount = 0,
    this.errorMessage,
    this.isCompleted = false,
  });

  bool get isNotFound => query.isNotEmpty && !isSearching && results.isEmpty;

  bool get hasMore => results.length < totalCount;

  bool get canSaveAddress => located != null;

  Address? get _shownAddress {
    switch (step) {
      case EditPropertyAddressStep.detail:
        return currentAddress?.copyWith(detailAddress: detailAddress.trim());

      case EditPropertyAddressStep.search:
        return currentAddress;

      case EditPropertyAddressStep.confirm:
        return located?.copyWith(detailAddress: detailAddress.trim());
    }
  }

  String get unitAddress {
    final address = _shownAddress;

    return address == null ? '' : lotUnitAddress(address);
  }

  String get regionAddress {
    final address = _shownAddress;

    return address == null ? '' : [address.sido, address.sigungu].where((part) => part.isNotEmpty).join(' ');
  }

  EditPropertyAddressViewState copyWith({
    EditPropertyAddressStep? step,
    String? query,
    List<AddressResultViewState>? results,
    AddressResultViewState? Function()? selected,
    Address? Function()? located,
    String? detailAddress,
    bool? isLocating,
    bool? isSearching,
    bool? isLoading,
    bool? isSaving,
    int? page,
    int? totalCount,
    String? Function()? errorMessage,
    bool? isCompleted,
  }) {
    return EditPropertyAddressViewState(
      step: step ?? this.step,
      currentAddress: currentAddress,
      query: query ?? this.query,
      results: results ?? this.results,
      selected: selected != null ? selected() : this.selected,
      located: located != null ? located() : this.located,
      detailAddress: detailAddress ?? this.detailAddress,
      isLocating: isLocating ?? this.isLocating,
      isSearching: isSearching ?? this.isSearching,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
