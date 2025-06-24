part of 'location_bloc.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

class GettingLocationState extends LocationState {
  final double lat, long;
  final List<LatLng> listData;
  GettingLocationState({
    required this.lat,
    required this.long,
    required this.listData,
  });
}

class LoadingState extends LocationState {}

// class ButtonClickLoadingState extends LocationState {}

class LocationErrorState extends LocationState {
  final String errorText;

  LocationErrorState({required this.errorText});
}
