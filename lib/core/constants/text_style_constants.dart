import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_constants.dart';

class TextStyleConstants {

  static final TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static final TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static final TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

 
  static final TextStyle bodyRegular = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );

  static final TextStyle bodyRegularBig = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );

  static final TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 13,
    color: AppColors.textLight,
  );

  
  static final TextStyle labelStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static final TextStyle hintStyle = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.textLight,
  );

  static final TextStyle inputTextStyle = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.text,
  );

  static final TextStyle link = GoogleFonts.poppins(
    fontSize: 13,
    color: AppColors.link,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle actionText = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.text,
    fontWeight: FontWeight.w500,
  );

  
  static final TextStyle cardTitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static final TextStyle cardSubtitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryLight,
  );

  static final TextStyle cardInfo = GoogleFonts.poppins(
    fontSize: 16,
    color: AppColors.textLight,
  );

  static InputDecoration inputDecoration({
    required String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool filled = true,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: hintStyle,
      filled: filled,
      fillColor: AppColors.textFieldFill,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}
