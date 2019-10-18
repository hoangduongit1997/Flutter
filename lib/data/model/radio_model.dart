import 'package:flutter/material.dart';

class RadioModel {
  bool isSelected;
  int codeStatus;
  final String buttonText;
  final String text;
  Color color;

  RadioModel(this.isSelected,this.codeStatus, this.buttonText, this.text, this.color);
}
