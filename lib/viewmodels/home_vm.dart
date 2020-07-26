import 'package:flutter/material.dart';
import 'package:peaman/enums/online_status.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:provider/provider.dart';

class HomeVm extends ChangeNotifier {
  final BuildContext context;
  HomeVm({@required this.context});
}
