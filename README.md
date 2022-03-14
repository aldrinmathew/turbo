![Turbo](https://raw.githubusercontent.com/aldrinsartfactory/turbo/main/media/cover_wide.png)

A simple, efficient state management solution for Flutter...

Turbo does not use streams, or complex abstractions. The developer have to explicitly call the `refresh()` function to update state based on the changes. This ensures that you can be aware of those parts in your codebase that causes changes in state.

Turbo is efficient compared to other state management solutions providing controller logic, in the sense that it acheives the same result with simpler implementation and footprint. Instead of using streams or abstractions that hide complexity, it nudges the developer to leverage getters, setters and functions to acheive the result.

Complex abstractions often mean that there are a lot of interdependent code. Dart's tree shaking cannot remove things that are used (it shouldn't to begin with). But unlike what most people assume, your app is not going to contain just the things that you explicitly refer to or use in your code, after tree shaking. It will also contain all the dependencies of your app's dependencies. So in such a scenario, your app ends up including majority of the package's footprint. Also, Turbo is implemented in less than 400 lines of code (including comments), not that it matters.

### Controller Logic

Create a controller by extending the `TurboController` class. It is important that you call the `refresh()` function after you make changes to variables. That function makes sure that all `TurboWidget`s and `TurboState`s attached to this controller gets updated after the change

```dart
/// Use a normal controller
class CountController extends TurboController {
    int _count = 0;
    int get count => _count;
    set count(int value) {
        _count = value;
        /// Event parameter can be omitted
        refresh();
    }

    /// You can also do this if you prefer
    void increment() {
        _count++;
        /// Event parameter can be omitted
        refresh();
    }
}

/// Or associate an event type with the controller to use Turbo's event system
enum CountEvent { increase, decrease }

class CountController extends TurboController<CountEvent> {
    int _count = 0;
    int get count => _count;
    set count(int value) {
        _get = value;
        
        /// Using events in the `refresh` function
        /// You can also emit the `emit` parameter so that widgets that are not subscribed
        /// to any event are the only ones updated
        refresh(
            emit: value > count
                ? CountEvent.increase
                : (value < count ? CountEvent.decrease : null)
        );
    }

    /// You can also do this if you prefer
    void increment() {
        _count++;
        
        refresh(emit: CountEvents.increase);
    }
}

```

### Attach Widgets/States to Controllers

Instantiate the Controller wherever you prefer it to stay. It can even be a global variable, if you how to use it effectively. Then attach it to a TurboState or a TurboWidget, as you prefer. Your widget will automatically react to changes according to the Controller logic that you designed.

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
        /// In this case the widget will react to all changes
        attach(counter);

        /// Or provide events for the widget to react to. In this case, the
        /// widget will update only if there is an increase in `count`
        attach(
            counter,
            subscribeTo: counter.event(
                [CountEvent.increase],
                /// `after` and `before` are optional
                after: (_) => print('Value increased'),
            )
        );

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
        /// The widget will react to all changes
        attach(counter);

        /// Or provide events for the widget to react to. In this case, the
        /// widget will update only if there is an decrease in `count`
        attach(
            counter,
            subscribeTo: counter.event(
                [CountEvent.decrease],
                /// `after` and `before` are optional
                after: (_) => print('Value decreased'),
            )
        );

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

### Use `TurboBuilder` with the controllers

In order to acheive the flexibility of the controller without separating your logic for a component of the UI to a different file, use `TurboBuilder`

```dart
TurboBuilder(
    controller: counter,
    /// Optional argument to use the event system
    /// subscribeTo: counter.event([MyEvent.firstEv], after: (_) => print('Event happened')),
    builder: (myCtrl) {
        return Text(myCtrl.count.toString());
    }
)
```

### Detaching controllers

**You don't have to detach the controllers on your own, as the framework will automatically handle that when the widget is removed from the widget tree or is unmounted.**

But in special scenarios where you do not want the widget to react to changes anymore, you can use the `detachOne` method to detach the widget from a controller.
```dart
detachOne(counter);
```