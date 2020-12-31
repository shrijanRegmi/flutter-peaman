import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peaman/models/app_models/user_model.dart';

class Moment {
  final String id;
  final String photo;
  final AppUser owner;
  final String ownerId;
  final DocumentReference ownerRef;
  final int updatedAt;

  Moment({
    this.id,
    this.photo,
    this.owner,
    this.ownerId,
    this.ownerRef,
    this.updatedAt,
  });

  Moment copyWith({
    final String id,
    final String photo,
    final AppUser owner,
    final String ownerId,
    final DocumentReference ownerRef,
    final int updatedAt,
  }) {
    return Moment(
      id: id ?? this.id,
      photo: photo ?? this.photo,
      owner: owner ?? this.owner,
      ownerId: ownerId ?? this.ownerId,
      ownerRef: ownerRef ?? this.ownerRef,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Moment fromJson(final Map<String, dynamic> data, final AppUser owner) {
    return Moment(
      photo: data['photo'],
      owner: owner,
      ownerId: data['owner_id'],
      ownerRef: data['owner_ref'],
      updatedAt: data['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'owner_id': ownerId,
      'owner_ref': ownerRef,
      'updated_at': updatedAt,
    };
  }
}