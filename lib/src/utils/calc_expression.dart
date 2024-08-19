import 'package:flutter/foundation.dart';
import 'package:flutter_simple_calculator/src/utils/calc_display.dart';
import 'package:math_expressions/math_expressions.dart';

/// Expression for the [Calculator].
class CalcExpression {
  final Parser parser = Parser();
  final ContextModel evaluatorContext = ContextModel();
  final String zeroDigit;

  String value = '';
  String internal = '';
  String? _op;
  String? _right;
  String? _rightInternal;
  String? _left;
  String? _lefInternal;

  /// Create a [CalcExpression] with [zeroDigit].
  CalcExpression({this.zeroDigit = '0'});

  void clear() {
    value = '';
    internal = '';
    _op = null;
    _right = null;
    _left = null;
    _lefInternal = null;
    _rightInternal = null;
  }

  bool needClearDisplay() {
    return _op != null && _right == null;
  }

  /// Perform operations.
  num operate() {
    try {
      return parser
          .parse(internal)
          .evaluate(EvaluationType.REAL, evaluatorContext);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return double.nan;
  }

  void repeat(CalcDisplay val) {
    if (_right != null) {
      _left = value = val.string;
      _lefInternal = internal = val.value.toString();
      value = '$_left $_op $_right';
      internal = '$_lefInternal${_convertOperator()}$_rightInternal';
      val.setValue(operate().toDouble());
    }
  }

  /// Set the operation. The [op] must be either +, -, ×, or ÷.
  void setOperator(String op) {
    _left ??= _lefInternal = zeroDigit;
    if (_right != null) {
      _left = '$_left $_op $_right';
      _lefInternal = '$_lefInternal${_convertOperator()}$_rightInternal';
      _right = _rightInternal = null;
    }
    _op = op;
    value = '$_left $_op ?';
  }

  /// Set percent value. The [string] is a string representation and [percent] is a value.
  double setPercent(String string, double percent) {
    double? base = 1.0;
    if (_op == '+' || _op == '-') {
      base = parser
          .parse(_lefInternal!)
          .evaluate(EvaluationType.REAL, evaluatorContext);
    }
    var val = base! * percent / 100;
    if (_op == null) {
      _left = value = string;
      _lefInternal = internal = val.toString();
      return val;
    } else {
      _right = string;
      _rightInternal = val.toString();
      value = '$_left $_op $_right';
      internal = '$_lefInternal${_convertOperator()}$val';
      return val;
    }
  }

  /// Set value with [CalcDisplay].
  void setVal(CalcDisplay val) {
    if (_op == null) {
      _left = value = val.string;
      _lefInternal = internal = val.value.toString();
    } else {
      _right = val.string;
      _rightInternal = val.value.toString();
      value = '$_left $_op $_right';
      internal = '$_lefInternal${_convertOperator()}$_rightInternal';
    }
  }

  String _convertOperator() {
    return _op!.replaceFirst('×', '*').replaceFirst('÷', '/');
  }
}
