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
  final bool isReacted;

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
    this.isReacted,
  });

  Feed copyWith({
    String id,
    final String ownerId,
    final DocumentReference ownerRef,
    final AppUser owner,
    final int updatedAt,
    final String caption,
    final List<String> photos,
    final String initialReactor,
    final int reactionCount,
    final List<String> reactorsPhoto,
    final bool isReacted,
  }) {
    return Feed(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerRef: ownerRef ?? this.ownerRef,
      owner: owner ?? this.owner,
      updatedAt: updatedAt ?? this.updatedAt,
      caption: caption ?? this.caption,
      photos: photos ?? this.photos,
      initialReactor: initialReactor ?? this.initialReactor,
      reactionCount: reactionCount ?? this.reactionCount,
      reactorsPhoto: reactorsPhoto ?? this.reactorsPhoto,
      isReacted: isReacted ?? this.isReacted,
    );
  }

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
      isReacted: data['is_reacted'] ?? false,
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
