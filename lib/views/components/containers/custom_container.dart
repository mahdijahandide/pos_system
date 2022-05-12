import 'package:flutter/material.dart';

class CustomContainer {
  Widget createContainer(
      {dynamic bgColor,
      dynamic borderColor,
      dynamic borderRadius,
      dynamic borderWidth,
      dynamic shadow,
      dynamic padding,
      dynamic margin,
      double? containerWith,
      dynamic hasBorder,
      dynamic align,
      double? containerHeight,
        BoxConstraints? constraints,
      dynamic child}) {
    return Container(
      padding: padding,
      margin: margin,
      alignment: align,
      constraints :
      (containerWith != null || containerHeight != null)
          ? constraints?.tighten(width: containerWith, height: containerHeight)
          ?? BoxConstraints.tightFor(width: containerWith, height: containerHeight)
          : constraints,
      decoration: BoxDecoration(
          border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 1.0),
          color: bgColor??Colors.white,
          borderRadius: BorderRadius.circular(
              borderRadius != null ? borderRadius.toDouble() : 0.0),
          boxShadow: [shadow ?? const BoxShadow()]),
      child: child,
    );
  }
}
