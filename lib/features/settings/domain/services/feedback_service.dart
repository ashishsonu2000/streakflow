import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackEmailService {
  /// Opens the user's email app with a feedback draft. Returns false
  /// when no email app could be opened.
  Future<bool> send() async {
    final info = await PackageInfo.fromPlatform();

    // Uri(queryParameters:) encodes spaces as '+', which some email
    // apps show literally, so build the query by hand.
    final subject = Uri.encodeComponent('Streak Flow Feedback');
    final body = Uri.encodeComponent(
      'What I like:\n\n\n'
      'What I would change or fix:\n\n\n'
      '---\n'
      'App version: ${info.version} (${info.buildNumber})',
    );

    final uri = Uri.parse(
      'mailto:contact@codesapience.com?subject=$subject&body=$body',
    );

    try {
      return await launchUrl(uri);
    } catch (_) {
      return false;
    }
  }
}
