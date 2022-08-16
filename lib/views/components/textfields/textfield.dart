import 'package:flutter/material.dart';

class CustomTextField {
  Widget createTextField(
      {Key? key,
      required hint,
      dynamic hasPrefixIcon,
      dynamic hasSuffixIcon,
      dynamic suffixPress,
      dynamic prefixPress,
      dynamic obscure,
      required height,
      dynamic bg,
      dynamic prefixIcon,
      dynamic suffixIcon,
      dynamic node,
      dynamic textInputAction,
      dynamic keyboardType,
      dynamic inputFormatters,
      dynamic hintStyle,
      dynamic maxLines,
      dynamic align,
      dynamic onSubmitted,
      dynamic onTap,
      dynamic autoFocus,
      dynamic maxLength,
      dynamic controller,
      dynamic borderColor}) {
    return Container(
      height: height.toDouble(),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? const Color(0xffdcdcdc)),
          color: bg ?? Colors.white),
      child: TextField(
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          autofocus: autoFocus ?? false,
          onTap: onTap,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          focusNode: node,
          obscureText: obscure != null ? true : false,
          maxLength: maxLength,
          controller: controller,
          maxLines: maxLines ?? 1,
          textAlign: align ?? TextAlign.start,
          decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: hint,
              hintStyle: hintStyle,
              suffixIcon: hasSuffixIcon == true
                  ? IconButton(
                      alignment: Alignment(1.0, -1.0),
                      onPressed: suffixPress,
                      icon: Icon(
                        suffixIcon ?? Icons.search,
                      ),
                    )
                  : null,
              prefixIcon: hasPrefixIcon == true
                  ? IconButton(
                      onPressed: prefixPress,
                      icon: Icon(
                        prefixIcon ?? Icons.search,
                      ),
                    )
                  : null)),
    );
  }
}
