part of turbo;

abstract class TurboState<S extends StatefulWidget, C extends TurboController>
    extends State<S> {
  final List<int> _stateIndices = [];
  final List<C> _allControllers = [];

  void attach(C controller) {
    _stateIndices.add(controller._attachState(this));
    _allControllers.add(controller);
  }

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
