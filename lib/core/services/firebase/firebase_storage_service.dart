import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<String> uploadStaffPicture(String userName, File image) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child(
            'faces') // Optional: You can specify a folder in Firebase Storage
        .child(
            '$userName.jpg'); // Set the name of the image to the user's email

    // Upload the image file to Firebase Storage
    final SettableMetadata metadata = SettableMetadata(
      contentType: 'image/jpeg', // Set content type to indicate it's an image
    );
    final UploadTask uploadTask = storageReference.putFile(image, metadata);

    // Wait for the upload to complete
    final TaskSnapshot taskSnapshot = await uploadTask.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw Exception();
      },
    );

    // Get the download URL of the uploaded image
    final String imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl;
  }

  Future<void> deleteImage(String imageName) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child(
            'faces') // Optional: You can specify a folder in Firebase Storage
        .child('$imageName.jpg');
    // Delete the file
    await storageReference.delete().timeout(
      const Duration(seconds: 10),
      // ignore: void_checks
      onTimeout: () {
        throw Exception();
      },
    );
  }
}
