import 'package:flutter/material.dart';
import 'package:mvvm_angela/common/utils/page_utils.dart';

/*App Routes Class -> Routing class*/
class AppRoutes{

  /*------------------------------ Methods ------------------------------*/

  static void navigateToLogin(BuildContext context) {
    pushReplacementRemoveAll(context, LOGIN_ROUTE);
  }

  static Future navigateToCountriesPage(
      BuildContext context, Object argumentClass) {
    return intentWithDataPushNamed(context, COUNTRY_CODE_ROUTE, argumentClass);
  }

  static void popWithData(BuildContext context, Object argumentClass) {
    Navigator.of(context).pop(argumentClass);
  }

  static void navigateToOTP(BuildContext context, Object argumentClass) {
    intentWithDataPushNamed(context, OTP_ROUTE, argumentClass);
  }

  static void navigateToHome(BuildContext context) {
    pushReplacementRemoveAll(context, HOME_ROUTE);
  }

  static Future intentWithDataPushNamed(
      BuildContext context, String nameRouted, Object argumentClass) {
    return Navigator.pushNamed(context, nameRouted, arguments: argumentClass);
  }

  static void pushReplacementRemoveAll(BuildContext context, String pageName) {
    Navigator.of(context).pushNamedAndRemoveUntil(pageName, (route) => false);
  }


}