// TODO: Autogen from CustomOptions.java
import 'package:flutter/material.dart';

class CustomOptions {
  final Color? headlineTextColor;
  final Color? bodyTextColor;
  final Color? backgroundColor;
  final Color? ctaBackgroundColor;
  final Color? ctaTextColor;
  final Color? secondaryTextColor;

  CustomOptions(
      {this.headlineTextColor,
      this.bodyTextColor,
      this.backgroundColor,
      this.ctaBackgroundColor,
      this.ctaTextColor,
      this.secondaryTextColor});

  Map<String, Object> convertToMap() {
    Map<String, Object> options = {};
    if (bodyTextColor != null) {
      options['bodyTextColor'] = _colorToString(bodyTextColor!);
    }

    if (headlineTextColor != null) {
      options['headlineTextColor'] = _colorToString(headlineTextColor!);
    }

    if (backgroundColor != null) {
      options['backgroundColor'] = _colorToString(backgroundColor!);
    }

    if (ctaBackgroundColor != null) {
      options['ctaBackgroundColor'] = _colorToString(ctaBackgroundColor!);
    }

    if (ctaTextColor != null) {
      options['ctaTextColor'] = _colorToString(ctaTextColor!);
    }

		if (secondaryTextColor != null) {
			options['secondaryTextColor'] = _colorToString(secondaryTextColor!);
		}

    return options;
  }

  String _colorToString(Color color) {
    return '#${color.toString().split('(0x')[1].split(')').first.substring(2).toUpperCase()}';
  }
}
