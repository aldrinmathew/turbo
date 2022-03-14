// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:turbo/turbo.dart';

/// Creating events for the controller. Enums are recommended for most
/// scenarios, but you can also use classes for expanded functionality
enum CountEvent { increase, decrease }

/// file: count_controller.dart

/// Specify the type of the event to be associated with this controller
///
/// If you don't need events, just omit the type parameter
class CountController extends TurboController<CountEvent> {
  int _count = 0;
  int get count => _count;
  set count(int value) {
    _count = value;

    /// Using events in the refresh function
    /// You can also emit the `event` parameter so that widgets that are not subscribed
    /// to any event are the only ones updated
    refresh(
      emit: value > count
          ? CountEvent.increase
          : (value < count ? CountEvent.decrease : null),
    );
  }

  void increment() {
    _count++;

    /// `emit` parameter can be omitted
    refresh(emit: CountEvent.increase);
  }

  void decrement() {
    _count--;

    /// `emit` parameter can be omitted
    refresh(emit: CountEvent.decrease);
  }
}

/// Any file - `counter` can even be a global variable

CountController counter = CountController();

/// Using `TurboState`

class MyCounter extends StatefulWidget {
  const MyCounter({Key? key}) : super(key: key);

  @override
  TurboState<MyCounter> createState() => _MyCounterState();
}

class _MyCounterState extends TurboState<MyCounter> {
  @override
  void initState() {
    /// Widget's state will be updated for all events
    attach(counter);

    /// Or you can provide `watch` like below so that the widget is updated only
    /// for the specified events.
    ///
    /// In the following scenario, the widget's state will only update if the
    /// count value increases.
    attach(
      counter,
      subscribeTo: counter.event(
        [CountEvent.increase],

        /// `after` and `before` arguments are optional
        // ignore: avoid_print
        after: (_) => print('Value increased'),
      ),
    );

    /// Attach as many controllers as you want, of various types and purposes
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              counter.count.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            MaterialButton(
              child: const Text('Add'),
              onPressed: () {
                counter.count++;
              },
            ),
            MaterialButton(
              child: const Text('Subtract'),
              onPressed: () {
                counter.decrement();
              },
            ),
            MaterialButton(
              child: const Text('Reset'),
              onPressed: () {
                counter.count = 0;
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Using `TurboWidget`

class MyCounterWidget extends TurboWidget {
  MyCounterWidget({Key? key}) : super(key: key);

  @override
  void init() {
    /// Widget's state will be updated for all events
    attach(counter);

    /// Or you can use `TurboEvent` like below so that the widget is updated only
    /// for the specified events.
    ///
    /// In the following scenario, the widget's state will only update if the
    /// count value decreases.
    attach(
      counter,
      subscribeTo: counter.event(
        [CountEvent.decrease],

        /// `after` and `before` arguments are optional
        // ignore: avoid_print
        after: (_) => print('Value decreased'),
      ),
    );

    /// Attach as many controllers as you want, of various types and purposes
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              counter.count.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            MaterialButton(
              child: const Text('Add'),
              onPressed: () {
                counter.count++;
              },
            ),
            MaterialButton(
              child: const Text('Subtract'),
              onPressed: () {
                counter.decrement();
              },
            ),
            MaterialButton(
              child: const Text('Reset'),
              onPressed: () {
                counter.count = 0;
              },
            ),
          ],
        ),
      ),
    );
  }
}
