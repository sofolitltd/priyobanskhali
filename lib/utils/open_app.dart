import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenApp {
  //
  static withUrl(String path) async {
    var url = Uri.parse(path);
    //
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  //
  static openPdf(String path) async {
    var url = Uri.parse(path);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.platformDefault,
        webOnlyWindowName: '_blank',
      );
    } else {
      log('error');
    }
  }

  //
  static withNumber(number) async {
    if (number == '') {
      Fluttertoast.showToast(msg: 'No number found');
    } else {
      var url = Uri(scheme: 'tel', path: number);

      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }
  }

  //
  static withEmail(email) async {
    if (email == '') {
      Fluttertoast.showToast(msg: 'No email found');
    } else {
      var url = Uri(scheme: 'mailto', path: email);
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }
  }
}
