import 'package:flutter/material.dart';

import '../texts/customText.dart';

class CustomTextButton {
  Widget createTextButton(
      {required String buttonText,
      dynamic textSize,
        dynamic borderColor,
        dynamic borderRadius,
      required buttonColor,
      dynamic icon,dynamic elevation,
        dynamic onPress,
      required textColor}) {
    return TextButton.icon(
      style: ButtonStyle(elevation: MaterialStateProperty.all(elevation??8),backgroundColor: MaterialStateProperty.all(
          buttonColor?? Colors.teal),shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 15.0),
              side:  BorderSide(color: borderColor ?? buttonColor),
          ),

      )),
      icon:  icon?? const SizedBox(),
      label: CustomText().createText(title: buttonText,size: textSize??16,color: textColor??Colors.white),
      onPressed: onPress??(){},
    );
  }
}
