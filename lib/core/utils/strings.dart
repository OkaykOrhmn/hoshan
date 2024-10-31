extension Allph on String {
  bool startsWithEnglish() {
    // Regular expression to check if the first character is an English letter
    return RegExp(r'^[A-Za-z]').hasMatch(this);
  }

  bool startsWithPersian() {
    // Regular expression to check if the first character is a Persian letter
    return RegExp(r'^[\u0600-\u06FF]').hasMatch(this);
  }
}
