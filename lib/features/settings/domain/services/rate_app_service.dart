import 'package:in_app_review/in_app_review.dart';

class RateAppService {
  final InAppReview _review =
      InAppReview.instance;

  Future<void> open() async {
    if (await _review.isAvailable()) {
      await _review.requestReview();
    }
  }
}