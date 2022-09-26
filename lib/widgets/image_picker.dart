import 'dart:html';

// import 'dart:io' as io;
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickImage extends StatelessWidget {
  void Function(File image) getImage;

  PickImage({Key? key, required this.getImage}) : super(key: key);

  Future<PermissionStatus> requestPermissions() async {
    await Permission.photos.request();
    return Permission.photos.status;
  }

  Future<void> uploadImage() async {
    FileUploadInputElement uploadImage = FileUploadInputElement()
      ..accept = 'image/*';
    uploadImage.click();
    uploadImage.onChange.listen((event) {
      final file = uploadImage.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(
        file,
      );
      reader.onLoadEnd.listen((event) {
        getImage(
          file,
        );
      });
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: uploadImage, child: const AutoSizeText('upload image'));
  }
}
