part of turbo;

/// An [Element] that uses a [TurboWidget] as its configuration.
class TurboElement extends ComponentElement {
  /// Creates an element that uses the given widget as its configuration.
  TurboElement(TurboWidget widget) : super(widget);

  /// The configuration for this element
  @override
  TurboWidget get widget => super.widget as TurboWidget;

  /// Subclasses should override this function to actually call the appropriate
  /// `build` function (e.g., [StatelessWidget.build] or [State.build]) for
  /// their widget.
  @override
  Widget build() => widget.build(this);

  /// Change the widget used to configure this element.
  ///
  /// The framework calls this function when the parent wishes to use a different widget to configure this element. The new widget is guaranteed to have the same [runtimeType] as the old widget.
  ///
  /// This function is called only during the "active" lifecycle state.
  @override
  void update(TurboWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    markNeedsBuild();
    rebuild();
  }

  /// Transition from the "inactive" to the "defunct" lifecycle state.
  ///
  /// Called when the framework determines that an inactive element will never
  /// be reactivated. At the end of each animation frame, the framework calls
  /// [unmount] on any remaining inactive elements, preventing inactive elements
  /// from remaining inactive for longer than a single animation frame.
  ///
  /// After this function is called, the element will not be incorporated into
  /// the tree again.
  ///
  /// Any resources this element holds should be released at this point. For
  /// example, [RenderObjectElement.unmount] calls [RenderObject.dispose] and
  /// nulls out its reference to the render object.
  ///
  /// See the lifecycle documentation for [Element] for additional information.
  ///
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.unmount()`.
  @override
  @mustCallSuper
  void unmount() {
    /// Detaches the corresponding `TurboWidget` from the `TurboController` when
    ///  the element is unmounted from the widget tree.
    widget._detach();
    super.unmount();
  }
}
