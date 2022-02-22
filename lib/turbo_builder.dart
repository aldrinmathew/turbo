part of turbo;

/// [TurboBuilder] enables you to create resposive widgets or components of the
/// UI without separating that part of the UI to a different file. This adds
/// flexibility to the workflow.
///
/// Provide the controller to which the Builder should respond to and the state
/// of this widget will update automatically depending on your state design.
class TurboBuilder<T extends TurboController> extends StatefulWidget {
  const TurboBuilder({
    Key? key,
    required this.controller,
    required this.builder,
  }) : super(key: key);

  /// A [TurboController] instance that this widget should react to
  final T controller;

  /// A builder function that makes use of the provided controller and returns
  /// a widget
  final Widget Function(T ctrl) builder;

  @override
  _TurboBuilderState createState() => _TurboBuilderState();
}

class _TurboBuilderState<T extends TurboController>
    extends TurboState<TurboBuilder<T>> {
  @override
  void initState() {
    attach(widget.controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(widget.controller);
  }
}
