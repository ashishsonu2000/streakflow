import 'package:url_launcher/url_launcher.dart';

class FeedbackEmailService {
  Future<void> send() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'contact@codesapience.com',
      queryParameters: {
        'subject':
        'Streak Flow Feedback',
      },
    );

    await launchUrl(uri);
  }
}