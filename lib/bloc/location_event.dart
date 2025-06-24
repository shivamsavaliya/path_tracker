part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

class LocationInitialEvent extends LocationEvent {}

class GetCurrentLocationEvent extends LocationEvent {}
