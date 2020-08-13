


import 'package:flutter/material.dart';



InputDecoration getInputDecoration(String hint){
  return  InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.all(5),
      hintText: hint,
      border: InputBorder.none,
      filled: true);

}

