/// Signature for callbacks that report that the [SimpleCalculator] value has changed.
typedef CalcChanged = void Function(
  String? key,
  double? value,
  String? expression,
);
