part of turbo;

/// A replacement for [State] to be used with a [StatefulWidget]
///
/// ```dart
/// class MyWidget extends StatefulWidget {
///   const MyWidget({ Key? key }): super(key: key);
///
///   _MyWidgetState createState() => _MyWidgetState();
/// }
///
/// class _MyWidgetState extends TurboState<MyWidget> {
///   @override
///   void initState() {
///     attach(myFirstController);
///     attach(mySecondController);
///     ...
///     /// Attach as many controllers that this widget should respond the
///     ///  changes of, to
///     ...
///     super.initState();
///   }
///
///   /// Overriding the dispose function is optional if your widget does not
///   ///  need dispose logic
///   @override
///   void dispose() {
///     super.dispose();
///   }
/// }
/// ```
///
/// See also:
///
/// [TurboWidget], which is a replacement for [StatelessWidget] and thereby has
///  better performance than [TurboState]
abstract class TurboState<S extends StatefulWidget> extends State<S> {
  /// List of all indexes of this state in the corresponding controllers
  final List<int> _stateIndices = [];

  /// All `TurboController` instances that this state is attached to.
  final List<TurboController> _allControllers = [];

  /// Attach this state to a [TurboController]
  ///
  /// The state will be automatically detached from the controller when the
  ///  [dispose] function is called by the framework. If you are overriding the
  ///  [dispose] function, remember to call `super.dispose()`. Otherwise, the
  ///  state will not be detached from the controller
  ///
  /// You can provide an optional `TurboEvent` that this widget should react to
  /// and the state will be updated only if the provided events occur. Use
  /// [TurboController.event] or more specifically `yourController.event` to
  /// get the appropriate `TurboEvent` instance
  void attach<E, C extends TurboController<E>>(
    C controller, {
    TurboEvent<E>? subscribeTo,
  }) {
    _stateIndices.add(controller._attachState(this, subscribeTo));
    _allControllers.add(controller);
  }

  /// For Special use cases when controllers have to be manually detached
  /// before the widget is removed from the widget tree. Using this is purely
  /// optional, as controllers will be automatically detached from the
  /// widget/state when the framework disposes off the state.
  ///
  /// Example: if the controller object is destroyed or unusable, use this to
  /// detach it from the state
  void detachOne<C extends TurboController>(C controller) {
    int index = _allControllers.indexOf(controller);
    if (index != -1) {
      _allControllers[index]._detach(_stateIndices[index]);
      _allControllers.removeAt(index);
      _stateIndices.removeAt(index);
    }
  }

  @protected
  @mustCallSuper
  @override
  void dispose() {
    for (int i = 0; i < _stateIndices.length; i++) {
      _allControllers[i]._detach(_stateIndices[i]);
    }
    _stateIndices.clear();
    _allControllers.clear();
    super.dispose();
  }
}
