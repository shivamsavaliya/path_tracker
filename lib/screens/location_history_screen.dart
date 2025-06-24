import 'package:flutter/material.dart';
import 'package:location_service_app/database/db_helper.dart';
import 'package:location_service_app/models/latlong_model.dart';

class LocationHistoryScreen extends StatefulWidget {
  const LocationHistoryScreen({super.key});

  @override
  State<LocationHistoryScreen> createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  final DatabaseHelper _helper = DatabaseHelper();
  List<LatLngModel> latlong = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await _helper.getLatLngList().then((value) {
      setState(() {
        latlong = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Location History"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Table(
            border: TableBorder.all(
              color: Colors.white,
            ),
            children: [
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Latitude",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Longitude",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              ...latlong.asMap().entries.map(
                    (e) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(e.value.latitude.toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(e.value.longitude.toString()),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
