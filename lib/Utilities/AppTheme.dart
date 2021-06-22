import 'dart:ui';

import 'package:beauty_spin/Constants/ColorConstants.dart';
import 'package:flutter/material.dart';

final double kNormalFontSize = 12;
final double kBoldFontSize = 16;
final double kButtonFontSize = 14;
final double kTextFieldFontSize = 18;
final double kTitleFontSize = 20;

TextStyle get kBlueTextTheme => TextStyle().copyWith(
    fontSize: kNormalFontSize,
    fontWeight: FontWeight.w500,
    color: cAppThemeColor);

TextStyle get kWhiteTextTheme => TextStyle().copyWith(
    fontSize: kNormalFontSize, fontWeight: FontWeight.w400, color: cWhiteColor);

TextStyle get kBlueTextButtonTheme => TextStyle().copyWith(
    fontSize: kButtonFontSize,
    fontWeight: FontWeight.w600,
    color: cAppThemeColor);

TextStyle get kPlaceHolderGrayTextStyle =>
    TextStyle(color: cMediumGrayColor, fontSize: 16);
