class SettingModel {
  final String imgPath;
  final String title;
  SettingModel({this.imgPath, this.title});
}

List<SettingModel> generalSettings = [
  SettingModel(
    imgPath: 'assets/images/svgs/wrench.svg',
    title: 'Profile Information',
  ),
  SettingModel(
    imgPath: 'assets/images/svgs/logout.svg',
    title: 'Log out',
  ),
];
