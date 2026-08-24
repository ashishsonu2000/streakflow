import 'package:url_launcher/url_launcher.dart';

class FeedbackEmailService {
  Future<void> send() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@streakcalculator.com',
      queryParameters: {
        'subject':
        'Streak Calculator Feedback',
      },
    );

    await launchUrl(uri);
  }
}