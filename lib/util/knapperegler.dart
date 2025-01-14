import 'package:intl/intl.dart';

class Util {
  static String timeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Aldri';
    }
    final Duration difference = DateTime.now().toUtc().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} dager siden';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} timer og ${difference.inMinutes.remainder(60).abs()} minutter siden';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutter siden';
    } else {
      return 'Nettopp';
    }
  }

  static String format(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Aldri';
    }
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toUtc());
  }
}
