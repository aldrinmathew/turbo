part of turbo;

/// An [Element] that uses a [TurboWidget] as its configuration.
class TurboElement extends ComponentElement {
  /// Creates an element that uses the given widget as its configuration.
  TurboElement(TurboWidget widget) : super(widget);

  @override
  TurboWidget get widget => super.widget as TurboWidget;

  @override
  Widget build() => widget.build(this);

  @override
  void update(TurboWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    markNeedsBuild();
    rebuild();
  }

  @override
  void unmount() {
    widget._detach();
    super.unmount();
  }
}
