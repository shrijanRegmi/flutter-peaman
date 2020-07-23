import 'package:cloud_functions/cloud_functions.dart';
import 'package:peaman/models/app_models/user_model.dart';

class UserFunctions {
  final _functions = CloudFunctions.instance;
  HttpsCallable _callable;

  // send user to functions
  Future sendUserToFunctions(AppUser _user) async {
    try {
      _callable = _functions.getHttpsCallable(functionName: 'sendUser');
      final _jsonUser = AppUser.toJson(_user);
      return _callable.call(_jsonUser);
    } catch (e) {
      print('Functions error');
      print(e);
      return null;
    }
  }
}
