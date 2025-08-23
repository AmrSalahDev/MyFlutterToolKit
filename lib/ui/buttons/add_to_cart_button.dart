import 'package:flutter/material.dart';

class AddToCartButton extends StatefulWidget {
  final Function(int value) onIncrement;
  final Function(int value) onDecrement;
  final Color backgroundColor;
  final Color countColor;
  final Color borderColor;
  final Color iconColor;
  final TextStyle? countTextStyle;
  final double borderWidth;
  final double borderRadius;
  final double height;
  final double width;
  final double initialSize;
  final BoxShape initialShape;
  final Duration animationDuration;
  final int maxQuantity;
  final int minQuantity;

  const AddToCartButton({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
    required this.maxQuantity,
    this.minQuantity = 0,
    this.backgroundColor = Colors.white,
    this.countColor = Colors.black,
    this.borderColor = Colors.white,
    this.iconColor = Colors.black,
    this.borderWidth = 1.0,
    this.borderRadius = 10.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.height = 40.0,
    this.width = 100.0,
    this.initialSize = 40.0,
    this.initialShape = BoxShape.circle,
    this.countTextStyle,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final bool isAdded = quantity > widget.minQuantity;
    return AnimatedContainer(
      duration: widget.animationDuration,
      width: isAdded ? widget.width : widget.initialSize,
      height: isAdded ? widget.height : widget.initialSize,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(
          widget.initialShape == BoxShape.circle
              ? widget.height / 2
              : widget.borderRadius,
        ),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: widget.animationDuration,
            opacity: isAdded ? 1 : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: AnimatedSlide(
                    offset: isAdded ? Offset(0, 0) : Offset(-0.5, 0),
                    duration:
                        widget.animationDuration +
                        const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    child: GestureDetector(
                      onTap: () {
                        if (quantity >= widget.minQuantity) {
                          setState(() {
                            quantity--;
                            widget.onDecrement.call(quantity);
                          });
                        }
                      },
                      child: Icon(Icons.remove, color: widget.iconColor),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$quantity',
                      style:
                          widget.countTextStyle ??
                          TextStyle(
                            color: widget.countColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedSlide(
                    offset: isAdded ? Offset(0, 0) : Offset(0.5, 0),
                    duration:
                        widget.animationDuration +
                        const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    child: Opacity(
                      opacity: (quantity >= widget.maxQuantity) ? 0.4 : 1,
                      child: GestureDetector(
                        onTap: () {
                          if (quantity < widget.maxQuantity) {
                            setState(() {
                              quantity++;
                              widget.onIncrement.call(quantity);
                            });
                          }
                        },
                        child: Icon(Icons.add, color: widget.iconColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IgnorePointer(
            ignoring: isAdded,
            child: AnimatedOpacity(
              duration: widget.animationDuration.inMilliseconds >= 200
                  ? widget.animationDuration - const Duration(milliseconds: 100)
                  : widget.animationDuration,
              opacity: isAdded ? 0 : 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    quantity++;
                    widget.onIncrement.call(quantity);
                  });
                },
                child: Center(child: Icon(Icons.add, color: widget.iconColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
