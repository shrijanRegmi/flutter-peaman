import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/feed_provider.dart';
import 'package:peaman/services/storage_services/feed_storage_service.dart';

class CreatePostVm extends ChangeNotifier {
  BuildContext context;
  CreatePostVm(this.context);

  List<File> _photos = [];
  TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;
  bool _isFeatured = false;

  List<File> get photos => _photos;
  TextEditingController get captionController => _captionController;
  bool get isLoading => _isLoading;
  bool get isFeatured => _isFeatured;

  // create post
  createPost(final AppUser _appUser) async {
    if (_photos.isNotEmpty) {
      _updateIsLoading(true);

      final _photosString =
          await FeedStorage(uid: _appUser.uid).uploadFeedImages(_photos);
      if (_photosString != null) {
        final _feed = Feed(
          ownerId: _appUser.uid,
          ownerRef: AppUser().getUserRef(_appUser.uid),
          photos: _photosString,
          caption: _captionController.text.trim(),
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          isFeatured: _isFeatured,
        );

        final _result = await FeedProvider(feed: _feed).createPost();

        if (_result != null) {
          Navigator.pop(context);
        } else {
          _updateIsLoading(false);
        }
      }
    }
  }

  // upload photo
  uploadPhoto() async {
    final _pickedImg =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final _img = _pickedImg != null ? File(_pickedImg.path) : null;
    if (_img != null) {
      _photos.add(_img);
    }
    notifyListeners();
  }

  // remove photo
  removePhoto(final File myPhoto) async {
    _photos.remove(myPhoto);

    notifyListeners();
  }

  // update value of is loading
  _updateIsLoading(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }

  // update value of is featured
  updateIsFeatured(final bool newVal) {
    _isFeatured = newVal;
    notifyListeners();
  }
}
