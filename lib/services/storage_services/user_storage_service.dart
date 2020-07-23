import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserStorage {
  // upload user image to storage;
  Future uploadUserImage({@required final File imgFile}) async {
    try {
      final _uniqueId = Uuid();
      final _path =
          'profile_imgs/${DateTime.now().millisecondsSinceEpoch}_${_uniqueId.v1()}';

      StorageReference _ref = FirebaseStorage.instance.ref().child(_path);
      StorageUploadTask _uploadTask = _ref.putFile(imgFile);
      await _uploadTask.onComplete;
      print('Upload completed!!!!');
      final _downloadUrl = await _ref.getDownloadURL();
      print('Download url is:::: $_downloadUrl');
      return _downloadUrl;
    } catch (e) {
      print('Storage error!!!');
      print(e);
      return null;
    }
  }
}
