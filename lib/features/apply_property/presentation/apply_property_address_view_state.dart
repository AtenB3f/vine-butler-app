import 'package:vine_butler/domain/model/address.dart';
import 'package:vine_butler/domain/model/address_candidate.dart';

class ApplyPropertyAddressViewState {
  final String query;
  final List<AddressResultViewState> results;
  final AddressResultViewState? selected;
  final Address? located;
  final bool isLocating;
  final bool isSearching;
  final bool isLoading;
  final int page;
  final int totalCount;
  final String? errorMessage;
  final String? navigateTo;

  const ApplyPropertyAddressViewState({
    this.query = '',
    this.results = const [],
    this.selected,
    this.located,
    this.isLocating = false,
    this.isSearching = false,
    this.isLoading = false,
    this.page = 0,
    this.totalCount = 0,
    this.errorMessage,
    this.navigateTo,
  });

  bool get isNotFound => query.isNotEmpty && !isSearching && selected == null && results.isEmpty;

  bool get isMapVisible => selected != null;

  bool get hasMore => results.length < totalCount;

  bool get canProceed => located != null;

  ApplyPropertyAddressViewState copyWith({
    String? query,
    List<AddressResultViewState>? results,
    AddressResultViewState? Function()? selected,
    Address? Function()? located,
    bool? isLocating,
    bool? isSearching,
    bool? isLoading,
    int? page,
    int? totalCount,
    String? Function()? errorMessage,
    String? Function()? navigateTo,
  }) {
    return ApplyPropertyAddressViewState(
      query: query ?? this.query,
      results: results ?? this.results,
      selected: selected != null ? selected() : this.selected,
      located: located != null ? located() : this.located,
      isLocating: isLocating ?? this.isLocating,
      isSearching: isSearching ?? this.isSearching,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      navigateTo: navigateTo != null ? navigateTo() : this.navigateTo,
    );
  }
}

class AddressResultViewState {
  final String zipCode;
  final String address;
  final String lotAddress;
  final AddressCandidate source;

  const AddressResultViewState({
    required this.zipCode,
    required this.address,
    required this.lotAddress,
    required this.source,
  });

  factory AddressResultViewState.fromDomain(AddressCandidate address) {
    return AddressResultViewState(
      zipCode: address.zipCode,
      address: address.roadAddress,
      lotAddress: address.lotAddress,
      source: address,
    );
  }
}
