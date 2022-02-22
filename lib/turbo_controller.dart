part of turbo;

/// The core component of controller logic.
/// If you want to implement controller logic in your application using Turbo,
///  you will be using this abstraction
///
/// The [refresh] function has to explicitly called for all the attached widgets
///  and states to be updated properly. This also ensures that the part of the
///  code that causes a change in state can easily be pinpointed, in contrast to
///  other solutions that handles it automatically.
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
  Future<void> refresh() async {
    for (var callback in _callbacks) {
      callback();
    }
  }
}
