import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DTFormatter {
  //date and time
  static dateTimeFormat(timestamp) {
    String t = '';
    var tm = timestamp as Timestamp;
    t = DateFormat('EEE, dd MMMM, yyyy  - hh:mm a').format(tm.toDate());
    return t.toString();
  }

  //date
  static dateFormat(timestamp) {
    String t = '';
    var tm = timestamp as Timestamp;
    t = DateFormat('dd MMMM, yyyy').format(tm.toDate());
    return t.toString();
  }

// time
  static timeFormat(timestamp) {
    String t = '';
    var tm = timestamp as Timestamp;
    t = DateFormat('hh:mm a').format(tm.toDate());
    return t.toString();
  }

  // time
  static remainingDay(timestamp) {
    DateTime t;
    Timestamp ts = timestamp as Timestamp;
    DateTime dateTime = ts.toDate();
    t = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return t;
  }
}
