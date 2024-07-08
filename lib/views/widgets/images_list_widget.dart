import 'dart:io';

import 'package:dars_12/controller/images_controller.dart';
import 'package:dars_12/models/image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagesListWidget extends StatelessWidget {
  const ImagesListWidget({super.key});

  void _deleteImage(BuildContext context, String id) {
    context.read<ImageController>().deleteImageTravel(id);
  }

  void _editImage(BuildContext context, String id, String title) {
    final titleController = TextEditingController(text: title);
    File? imagefile;

    void openGallery() async {
      final imagePicker = ImagePicker();
      final XFile? pickerImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickerImage != null) {
        imagefile = File(pickerImage.path);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Image',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: openGallery,
                child: Text('Select Image'),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<ImageController>()
                        .editImageTravel(id, titleController.text, imagefile);
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagesController = context.read<ImageController>();
    return StreamBuilder(
      stream: imagesController.list,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final images = snapshot.data!.docs;
        return GridView.builder(
          padding: EdgeInsets.all(20.0),
          itemCount: images.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2 / 3,
          ),
          itemBuilder: (context, index) {
            final image = ImagesModel.fromQuerySnapshot(images[index]);
            return Card(
              child: Column(
                children: [
                  Container(
                    height: 130,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(image.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                  ),
                  Text(image.title),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _editImage(context, image.id, image.title),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteImage(context, image.id),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
