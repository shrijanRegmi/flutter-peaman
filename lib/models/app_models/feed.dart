class Feed {
  String id;
  final String ownerId;
  final int updatedAt;
  final String caption;
  final List<String> photos;

  Feed({this.id, this.ownerId, this.updatedAt, this.caption, this.photos});

  static Feed fromJson(final Map<String, dynamic> data) {
    return Feed(
      id: data['id'],
      ownerId: data['owner_id'],
      updatedAt: data['updated_at'] ?? DateTime.now().millisecondsSinceEpoch,
      caption: data['caption'] ?? '',
      photos: List<String>.from(data['photos'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'updated_at': updatedAt,
      'caption': caption,
      'photos': photos,
    };
  }
}
