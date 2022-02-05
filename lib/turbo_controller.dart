part of turbo;

abstract class TurboController {
  final List<void Function()> _callbacks = [];

  /// Attaches a [TurboState] to this Controller so as to automatically rebuild
  ///  it when member variables are updated
  ///
  /// It returns an integer which is the index that can be used to detach the
  ///  widget's state from this controller
  int _attachState<K extends StatefulWidget, T extends State<K>>(
      T widgetState) {
    _callbacks.add(() {
      stateRefresh(state: widgetState);
    });
    return _callbacks.length - 1;
  }

  /// Attaches a [TurboWidget] to this controller so as to automatically rebuild
  ///  it when member variables are updated
  ///
  /// It returns an integer which is the index that can be used to detach the
  ///  widget from this controller
  int _attachWidget<T extends TurboWidget>(T widget) {
    _callbacks.add(() {
      if (widget.element != null) {
        widgetRefresh(element: widget.element!);
      }
    });
    return _callbacks.length - 1;
  }

  /// Detaches a widget or state from this controller using the corresponding
  ///  index
  void _detach(int index) {
    _callbacks[index] = () {};
  }

  /// Refresh/Update all attached widgets and states
  void refresh() {
    for (var callback in _callbacks) {
      callback();
    }
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyWidget2 extends StatefulWidget {
  const MyWidget2({Key? key, required this.hello}) : super(key: key);
  final int hello;

  @override
  _MyWidget2State createState() => _MyWidget2State();
}

class _MyWidget2State extends State<MyWidget2> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
