import 'package:flutter/material.dart';

class CustomDropDown {
  Widget createCustomDropdown({required value, required List<String> mList}) {
    return DropdownButtonHideUnderline(
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: DropdownButton<String>(
            value: value,
            items: mList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          )),
    );
  }
}
