import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Util {
  static String timeAgo(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Ikke registrert';
    }
    var tid = TimeOfDay.fromDateTime(dateTime.toLocal());
    String formattedTime =
        '${tid.hour.toString().padLeft(2, '0')}:${tid.minute.toString().padLeft(2, '0')}';

    if (dateTime.toLocal().day == DateTime.now().toLocal().day) {
      return 'Sist i dag $formattedTime';
    } else if (dateTime.toLocal().day == DateTime.now().toLocal().day - 1) {
      return 'Sist i går $formattedTime';
    }
    return 'Sist for ${Util.daysBetween(dateTime, DateTime.now().toLocal())} dager siden';
  }

  static String format(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Aldri';
    }
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toLocal());
  }

  static String formatTidSiden(Duration tidSiden) {
    if (tidSiden.inDays > 0) {
      return '${tidSiden.inDays}d siden';
    } else if (tidSiden.inHours > 0) {
      return '${tidSiden.inHours}t ${tidSiden.inMinutes % 60}m siden';
    } else if (tidSiden.inMinutes > 0) {
      return '${tidSiden.inMinutes}m siden';
    } else if (tidSiden == Duration.zero) {
      return 'Aldri';
    } else {
      return 'Mindre enn ett minutt siden';
    }
  }

  // TimeOfDay will always be local, so DateTime.now() should also be local,
  // to match the local time of day. The resulting DateTime will be local and
  // should be converted to utc for all other purposes than displaying
  static today(TimeOfDay time) {
    DateTime now = DateTime.now().toLocal();
    return DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).toUtc();
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round().abs();
  }

  static timeSince(DateTime? time) {
    final now = DateTime.now().toUtc();
    if (time == null) {
      return Duration.zero;
    }
    return now.difference(time);
  }

  static String tidString(DateTime? tid) {
    if (tid == null) {
      return 'Aldri';
    }
    DateTime now = DateTime.now().toUtc();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    if (tid.year == now.year && tid.month == now.month && tid.day == now.day) {
      return '${tid.hour.toString().padLeft(2, '0')}:${tid.minute.toString().padLeft(2, '0')}';
    } else if (tid.year == yesterday.year &&
        tid.month == yesterday.month &&
        tid.day == yesterday.day) {
      return '${tid.hour.toString().padLeft(2, '0')}:${tid.minute.toString().padLeft(2, '0')} i går';
    } else {
      return '${tid.day.toString().padLeft(2, '0')}.${tid.month.toString().padLeft(2, '0')}.${tid.year}';
    }
  }
}
