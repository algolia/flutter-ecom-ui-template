import 'package:flutter/material.dart';

class HighlightedString {

  String string;
  bool isHighlighted;

  HighlightedString(this.string, this.isHighlighted);

  @override
  String toString() {
    return (isHighlighted ? ">" : "") + "$string";
  }

}