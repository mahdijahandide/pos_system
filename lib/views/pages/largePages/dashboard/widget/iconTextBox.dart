import 'package:flutter/material.dart';
import 'package:pos_system/views/components/texts/customText.dart';

class IconTextBox {
  Widget createIconTextBox(
      {dynamic onTap,
      dynamic highlightColor,
      dynamic width,
      dynamic height,
        dynamic padding,
      dynamic borderColor,
      dynamic borderWidth,
      required icon,
      dynamic iconSize,
      required title,
      dynamic textSize,
      dynamic fontWeight}) {
    return InkWell(
      onTap: onTap,
      highlightColor: highlightColor ?? Colors.grey,
      child: Container(
          width: width ?? 110.0,
          height: height ?? 110.0,
          padding:padding?? const EdgeInsets.all(12),
          decoration: BoxDecoration(

              border: Border.all(
                  color: borderColor ?? Colors.grey.withOpacity(0.5),
                  width: borderWidth ?? 2)),
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: iconSize ?? 42,
                ),
                CustomText().createText(
                    title: title,
                    size: textSize ?? 18,
                    fontWeight: fontWeight ?? FontWeight.bold)
              ],
            ),
          )),
    );
  }
}
