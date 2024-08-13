import 'package:url_launcher/url_launcher.dart';

// abuility to make call and others
  void launch_Url(Uri url, bool inApp) async {
    try {
      if (await canLaunchUrl(url)) {
        if (inApp) {
          await launchUrl(
            url,
            mode: LaunchMode.inAppWebView,
          );
        } else {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }