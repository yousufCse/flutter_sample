class PlaceModel {
  final String description;
  final String placeId;

  const PlaceModel({required this.description, required this.placeId});

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
        description: json['description'], placeId: json['place_id']);
  }
}
