class LatLngModel {
  final int? id;
  double latitude;
  double longitude;

  LatLngModel({this.id, required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
