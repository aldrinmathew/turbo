part of turbo;

/// [TurboBuilder] enables you to create resposive widgets or components of the
/// UI without separating that part of the UI to a different file. This adds
/// flexibility to the workflow.
///
/// Provide the controller to which the Builder should respond to and the state
/// of this widget will update automatically depending on your state design.
///
/// You also have the option to provide a `TurboEvent` instance to
/// `subscribeTo` so that the builder will update only for the specified
/// events
class TurboBuilder<E, T extends TurboController<E>> extends StatefulWidget {
  /// [TurboBuilder] enables you to create resposive widgets or components of the
  /// UI without separating that part of the UI to a different file. This adds
  /// flexibility to the workflow.
  ///
  /// Provide the controller to which the Builder should respond to and the
  /// state of this widget will update automatically depending on your state
  /// design.
  ///
  /// You also have the option to provide a `TurboEvent` instance to
  /// `subscribeTo` so that the builder will update only for the specified
  /// events
  const TurboBuilder({
    Key? key,
    required this.controller,
    required this.builder,
    this.subscribeTo,
  }) : super(key: key);

  /// A [TurboController] instance that this widget should react to
  final T controller;

  /// A builder function that makes use of the provided controller and returns
  /// a widget
  final Widget Function(T ctrl) builder;

  /// The `TurboEvent` this builder should react to. This can be null, in which
  /// case all this widget will react to all updates
  final TurboEvent<E>? subscribeTo;

  @override
  _TurboBuilderState createState() => _TurboBuilderState();
}

class _TurboBuilderState<E, T extends TurboController<E>>
    extends TurboState<TurboBuilder<E, T>> {
  @override
  void initState() {
    attach(
      widget.controller,
      subscribeTo: widget.subscribeTo,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(widget.controller);
  }
}
