
import 'package:mvvm_angela/views/resource/app_strings.dart';

class Utils{

  /// Validate Mobile
  static String? validateMobile(String mobile) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (mobile.length == 0 || mobile.isEmpty) {
      return AppStrings.enterMobile;
    } else if (mobile.length != 10) {
      return AppStrings.enter10DigitMobile;
    } else if (!regExp.hasMatch(mobile)) {
      return AppStrings.enterValidMobile;
    }
    return null;
  }

  /// Validate OTP
  static String? validateOTP(String otp) {
    if (otp.length == 0 || otp.isEmpty) {
      return AppStrings.enterOTP;
    } else if (otp.length != 6) {
      return AppStrings.enter6DigitOTP;
    }
    return null;
  }
}