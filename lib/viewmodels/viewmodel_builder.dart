import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewmodelProvider<T extends ChangeNotifier> extends StatefulWidget {
  @override
  _ViewmodelProviderState<T> createState() => _ViewmodelProviderState<T>();
  final Function(BuildContext context, T vm) builder;
  final T vm;
  ViewmodelProvider({@required this.vm, @required this.builder});
}

class _ViewmodelProviderState<T extends ChangeNotifier>
    extends State<ViewmodelProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => widget.vm,
      child: Consumer<T>(
        builder: (BuildContext context, T vm, Widget child) =>
            widget.builder(context, vm),
      ),
    );
  }
}
