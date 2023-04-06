import 'dart:async';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class BharatUpi {
  static const _channel = MethodChannel('bharat_upi');

  Future<void> initiateTransaction({
    required String upiId,
    required String transactionRefId,
    required String transactionNote,
    required double transactionAmount,
    String? urlScheme,
  }) async {
    final String upiUrl = _generateUpiUrl(
      upiId: upiId,
      transactionRefId: transactionRefId,
      transactionNote: transactionNote,
      transactionAmount: transactionAmount,
      urlScheme: urlScheme,
    );

    if (await canLaunch(upiUrl)) {
      await launch(
        upiUrl,
        forceSafariVC: false,
        forceWebView: false,
        universalLinksOnly: true,
        enableJavaScript: true,
        enableDomStorage: true,
        headers: <String, String>{'header_key': 'header_value'},
        useSafariVC: false,
        statusBarBrightness: Brightness.light,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw PlatformException(
        code: 'UPI_ERROR',
        message: 'Unable to launch UPI app',
        details: null,
      );
    }
  }

  String _generateUpiUrl({
    required String upiId,
    required String transactionRefId,
    required String transactionNote,
    required double transactionAmount,
    String? urlScheme,
  }) {
    return '$urlScheme://upi/pay?pa=$upiId&pn=Example&tid=$transactionRefId&mc=0000&tid=$transactionNote&am=$transactionAmount&cu=INR';
  }
}
