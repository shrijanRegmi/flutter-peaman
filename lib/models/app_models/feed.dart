import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/user_model.dart';

class Feed {
  String id;
  final String ownerId;
  final DocumentReference ownerRef;
  final AppUser owner;
  final int updatedAt;
  final String caption;
  final List<String> photos;
  final String initialReactor;
  final int reactionCount;
  final List<String> reactorsPhoto;

  Feed({
    this.id,
    this.ownerId,
    this.ownerRef,
    this.owner,
    this.updatedAt,
    this.caption,
    this.photos,
    this.initialReactor,
    this.reactionCount,
    this.reactorsPhoto,
  });

  static Feed fromJson(final Map<String, dynamic> data, final AppUser owner) {
    return Feed(
      id: data['id'],
      ownerId: data['owner_id'],
      updatedAt: data['updated_at'] ?? DateTime.now().millisecondsSinceEpoch,
      caption: data['caption'] ?? '',
      photos: List<String>.from(data['photos'] ?? []),
      ownerRef: data['owner_ref'],
      owner: owner,
      initialReactor: data['init_reactor'] ?? '',
      reactionCount: data['reaction_count'] ?? 0,
      reactorsPhoto: List<String>.from(data['reactors_photo'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'owner_ref': ownerRef,
      'updated_at': updatedAt,
      'caption': caption,
      'photos': photos,
    };
  }
}
