import 'package:peaman/enums/notification_type.dart';
import 'package:peaman/models/app_models/feed_model.dart';
import 'package:peaman/models/app_models/user_model.dart';

class Notifications {
  final String id;
  final AppUser sender;
  final List<AppUser> reactedBy;
  final List<AppUser> commentedBy;
  final Feed feed;
  final NotificationType type;
  final int updatedAt;
  final bool isAccepted;

  Notifications({
    this.id,
    this.sender,
    this.type,
    this.updatedAt,
    this.isAccepted,
    this.reactedBy,
    this.commentedBy,
    this.feed,
  });

  static Notifications fromJson(
      final Map<String, dynamic> data, final String id) {
    final _type = data['type'];
    if (_type == 1) {
      final _reactedBy = List<AppUser>.from(
        List<Map>.from(data['reacted_by']).map((e) => AppUser.fromJson(e)),
      );
      return ReactNotification(
        id: id,
        reactedBy: List<AppUser>.from(_reactedBy.reversed),
        feed: Feed.fromJson(data['post_data']),
        updatedAt: data['updated_at'],
      );
    }
    if (_type == 2) {
      final _commentedBy = List<AppUser>.from(
        List<Map>.from(data['commented_by']).map((e) => AppUser.fromJson(e)),
      );

      return CommentNotification(
        id: id,
        commentedBy: List<AppUser>.from(_commentedBy.reversed),
        feed: Feed.fromJson(data['post_data']),
        updatedAt: data['updated_at'],
      );
    }
    return null;
  }
}

class ReactNotification extends Notifications {
  final String id;
  final List<AppUser> reactedBy;
  final Feed feed;
  final int updatedAt;

  ReactNotification({
    this.id,
    this.reactedBy,
    this.updatedAt,
    this.feed,
  }) : super(
          id: id,
          reactedBy: reactedBy,
          type: NotificationType.reaction,
          updatedAt: updatedAt,
          feed: feed,
        );
}

class CommentNotification extends Notifications {
  final String id;
  final List<AppUser> commentedBy;
  final Feed feed;
  final int updatedAt;

  CommentNotification({
    this.id,
    this.commentedBy,
    this.feed,
    this.updatedAt,
  }) : super(
          id: id,
          commentedBy: commentedBy,
          type: NotificationType.comment,
          updatedAt: updatedAt,
          feed: feed,
        );
}
