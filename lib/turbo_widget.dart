// ignore_for_file: must_be_immutable

part of turbo;

abstract class TurboWidget<C extends TurboController> extends Widget {
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
  ///
  /// See also:
  ///
  ///  * [TurboWidget], which contains the discussion on performance considerations.
  @protected
  Widget build(BuildContext context);

  abstract void Function() init;

  final List<int> _widgetIndices = [];
  final List<C> _allControllers = [];

  void attach(C controller) {
    _widgetIndices.add(controller._attachWidget(this));
    _allControllers.add(controller);
  }

  void _detach() {
    for (int i = 0; i < _widgetIndices.length; i++) {
      _allControllers[i]._detach(_widgetIndices[i]);
    }
    _allControllers.clear();
    _widgetIndices.clear();
  }
}
