import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewmodelProvider<T extends ChangeNotifier> extends StatefulWidget {
  @override
  _ViewmodelProviderState<T> createState() => _ViewmodelProviderState<T>();
  final Function(BuildContext context, T vm) builder;
  final T vm;
  final Function(T vm) onInit;
  final Function(T vm) onDispose;
  final Function(T vm, AppLifecycleState state) onDidChangeLifeCycle;
  ViewmodelProvider({
    @required this.vm,
    @required this.builder,
    this.onInit,
    this.onDispose,
    this.onDidChangeLifeCycle,
  });
}

class _ViewmodelProviderState<T extends ChangeNotifier>
    extends State<ViewmodelProvider<T>> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    if (widget.onInit != null) {
      widget.onInit(widget.vm);
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addObserver(this);

    if (widget.onDispose != null) {
      widget.onDispose(widget.vm);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (widget.onDidChangeLifeCycle != null) {
      widget.onDidChangeLifeCycle(widget.vm, state);
    }
  }

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
