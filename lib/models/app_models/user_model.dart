import 'package:peaman/enums/online_status.dart';

class AppUser {
  final String photoUrl;
  final int age;
  final String uid;
  final String name;
  final String email;
  final String profileStatus;
  final OnlineStatus onlineStatus;

  AppUser({
    this.uid,
    this.photoUrl,
    this.age,
    this.name,
    this.email,
    this.profileStatus,
    this.onlineStatus,
  });

  static Map<String, dynamic> toJson(AppUser appUser) {
    return {
      'uid': appUser.uid,
      'photoUrl': appUser.photoUrl,
      'age': appUser.age,
      'name': appUser.name,
      'email': appUser.email,
    };
  }

  static AppUser fromJson(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'],
      photoUrl: data['photoUrl'],
      age: data['age'],
      name: data['name'],
      email: data['email'],
      onlineStatus:
          data['active_status'] == 1 ? OnlineStatus.active : OnlineStatus.away,
      profileStatus: data['profile_status'] ?? 'I am a person with good heart',
    );
  }
}
