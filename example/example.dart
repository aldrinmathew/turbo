// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:turbo/turbo.dart';

/// file: count_controller.dart

class CountController extends TurboController {
  int _count = 0;
  int get count => _count;
  set count(int value) {
    _count = value;
    refresh();
  }

  void increment() {
    _count++;
    refresh();
  }

  void decrement() {
    _count--;
    refresh();
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
    attach(counter);

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
    attach(counter);

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
