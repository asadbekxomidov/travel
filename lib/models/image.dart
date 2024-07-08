import 'package:cloud_firestore/cloud_firestore.dart';

class ImagesModel {
  final String id;
  String title;
  String imageUrl;
  double? latitude;
  double? longitude;

  ImagesModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.latitude,
    this.longitude,
  });

  factory ImagesModel.fromQuerySnapshot(QueryDocumentSnapshot query) {
    return ImagesModel(
      id: query.id,
      title: query['title'],
      imageUrl: query['imageUrl'],
      latitude: query['latitude'] != null ? query['latitude'] : null,
      longitude: query['longitude'] != null ? query['longitude'] : null,
    );
  }
}
