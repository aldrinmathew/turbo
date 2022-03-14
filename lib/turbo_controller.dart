part of turbo;

/// The core component of controller logic.
/// If you want to implement controller logic in your application using Turbo,
///  you will be using this abstraction
///
/// The [refresh] function has to explicitly called for all the attached widgets
///  and states to be updated properly. This also ensures that the part of the
///  code that causes a change in state can easily be pinpointed, in contrast to
///  other solutions that handles it automatically.
abstract class TurboController<E> {
  /// All callbacks of all widgets that are attached to this controller
  final List<void Function()?> _callbacks = [];

  /// All events registered with the controller. All events only supports one
  /// type of Event `E` provided by the user
  final List<TurboEvent<E>?> _events = [];

  /// Attaches a [TurboState] to this Controller so as to automatically rebuild
  ///  it when member variables are updated
  ///
  /// It returns an integer which is the index that can be used to detach the
  ///  widget's state from this controller
  int _attachState<K extends StatefulWidget, T extends State<K>>(
    T widgetState,
    TurboEvent<E>? turboEvent,
  ) {
    _callbacks.add(() {
      stateRefresh(state: widgetState);
    });
    _events.add(turboEvent);
    return _callbacks.length - 1;
  }

  /// Attaches a [TurboWidget] to this controller so as to automatically rebuild
  ///  it when member variables are updated
  ///
  /// It returns an integer which is the index that can be used to detach the
  ///  widget from this controller
  int _attachWidget<T extends TurboWidget>(
    T widget,
    TurboEvent<E>? turboEvent,
  ) {
    _callbacks.add(() {
      if (widget.element != null) {
        widgetRefresh(element: widget.element!);
      }
    });
    _events.add(turboEvent);
    return _callbacks.length - 1;
  }

  /// Detaches a widget or state from this controller using the corresponding
  ///  index
  void _detach(int index) {
    _callbacks[index] = null;
    _events[index] = null;
  }

  /// Get the appropriate `TurboEvent`
  ///
  /// `TurboEvent` represents events associated with a controller, that the widgets
  /// should respond to.
  ///
  /// The constuctor for `TurboEvent` is private as it doesn't support Type
  /// Inference. Using this function ensures that the values passed are of the
  /// right type
  ///
  /// `values` is the list of all events the widget should respond to. Ideally
  /// this should be a list of `enum` values
  ///
  /// `after` is the callback to be called after the widget's state is updated
  ///
  /// `before` is the callaback to be called before the widget's state is
  /// updated
  ///
  /// It is recommended to use the `after` callback more, so as to reduce
  /// conflicts in state updations. But if you know what you are doing, go for
  /// it
  TurboEvent<E> event(
    List<E> values, {
    void Function(E event)? after,
    void Function(E event)? before,
  }) {
    return TurboEvent<E>._(values, after: after, before: before);
  }

  /// Refresh/Update all attached widgets and states
  ///
  /// Provide `emit` so as to update widgets waiting for that event
  Future<void> refresh({E? emit}) async {
    for (int i = 0; i < _callbacks.length; i++) {
      if (_callbacks[i] != null) {
        if (_events[i] == null) {
          _callbacks[i]!();
        } else if (emit != null) {
          if (_events[i]!.events.contains(emit)) {
            if (_events[i]!.before != null) {
              _events[i]!.before!(emit);
            }

            _callbacks[i]!();

            if (_events[i]!.after != null) {
              _events[i]!.after!(emit);
            }
          }
        }
      }
    }
  }
}
