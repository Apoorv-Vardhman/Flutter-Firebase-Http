import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_angela/app/app_routes.dart';
import 'package:mvvm_angela/common/connection/connection_manager.dart';
import 'package:mvvm_angela/common/helpers/progress_singleton.dart';
import 'package:mvvm_angela/common/utils/item_key.dart';
import 'package:mvvm_angela/common/utils/utils.dart';
import 'package:mvvm_angela/common/widget/snackbar.dart';
import 'package:mvvm_angela/data/app_preferences.dart';
import 'package:mvvm_angela/data/screen_argument.dart';
import 'package:mvvm_angela/views/resource/font_family.dart';
import 'package:mvvm_angela/views/screen/login/widget/button/custom_button.dart';
import 'package:mvvm_angela/views/screen/otp/widget/pin_code_text_field.dart';

class OtpScreen extends StatefulWidget {
  final OTPArguments? args;

  const OtpScreen({this.args,Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String thisText = "";
  int pinLength = 6;
  bool hasError = false;
  String? errorMessage;
  String? smsOTP;
  String? verificationId;
  String? token;
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          leading: BackButton(color: Colors.black),
        ),
        body: buildRootViewLayout());
  }

  Widget buildRootViewLayout() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildOTPVerificationHeadingLayout(),
                  SizedBox(height: 20),
                  buildOTPSentToNumberLayout(),
                  SizedBox(height: 49),
                  buildOTPLayout(),
                  SizedBox(height: 30),
                  buildResendOTPLayout(),
                  SizedBox(height: 53),
                  buildVerifyButton()
                ])));
  }


  Widget buildOTPVerificationHeadingLayout() {
    return Text(
      'OTP Verification',
      style: TextStyle(
        fontSize: 24,
        fontFamily: FontFamily.boldItalic,
        color: Color(0xFF34364F),
      ),
    );
  }

  Widget buildOTPSentToNumberLayout() {
    return RichText(
      text: TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: TextStyle(
          fontSize: 17,
          fontFamily: FontFamily.mediumItalic,
          color: Color(0xFF65657D),
        ),
        children: <TextSpan>[
          TextSpan(text: 'Enter the OTP sent to '),
          TextSpan(
            text: widget.args!.mobile,
            style: TextStyle(
                fontSize: 17.0,
                fontFamily: FontFamily.mediumItalic,
                color: Color(0xFF34364F)),
          )
        ],
      ),
    );
  }

  Widget buildOTPLayout() {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PinCodeTextField(
          autofocus: false,
          controller: controller,
          hideCharacter: true,
          highlight: true,
          highlightColor: Colors.blue,
          defaultBorderColor: Color(0xFFE9EDF9),
          pinBoxBorderWidth: 3,
          hasTextBorderColor: Colors.grey,
          maxLength: pinLength,
          hasError: hasError,
          pinBoxRadius: 6,
          maskCharacter: "*",

          onTextChanged: (text) {
            setState(() {
              hasError = false;
            });
          },
          onDone: (text) {
            setState(() {
              this.smsOTP = text;
            });
            print("DONE $text");
          },
          //pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.AUTO_ADJUST_WIDTH,
          wrapAlignment: WrapAlignment.spaceAround,
//                            pinBoxDecoration: ProvidedPinBoxDecoration
//                                .defaultPinBoxDecoration,
          pinTextStyle: TextStyle(fontSize: 30.0),
          pinTextAnimatedSwitcherTransition:
          ProvidedPinBoxTextAnimation.scalingTransition,
          pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget buildResendOTPLayout() {
    return GestureDetector(
      onTap: () async {
        if (ConnectivityManager.getInstance().hasConnection) {
          this.smsOTP = null;
          controller.clear();
          AppProgressDialog.show("Sending OTP...");
          var _mobileNumber = widget.args!.mobile;
          FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: _mobileNumber,
            verificationCompleted: (PhoneAuthCredential credential) {
              _dismissDialog();

            },
            verificationFailed: (FirebaseAuthException ex) {
              _dismissDialog();
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              _dismissDialog();
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              _dismissDialog();
            },
            timeout: Duration(seconds: 30),
          );
        }
      },
      child: RichText(
        text: TextSpan(
          // Note: Styles for TextSpans must be explicitly defined.
          // Child text spans will inherit styles from parent
          style: TextStyle(
              fontSize: 17.0,
              fontFamily: FontFamily.mediumItalic,
              color: Color(0xFF65657D)),
          children: <TextSpan>[
            TextSpan(text: 'Did not receive the OTP? '),
            TextSpan(
              text: 'Resend OTP',
              style: TextStyle(
                  fontSize: 17.0,
                  fontFamily: FontFamily.mediumItalic,
                  color: Color(0xFFED5151)),
            )
          ],
        ),
      ),
    );
  }

  _dismissDialog() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      AppProgressDialog.hide();
    });
  }

  Widget buildVerifyButton() {
    return CustomProceedButton(
      buttonLabel: "Verify & Proceed",
      valueChanged: () async {
        if (isOTPValid()) {
          signIn();
        } else {
          AppProgressDialog.hide();
        }
      },
    );
  }

  signIn() async {
    AppProgressDialog.show("Authenticating, Please wait...");
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.args!.verificationId!,
        smsCode: smsOTP!,
      );
      var credential2 = credential;
      final User user = (await _auth.signInWithCredential(credential2)).user!;
      var idTokenResult = await user.getIdTokenResult();
      await AppPreferences.setPreference(prefName: AUTH_TOKEN, prefType: AppPreferences.PREF_TYPE_STRING, prefValue: idTokenResult.token!);
      await AppPreferences.setPreference(prefName: AUTH_TOKEN_EXPIRY, prefType: AppPreferences.PREF_TYPE_STRING, prefValue: idTokenResult.expirationTime.toString());
      await AppPreferences.setLoggedIn(true);
      AppRoutes.navigateToHome(context);
    } catch (error) {
      _dismissDialog();
      AppSnackBar.showSnackBar(_scaffoldKey.currentState, error.toString());
    }
  }

  bool isOTPValid() {
    String? result = Utils.validateOTP(controller.text);
    if (result == null) {
      if (ConnectivityManager.getInstance().hasConnection) {
        return true;
      } else {
        AppSnackBar.showSnackBar(
            _scaffoldKey.currentState, "Please check your internet connection");
        return false;
      }
    } else {
      AppSnackBar.showSnackBar(_scaffoldKey.currentState, result);
      return false;
    }
  }

}
