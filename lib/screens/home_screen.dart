import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_service_app/bloc/location_bloc.dart';
import 'package:location_service_app/database/db_helper.dart';
import 'package:location_service_app/screens/location_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final LocationBloc _bloc = LocationBloc();
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  final DatabaseHelper _helper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _helper.initDatabase();
    _bloc.add(LocationInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Path Finder App",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LocationHistoryScreen(),
                  ));
                },
                tooltip: "Location History",
                icon: const Icon(
                  Icons.location_history,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: BlocConsumer<LocationBloc, LocationState>(
          bloc: _bloc,
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              case GettingLocationState:
                var successData = state as GettingLocationState;
                return GoogleMap(
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(successData.lat, successData.long),
                    zoom: 15,
                  ),
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("Location"),
                      points: successData.listData,
                    ),
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId("Current Location"),
                      position: LatLng(successData.lat, successData.long),
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    mapController.complete(controller);
                  },
                );
              case LoadingState:
                return const Center(child: CircularProgressIndicator());
              case LocationErrorState:
                var errorText = state as LocationErrorState;
                return Text(errorText.toString());

              default:
                return const Center(child: Text("There is some problem!!"));
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _bloc.add(GetCurrentLocationEvent()),
          backgroundColor: Colors.black,
          label: const Text(
            'Click to Store Location',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
