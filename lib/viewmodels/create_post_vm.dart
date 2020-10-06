import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/models/app_models/feed.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/services/storage_services/feed_storage_service.dart';

class CreatePostVm extends ChangeNotifier {
  List<File> _photos = [];
  TextEditingController _captionController = TextEditingController();

  List<File> get photos => _photos;
  TextEditingController get captionController => _captionController;

  // create post
  createPost(final String uid) async {
    if (_photos.isNotEmpty) {
      final _photosString =
          await FeedStorage(uid: uid).uploadFeedImages(_photos);
      if (_photosString != null) {
        final _feed = Feed(
          ownerId: uid,
          photos: _photosString,
          caption: _captionController.text.trim(),
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );

        return await FeedProvider().createPost(_feed);
      }
    }
  }

  // upload photo
  uploadPhoto() async {
    final _pickedImg =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final _img = _pickedImg != null ? File(_pickedImg.path) : null;
    _photos.add(_img);
    notifyListeners();
  }

  // remove photo
  removePhoto(final File myPhoto) async {
    _photos.remove(myPhoto);

    notifyListeners();
  }
}
