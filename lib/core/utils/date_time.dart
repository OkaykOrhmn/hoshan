class DateTimeUtils {
  static String getTimeFromDuration(int seconds) {
    final time = Duration(seconds: seconds);

    final min = time.inMinutes.toString().padLeft(2, '0');
    final sec = (time.inSeconds % 60).toString().padLeft(2, '0');

    return '$min:$sec';
  }
}
