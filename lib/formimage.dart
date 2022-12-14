import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FormImage extends StatefulWidget {
  const FormImage({super.key});

  @override
  State<FormImage> createState() => _FormImageState();
}

class _FormImageState extends State<FormImage> {
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imagePath = File(image.path);
      setState(() {
        this.image = imagePath;
      });
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void imagePickerModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(13),
            topRight: Radius.circular(13),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return SizedBox(
            height: 100,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 3.5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          pickImage(ImageSource.gallery);
                        },
                        child: SizedBox(
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.photo,
                                size: 30,
                              ),
                              Text('Gallery', style: TextStyle(fontSize: 17))
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          pickImage(ImageSource.camera);
                        },
                        child: SizedBox(
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.camera_alt,
                                size: 30,
                              ),
                              Text('Camera', style: TextStyle(fontSize: 17))
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Image Uploader'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Upload your picture'),
              const SizedBox(height: 10),
              Container(
                height: 100,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.none,
                  onTap: () {
                    imagePickerModalBottomSheet();
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                    suffixIcon: const Icon(Icons.file_upload_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text("Selected image:"),
              const SizedBox(height: 20),
              image != null
                  ? Center(child: Image.file(image!, width: 300, height: 380))
                  : const Text('No image selected yet')
            ],
          ),
        ),
      ),
    );
  }
}
