# turbo

A super-fast, efficient state management solution for Flutter.

Turbo does not use streams, which are extremely inefficient, or use complex abstractions, which does not help with Dart's tree shaking. As we know, Dart can't remove things that are used, and as such, when there are complex abstractions, most things are not removed during compilation.

### Controller Logic

Create a controller by extending the `TurboController` class. It is important that you call the `refresh()` function after you make changes to variables. That function makes sure that all `TurboWidget`s and `TurboState`s attached to this controller gets updated after the change

```dart
class CountController extends TurboController {
    int _count = 0;
    int get count => _count;
    set count(int value) {
        _get = value;
        refresh();
    }
}

/// You can also do this if you prefer
void increment() {
    _count++;
    refresh();
}
```

### Attach Widgets/States to Controllers

Instantiate the Controller wherever you prefer it to stay. It can even be a global variable. Then attach it to a TurboState or a TurboWidget, as you prefer. Your widget will automatically react to changes according to the Controller logic that you designed.

```dart
var counter = CountController();
```
Then either attach it to a `TurboState` as follows,

```dart
class MyCounter extends StatefulWidget {
    const MyCounter({Key? key}) : super(key: key);

    TurboState<MyCounter> createState() => _MyCounterState();
}

class _MyCounterState extends TurboState<MyCounter> {
    @override
    void initState() {
        attach(counter);
        attach(secondController);
        ...
        /// Attach as many controllers as you want, of various types and purposes
        ...
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        ...
    }
}
```
Or to a `TurboWidget` as follows,
```dart

class MyCounter extends TurboWidget {
    MyCounter({Key key}) : super(key: key);
    
    @override
    void init() {
        attach(counter);
        ...
        /// Attach as many controllers as you want, of various types and purposes
        ...
    }

    @override
    Widget build(BuildContext context) {
        ...
    }
}

```

You can attach multiple controllers of different types and purposes and the widget will react to all changes in the member variables of the controllers. Keep in mind, you have to call `refresh()` function in your controller logic to trigger the updation of widgets after a change.

### Detaching controllers

**You don't have to detach the controllers on your own, as the framework will automatically handle that when the widget is removed from the widget tree or is unmounted.**

But in special scenarios where you do not want the widget to react to changes anymore, you can use the `detachOne` method to detach the widget from a controller.
```dart
detachOne(counter);
```