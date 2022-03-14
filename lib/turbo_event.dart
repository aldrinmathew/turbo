part of turbo;

/// `TurboEvent` represents events associated with a controller, that the widgets
/// should respond to. Use [TurboController.event] or `yourController.event`
/// to get the corresponding event
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
class TurboEvent<E> {
  /// `TurboEvent` represents events associated with a controller, that the widgets
  /// should respond to. Use [TurboController.event] or `yourController.event`
  /// to get the corresponding event
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
  TurboEvent._(
    this.events, {
    this.after,
    this.before,
  });

  /// List of all events the widget should respond to
  final List<E> events;

  /// The callback to be called after the widget's state is updated
  final void Function(E event)? after;

  /// The callback to be called before the widget's state is updated
  final void Function(E event)? before;
}
