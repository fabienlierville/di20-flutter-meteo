import 'package:flutter/material.dart';

class CustomText extends Text {

  CustomText(String data, {textAlign: TextAlign.center, color: Colors.white, fontSize: 15.0, fontStyle: FontStyle.normal, overflow: TextOverflow.visible }):
        super(
          (data==null?" ":data),
          textAlign: textAlign,
          overflow: overflow,
          style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontStyle: fontStyle
          )
      );
}
