part of 'main.dart';

class _CalcDisplay extends StatefulWidget {
  const _CalcDisplay({
    this.hideSurroundingBorder,
    this.hideExpression,
    required this.onTappedDisplay,
    this.theme,
    required this.controller,
  });

  /// Whether to show surrounding borders.
  final bool? hideSurroundingBorder;

  /// Whether to show expression area.
  final bool? hideExpression;

  /// Visual properties for this widget.
  final CalculatorThemeData? theme;

  /// Controller for calculator.
  final CalcController controller;

  /// Called when the display area is tapped.
  final Function(double?, TapDownDetails)? onTappedDisplay;

  @override
  _CalcDisplayState createState() => _CalcDisplayState();
}

class _CalcDisplayState extends State<_CalcDisplay> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeCalcValue);
  }

  @override
  void didUpdateWidget(_CalcDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_didChangeCalcValue);
      widget.controller.addListener(_didChangeCalcValue);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeCalcValue);
    super.dispose();
  }

  void _didChangeCalcValue() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final borderSide = Divider.createBorderSide(
      context,
      color: widget.theme?.borderColor ?? Theme.of(context).dividerColor,
      width: widget.theme?.borderWidth ?? 1.0,
    );
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: widget.hideSurroundingBorder! ? BorderSide.none : borderSide,
          left: widget.hideSurroundingBorder! ? BorderSide.none : borderSide,
          right: widget.hideSurroundingBorder! ? BorderSide.none : borderSide,
          bottom: widget.hideSurroundingBorder! ? borderSide : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) => widget.onTappedDisplay == null
                  ? null
                  : widget.onTappedDisplay!(widget.controller.value, details),
              child: Container(
                color: widget.theme?.displayColor,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: AutoSizeText(
                      widget.controller.display!,
                      style: widget.theme?.displayStyle ??
                          const TextStyle(fontSize: 50),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !widget.hideExpression!,
            child: Expanded(
              child: Container(
                color: widget.theme?.expressionColor,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      widget.controller.expression!,
                      style: widget.theme?.expressionStyle ??
                          const TextStyle(color: Colors.grey),
                      maxLines: 1,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
