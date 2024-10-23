import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DateTimeUtils {
  static String getTimeFromDuration(int seconds) {
    final time = Duration(seconds: seconds);

    final min = time.inMinutes.toString().padLeft(2, '0');
    final sec = (time.inSeconds % 60).toString().padLeft(2, '0');

    return '$min:$sec';
  }

  static DateTime convertStringIsoToDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return dateTime;
  }

  static String convertDateToStringInFormatted(DateTime date,
      {final String? formatted}) {
    String formattedDate =
        DateFormat(formatted ?? 'yyyy-MM-dd – kk:mm').format(date);
    return formattedDate;
  }

  static String convertStringIsoToStringInFormatted(
    String isoDate,
  ) {
    DateTime dateTime = DateTime.parse(isoDate);

    final persianDate = Jalali.fromDateTime(dateTime);

    return '${persianDate.year.toString().padLeft(2, '0')}-${persianDate.month.toString().padLeft(2, '0')}-${persianDate.day.toString().padLeft(2, '0')} - ${persianDate.hour.toString().padLeft(2, '0')}:${persianDate.minute.toString().padLeft(2, '0')} ';
  }
}
