import 'package:flutter/material.dart';

class NativeSelect{
  Widget nativeSelect({required title}){
    return Container(
      height: 50.0,
      padding: const EdgeInsets.only(
          left: 8.0, right: 8.0),
      margin: const EdgeInsets.only(bottom: 6.0),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey
                  .withOpacity(0.5))),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment
            .spaceBetween,
        children: [
          const Icon(Icons.arrow_drop_down),
          Text(
            '$title',
            textDirection:
            TextDirection.rtl,
          )
        ],
      ),
    );
  }
}