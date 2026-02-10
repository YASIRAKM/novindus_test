extension StringValidation on String? {
  

  bool get isValidPhone {
    if (this == null) return false;
    
    final phoneRegex = RegExp(r'^\d{10,12}$');
    return phoneRegex.hasMatch(this!);
  }

  bool get isValidName {
    if (this == null || this!.trim().isEmpty) return false;
    return this!.length >= 3;
  }

  bool get isValidPassword {
    if (this == null) return false;
    return this!.length >= 6;
  }

  bool get isNullOrEmpty {
    return this == null || this!.trim().isEmpty;
  }
}
