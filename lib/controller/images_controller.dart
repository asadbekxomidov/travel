import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars_12/services/images_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class ImageController with ChangeNotifier {
  final _imageFirebaseService = ImagesFireStoreServices();

  Stream<QuerySnapshot> get list async* {
    yield* _imageFirebaseService.getImagesTravel();
  }

  Future<void> addImageTravel(String title, File imageFile, LocationData? location) async {
    await _imageFirebaseService.addImageTravel(title, imageFile, location);
  }

  Future<void> deleteImageTravel(String id) async {
    await _imageFirebaseService.deleteImageTravel(id);
  }

  Future<void> editImageTravel(String id, String title, File? imagefile) async {
    await _imageFirebaseService.editImageTravel(id, title, imagefile);
  }
}
