import 'package:easy_localization/easy_localization.dart';

class Utility {
  processDate(DateTime createdAt) {
    var date;
    int differenceInDays;
    int differenceInMinutes;
    Duration difference;
    if (createdAt != null) {
      differenceInDays = createdAt.difference(DateTime.now()).inDays * -1;
      differenceInMinutes = createdAt.difference(DateTime.now()).inMinutes * -1;
      difference = createdAt.difference(DateTime.now());

      if (differenceInDays == 0) {
        if (differenceInMinutes < 60) {
          print(differenceInMinutes);
          if (differenceInMinutes < 60) {
            return "${difference.inSeconds * -1}" + "secondsAgo".tr();
          } else {
            return "${difference.inMinutes * -1}" + "minutesAgo".tr();
          }
        } else {
          return "${difference.inHours * -1}" + "hoursAgo".tr();
        }
      } else if (differenceInDays <= 1) {
        return "${difference.inDays * -1}" + "dayAgo".tr();
      } else if (differenceInDays <= 8) {
        return "${difference.inDays * -1}" + "dayAgo".tr();
        //If post post is less than 25 in weeks
      } else if (differenceInDays <= 25) {
        return "${(difference.inDays / 7).floor() * -1}" + "weeksAgo".tr();
      } else if (differenceInDays <= 360) {
        return "${(difference.inDays / 30).floor() * -1}" + "monthsAgo".tr();
      }
    } else {
      return 'no time';
    }
  }
}
