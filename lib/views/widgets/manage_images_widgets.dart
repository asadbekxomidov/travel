import 'dart:io';

import 'package:dars_12/controller/images_controller.dart';
import 'package:dars_12/services/location_service.dart';
import 'package:dars_12/utils/messages.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ManageImagesWidget extends StatefulWidget {
  ManageImagesWidget({super.key});

  @override
  State<ManageImagesWidget> createState() => _ManageImagesWidgetState();
}

class _ManageImagesWidgetState extends State<ManageImagesWidget> {
  final titleController = TextEditingController();
  File? imagefile;
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    LocationService.init();
  }

  void addImageTravel() async {
    Messages.showLoadingDialog(context);

    // Fetch current location
    await LocationService.getCurrentLocation();
    currentLocation = LocationService.currentLocation;

    await context.read<ImageController>().addImageTravel(
      titleController.text,
      imagefile!,
      currentLocation,
    );

    if (context.mounted) {
      titleController.clear();
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickerImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickerImage != null) {
      setState(() {
        imagefile = File(pickerImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickerImage = await imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (pickerImage != null) {
      setState(() {
        imagefile = File(pickerImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Travel location add',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title travel',
                suffixIcon: IconButton(
                  onPressed: addImageTravel,
                  icon: Icon(Icons.add_circle),
                ),
              ),
            ),
            SizedBox(height: 10),
            if (currentLocation != null) ...[
              Text('Latitude: ${currentLocation?.latitude ?? 'Loading...'}'),
              Text('Longitude: ${currentLocation?.longitude ?? 'Loading...'}'),
            ],
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZoomTapAnimation(
                  onTap: openCamera,
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.camera),
                          Text('Camera'),
                        ],
                      ),
                    ),
                  ),
                ),
                ZoomTapAnimation(
                  onTap: openGallery,
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.image),
                          Text('Gallery'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (imagefile != null)
              SizedBox(
                height: 200,
                child: Image.file(imagefile!, fit: BoxFit.cover),
              ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ZoomTapAnimation(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text('Cancel'),
                ),
              ),
            ),
            ZoomTapAnimation(
              onTap: addImageTravel,
              child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
