import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_service_app/models/latlong_model.dart';
import 'package:meta/meta.dart';
import '../database/db_helper.dart';
part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final DatabaseHelper _helper = DatabaseHelper();
  Position? position;
  bool? serviceEnabled;
  LocationPermission? permission;

  LocationBloc() : super(LocationInitial()) {
    on<LocationInitialEvent>(locationInitialEvent);
    on<GetCurrentLocationEvent>(getCurrentLocationEvent);
  }

  FutureOr<void> locationInitialEvent(
      LocationInitialEvent event, Emitter<LocationState> emit) async {
    emit(LoadingState());
    await Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        await _determinePosition().onError((error, stackTrace) =>
            emit(LocationErrorState(errorText: error.toString())));
      },
    );
    emit(
      GettingLocationState(
        lat: position!.latitude,
        long: position!.longitude,
        listData: const [],
      ),
    );
  }

  FutureOr<void> getCurrentLocationEvent(
      GetCurrentLocationEvent event, Emitter<LocationState> emit) async {
    emit(LoadingState());
    await Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        await _determinePosition().onError((error, stackTrace) =>
            emit(LocationErrorState(errorText: error.toString())));
      },
    );

    await _helper.insertLatLng(LatLngModel(
        latitude: position!.latitude, longitude: position!.longitude));

    await _helper.getLatLngList().then((value) {
      emit(GettingLocationState(
        lat: position!.latitude,
        long: position!.longitude,
        listData: value.map((e) => LatLng(e.latitude, e.longitude)).toList(),
      ));
    });
  }

  Future<void> _determinePosition() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    position = await Geolocator.getCurrentPosition();
  }
}
