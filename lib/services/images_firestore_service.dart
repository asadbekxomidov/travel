import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';

class ImagesFireStoreServices {
  final _imagesCollection = FirebaseFirestore.instance.collection('images');
  final _imagesStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getImagesTravel() async* {
    yield* _imagesCollection.snapshots();
  }

  Future<void> addImageTravel(String title, File imageFile, LocationData? location) async {
    final imagesReference = _imagesStorage
        .ref()
        .child('image')
        .child('travel')
        .child('$title image');
    final uploadTask = imagesReference.putFile(
      imageFile,
    );

    uploadTask.snapshotEvents.listen((status) {
      print(status.state);
      double percentage =
          status.bytesTransferred / imageFile.lengthSync() * 100;
      print('$percentage');
    });

    uploadTask.whenComplete(() async {
      final imageUrl = await imagesReference.getDownloadURL();
      await _imagesCollection.add({
        'title': title,
        'imageUrl': imageUrl,
        'latitude': location?.latitude,
        'longitude': location?.longitude,
      });
    });
  }

  Future<void> deleteImageTravel(String id) async {
    await _imagesCollection.doc(id).delete();
  }

  Future<void> editImageTravel(String id, String title, File? imagefile) async {
    if (imagefile != null) {
      final imagesReference = _imagesStorage
          .ref()
          .child('image')
          .child('travel')
          .child('$title image');
      final uploadTask = imagesReference.putFile(
        imagefile,
      );

      uploadTask.snapshotEvents.listen((status) {
        print(status.state);
        double percentage =
            status.bytesTransferred / imagefile.lengthSync() * 100;

        print('$percentage');
      });

      uploadTask.whenComplete(() async {
        final imageUrl = await imagesReference.getDownloadURL();
        await _imagesCollection.doc(id).update({
          'title': title,
          'imageUrl': imageUrl,
        });
      });
    } else {
      await _imagesCollection.doc(id).update({
        'title': title,
      });
    }
  }
}
