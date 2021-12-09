// ignore_for_file: invalid_use_of_protected_member, avoid_print

part of turbo;

/// Refreshes the widget remotely and after checking if it is actually mounted
///  in the widget tree. This also checks for `WidgetsBinding.instance`, so as to
///  make sure that the `setState` method is not called while the framework is
///  building the widget.
void stateRefresh<T extends StatefulWidget>({
  required State<T> state,
  void Function()? change,
}) {
  if (WidgetsBinding.instance != null) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (state.mounted) {
        state.setState(change ?? () {});
      }
    });
  } else {
    try {
      if (state.mounted) {
        state.setState(change ?? () {});
      }
    } catch (error) {
      print(error);
    }
  }
}

void widgetRefresh({required TurboElement element}) {
  if (WidgetsBinding.instance != null) {
    if (WidgetsBinding.instance!.buildOwner != null) {
      WidgetsBinding.instance!.buildOwner!.scheduleBuildFor(element);
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        try {
          element.markNeedsBuild();
        } catch (error) {
          print(error);
        }
      });
    }
  } else {
    try {
      element.markNeedsBuild();
    } catch (error) {
      print(error);
    }
  }
}
