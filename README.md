# turbo

A super-fast, efficient state management solution for Flutter.

Turbo does not use streams, which are extremely inefficient, or use complex abstractions, which does not help with Dart's tree shaking. As we know, Dart can't remove things that are used, and as such, when there are complex abstractions, most things are not removed during compilation.