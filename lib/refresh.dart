// ignore_for_file: invalid_use_of_protected_member, avoid_print

part of turbo;

/// Refreshes the [TurboState] remotely after checking if it is actually
///  mounted in the widget tree. This also checks for [WidgetsBinding.instance],
///  so as to make sure that the `setState` method is not called while the
///  framework is building the widget.
void stateRefresh<T extends StatefulWidget>({
  required State<T> state,
  void Function()? change,
}) {
  try {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (state.mounted) {
        state.setState(change ?? () {});
      }
    });
  } catch (_) {
    try {
      if (state.mounted) {
        state.setState(change ?? () {});
      }
    } catch (error) {
      print(error);
    }
  }
}

/// Refreshes the [TurboWidget] remotely using its [TurboElement] after checking
///  if it is actually mounted in the widget tree. This also checks for
///  [WidgetsBinding.instance], so as to make sure that the `setState` method is
///  not called while the framework is building the widget.
void widgetRefresh({required TurboElement element}) {
  try {
    if (WidgetsBinding.instance.buildOwner != null) {
      WidgetsBinding.instance.buildOwner!.scheduleBuildFor(element);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        try {
          element.markNeedsBuild();
        } catch (error) {
          print(error);
        }
      });
    }
  } catch (_) {
    try {
      element.markNeedsBuild();
    } catch (error) {
      print(error);
    }
  }
}
