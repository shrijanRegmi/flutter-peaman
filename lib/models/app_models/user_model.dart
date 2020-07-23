class AppUser {
  final String photoUrl;
  final int age;
  final String uid;
  final String name;
  final String email;

  AppUser({this.uid, this.photoUrl, this.age, this.name, this.email});

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
    );
  }

  String get photoUrl_300x300 => photoUrl
      .replaceFirst('?alt', '_300x300?alt')
      .replaceFirst('profile_imgs%', 'profile_imgs%2Fprofile_imgs_resized%');

  String get photoUrl_100x100 => photoUrl
      .replaceFirst('?alt', '_100x100?alt')
      .replaceFirst('profile_imgs%', 'profile_imgs%2Fprofile_imgs_resized%');

  String get photoUrl_60x60 => photoUrl
      .replaceFirst('?alt', '_60x60?alt')
      .replaceFirst('profile_imgs%', 'profile_imgs%2Fprofile_imgs_resized%');
}
