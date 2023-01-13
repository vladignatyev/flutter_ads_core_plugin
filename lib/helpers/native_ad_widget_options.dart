import 'package:flutter/material.dart';

class NativeAdWidgetOptions {
  final Color? headlineColor;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final bool showMedia;
  final double heightWithoutMedia;
  final double heightWithMedia;

  NativeAdWidgetOptions(
      {this.headlineColor,
      this.textColor,
      this.backgroundColor,
      this.buttonColor,
      this.buttonTextColor,
      this.showMedia = false,
      this.heightWithoutMedia = 150,
      this.heightWithMedia = 350});

  Map<String, Object> convertToMap() {
    Map<String, Object> options = {};
    if (textColor != null) {
      options['bodyTextColor'] = _colorToString(textColor!);
    }

    if (headlineColor != null) {
      options['headlineColor'] = _colorToString(headlineColor!);
    }

    if (backgroundColor != null) {
      options['backgroundColor'] = _colorToString(backgroundColor!);
    }

    if (buttonColor != null) {
      options['buttonBackground'] = _colorToString(buttonColor!);
    }

    if (buttonTextColor != null) {
      options['buttonTextColor'] = _colorToString(buttonTextColor!);
    }

    return options;
  }

  String _colorToString(Color color) {
    return '#${color.toString().split('(0x')[1].split(')').first.substring(2).toUpperCase()}';
  }
}
