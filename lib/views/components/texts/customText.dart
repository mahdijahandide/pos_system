import 'package:flutter/material.dart';

class CustomText {
  Widget createText(
      {required title,
      dynamic size,
      dynamic color,
      dynamic fontWeight,
      dynamic align}) {
    return Text(
      title,
      textAlign: align,
      style: TextStyle(
          fontSize: size == null ? 14.0 : size.toDouble(),
          fontWeight: fontWeight,
          color: color),
    );
  }

  Widget createSpaceKeyVal(
      {required keyText,
      required valText,
      dynamic keyFontWeight,
        dynamic mainAlignment,
      dynamic valFontWeight,
        dynamic padding,
        dynamic keySize,
        dynamic valSize,
      dynamic keyColor,
      dynamic valColor}) {
    return Padding(
      padding: padding?? const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment:mainAlignment?? MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$keyText',
            style: TextStyle(fontWeight: keyFontWeight, color: keyColor,fontSize: keySize??18),
            textAlign: TextAlign.start,
          ),
          Text(
            '$valText',
            style: TextStyle(fontWeight: valFontWeight, color: valColor,fontSize: valSize??18),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget createBorderText(
      {required borderColor,
      required title,
      dynamic bgColor,
      dynamic weight,
      dynamic align,
      dynamic borderWidth,
      dynamic textColor,
      dynamic padding,
      dynamic textSize}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
              color: borderColor,
              width: borderWidth ?? 2.0)),
      child: Center(
          child: CustomText().createText(
              title: '$title',
              align: align,
              color: textColor,
              size: textSize,
              fontWeight: weight)),
    );
  }
}
