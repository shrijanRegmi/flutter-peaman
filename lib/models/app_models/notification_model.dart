import 'package:peaman/enums/notification_type.dart';
import 'package:peaman/models/app_models/user_model.dart';

class Notifications {
  final String id;
  final AppUser sender;
  final NotificationType type;
  final int updatedAt;
  final bool isAccepted;

  Notifications(
      {this.id, this.sender, this.type, this.updatedAt, this.isAccepted});

  static Notifications fromJson(
      final Map<String, dynamic> data, final String id) {
    return Notifications(
      id: id,
      sender: AppUser.fromJson(data['user_data']),
      type: NotificationType.values[data['type']],
      updatedAt: data['updated_at'],
      isAccepted: data['is_accepted'] ?? false,
    );
  }
}
