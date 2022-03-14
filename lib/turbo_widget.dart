// ignore_for_file: must_be_immutable

part of turbo;

/// Replacement for [StatelessWidget] but with the ability to respond to changes
///  in attached [TurboController] instances.
///
/// You cannot use `const` constructor for this widget, as a const widget cannot
///  respond to changes
///
/// ```
/// class MyWidget extends TurboWidget {
///   /// You cannot use `const` constructor for this widget, as a const widget
///   /// cannot respond to changes
///   MyWidget({ Key? key }): super(key: key);
///
///   /// Called by the framework when this widget is inserted into the widget
///   ///  tree.
///   @override
///   void init() {
///     attach(myFirstController);
///     attach(mySecondController);
///     ...
///     /// Attach as many controllers that this widget should respond the
///     ///  changes of, to
///     ...
///   }
///
///   ...
/// }
/// ```
abstract class TurboWidget extends Widget {
  /// Initializes [key] for subclasses.
  TurboWidget({Key? key}) : super(key: key);

  TurboElement? element;

  /// Creates a [TurboElement] to manage this widget's location in the tree.
  ///
  /// It is uncommon for subclasses to override this method.
  @override
  TurboElement createElement() {
    element = TurboElement(this);
    init();
    return element!;
  }

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree
  /// in a given [BuildContext] and when the dependencies of this widget change
  /// (e.g., an [InheritedWidget] referenced by this widget changes). This
  /// method can potentially be called in every frame and should not have any side
  /// effects beyond building a widget.
  ///
  /// The framework replaces the subtree below this widget with the widget
  /// returned by this method, either by updating the existing subtree or by
  /// removing the subtree and inflating a new subtree, depending on whether the
  /// widget returned by this method can update the root of the existing
  /// subtree, as determined by calling [Widget.canUpdate].
  ///
  /// Typically implementations return a newly created constellation of widgets
  /// that are configured with information from this widget's constructor and
  /// from the given [BuildContext].
  ///
  /// The given [BuildContext] contains information about the location in the
  /// tree at which this widget is being built. For example, the context
  /// provides the set of inherited widgets for this location in the tree. A
  /// given widget might be built with multiple different [BuildContext]
  /// arguments over time if the widget is moved around the tree or if the
  /// widget is inserted into the tree in multiple places at once.
  ///
  /// The implementation of this method must only depend on:
  ///
  /// * the fields of the widget, which themselves must not change over time,
  ///   and
  /// * any ambient state obtained from the `context` using
  ///   [BuildContext.dependOnInheritedWidgetOfExactType].
  ///
  /// If a widget's [build] method is to depend on anything else, use a
  /// [StatefulWidget] instead.
  @protected
  Widget build(BuildContext context);

  /// Called by the framework when the corresponding element of this widget is
  ///  initialized.
  void init();

  /// List of all indexes of this widget in the corresponding controllers
  final List<int> _widgetIndices = [];

  /// All `TurboController` instances that this widget is attached to.
  final List<TurboController> _allControllers = [];

  /// Attach this widget to a [TurboController]
  ///
  /// You can provide an optional `TurboEvent` that this widget should react to
  /// and the state will be updated only if the provided events occur. Use
  /// [TurboController.event] or more specifically `yourController.event` to
  /// get the appropriate `TurboEvent` instance
  void attach<E, C extends TurboController<E>>(
    C controller, {
    TurboEvent<E>? subscribeTo,
  }) {
    if (!_allControllers.contains(controller)) {
      _widgetIndices.add(controller._attachWidget(this, subscribeTo));
      _allControllers.add(controller);
    }
  }

  /// For Special use cases when controllers have to be manually detached
  ///  before the widget is removed from the widget tree. Using this is purely
  ///  optional, as controllers will be automatically detached from the widget
  ///  when the framework removes the widget's element.
  ///
  /// Example: if the controller object is destroyed or unusable, use this to
  /// detach it from the state
  void detachOne<C extends TurboController>(C controller) {
    int index = _allControllers.indexOf(controller);
    if (index != -1) {
      _allControllers[index]._detach(_widgetIndices[index]);
      _allControllers.removeAt(index);
      _widgetIndices.removeAt(index);
    }
  }

  /// Detaches this widget from a [TurboController]
  ///
  /// This is automatically called by the corresponding [TurboElement] when that
  ///  element is unmounted from the widget tree by the framework
  void _detach() {
    for (int i = 0; i < _widgetIndices.length; i++) {
      _allControllers[i]._detach(_widgetIndices[i]);
    }
    _allControllers.clear();
    _widgetIndices.clear();
  }
}
