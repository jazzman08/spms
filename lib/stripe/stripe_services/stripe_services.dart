import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:spms/stripe/const.dart';

class StripeServices {
  StripeServices._();

  static final StripeServices instance = StripeServices._();

  Future<void> makePayment({required double amount, required String currency}) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(amount, currency);

      if (paymentIntentClientSecret == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Chimwemwe Phabuli",
        ),
      );

      // Show the payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Optional: Send confirmation email (pseudo-code, replace with your email logic)
      await _sendConfirmationEmail();

    } catch (e) {
      print('Payment error: $e');
      rethrow;
    }
  }

  Future<String?> _createPaymentIntent(double amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );

      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String _calculateAmount(double amount) {
    final calculatedAmount = (amount * 100).toInt();
    return calculatedAmount.toString();
  }

  Future<void> _sendConfirmationEmail() async {
    // Replace with your email sending logic
    print('Sending confirmation email...');
  }
}
