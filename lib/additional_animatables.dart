library additional_animatables;

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class ShiftedAnimation extends Animatable<double> {
  final double shift;

  ShiftedAnimation(this.shift);

  @override
  double transform(double t) {
    var newT = t + this.shift;
    if (newT < 0 || newT > 1) {
      newT = newT - newT.floor();
    }
    return newT;
  }
}

class KeyFrame<T> {
  final double position;
  final T value;

  KeyFrame(this.position, this.value);
}

class KeyframesAnimation<T extends dynamic> extends Animatable<T> {
  static const EPSILON = 0.00001;
  final List<KeyFrame<T>> keyframes;

  // TODO: asserts?
  KeyframesAnimation(this.keyframes)
      : assert(keyframes.first.position == 0.0),
        assert(keyframes.last.position == 1.0);

  @override
  T transform(double t) {
    var nextIdx = keyframes.indexWhere((element) => element.position >= t);
    var next = keyframes[nextIdx];
    if (next.position <= t + EPSILON) {
      return next.value;
    }
    assert(nextIdx > 0);
    var previous = keyframes[nextIdx - 1];
    final ret = lerp(previous, next, t);
    return ret;
  }

  @protected
  T lerp(KeyFrame<T> begin, KeyFrame<T> end, double t) {
    return (end.value - begin.value) * (t - begin.position)/ (end.position - begin.position) + begin.value;
  }
}

