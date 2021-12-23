import 'package:flutter/material.dart';
import 'package:mvvm_angela/common/utils/page_utils.dart';
import 'package:mvvm_angela/data/screen_argument.dart';
import 'package:mvvm_angela/views/resource/app_strings.dart';
import 'package:mvvm_angela/views/screen/country/countries.dart';
import 'package:mvvm_angela/views/screen/home/home_screen.dart';
import 'package:mvvm_angela/views/screen/login/login_screen.dart';
import 'package:mvvm_angela/views/screen/otp/otp_screen.dart';
import 'package:mvvm_angela/views/screen/splash/splash_screen.dart';

import 'app_routes.dart';

/*application class*/
class App extends StatelessWidget {
  //------------------------------ Singleton-Instance ------------------------------

  // Singleton-Instance
  static final App _instance = App._internal();

  /*
  * App Private Constructor -> App
  * @param -> _
  * @usage -> Create Instance of App
  * */
  App._internal();

  /*
  * App Factory Constructor -> App
  * @dependency -> _
  * @usage -> Returns the instance of app
  * */
  factory App() => _instance;

  //------------------------------ Widget Methods ------------------------------

  /*
  * @override Build Method -> Widget
  * @param -> context -> BuildContext
  * @returns -> Returns widget as MaterialApp class instance
  * */
  @override
  Widget build(BuildContext context) {
    /// Global Navigator Key
    final navigatorKey = GlobalKey<NavigatorState>();
    final app = MaterialApp(
        navigatorKey: navigatorKey,
        title: AppStrings.APP_NAME,
        debugShowCheckedModeBanner: false,
        home: Splash(),
        onGenerateRoute: (settings){
          switch (settings.name) {
            case OTP_ROUTE:
              final OTPArguments? arguments = settings.arguments as OTPArguments?;
              return MaterialPageRoute(builder: (_) => OtpScreen(args: arguments));
            case COUNTRY_CODE_ROUTE:
              final String? arguments = settings.arguments as String?;
              return MaterialPageRoute(
                  builder: (_) => CountriesPage(initialValue: arguments));
            case LOGIN_ROUTE:
              return MaterialPageRoute(builder: (_) => Login());
            case HOME_ROUTE:
              return MaterialPageRoute(builder: (_) => Home());
          }
        }
    );
    return app;
  }

  //------------------------------ App Methods ------------------------------

  /*
  * Get App Routes Method -> AppRoutes
  *  @param -> _
  * @usage -> Returns the instance of AppRoutes class
  * */
  AppRoutes getAppRoutes(){
    return AppRoutes();
  }
}
