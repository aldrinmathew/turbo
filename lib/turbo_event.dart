part of turbo;

/// TurboEvent represents Events associated with a controller, that the widgets
/// should respond to. Note that if the provided events doesn't occur, the
/// widget's state will not be updated at all
///
/// `events` is the list of all Events the widget should respond to. Ideally
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
  /// TurboEvent represents Events associated with a controller, that the widgets
  /// should respond to.
  ///
  /// `events` is the list of all Events the widget should respond to. Ideally
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
  TurboEvent({
    required this.events,
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
