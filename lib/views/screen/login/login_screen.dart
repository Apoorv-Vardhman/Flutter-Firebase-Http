import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_angela/app/app_routes.dart';
import 'package:mvvm_angela/common/connection/connection_manager.dart';
import 'package:mvvm_angela/common/helpers/progress_singleton.dart';
import 'package:mvvm_angela/common/utils/utils.dart';
import 'package:mvvm_angela/common/widget/snackbar.dart';
import 'package:mvvm_angela/data/screen_argument.dart';
import 'package:mvvm_angela/views/resource/app_color.dart';
import 'package:mvvm_angela/views/resource/app_strings.dart';
import 'package:mvvm_angela/views/resource/font_family.dart';
import 'package:mvvm_angela/views/screen/login/widget/button/custom_button.dart';
import 'package:mvvm_angela/views/screen/login/widget/countrypicker/country.dart';
import 'package:mvvm_angela/views/screen/login/widget/countrypicker/utils/utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();

}

class _LoginState extends State<Login> {

  Country _preSelectedCountry = CountryPickerUtils.getCountryByPhoneCode('91');

  String? phoneNo;
  String? smsOTP;
  String? verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCredential? phoneAuthCredential;
  late Future result;
  //late AuthenticationBloc _authenticationBloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Builder(
            builder: (context) => SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: loginForm(context)),
                ))));
  }

  Widget loginForm(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 60),
          Text(
            AppStrings.welcomeText,
            style: TextStyle(
                fontSize: 24,
                fontFamily: FontFamily.boldItalic,
                color: Color(0xFF34364F)),
          ),
          SizedBox(height: 20),
          Text(
            AppStrings.insertPhone,
            style: TextStyle(
                fontSize: 17,
                fontFamily: FontFamily.mediumItalic,
                color: Color(0xFF65657D)),
          ),
          SizedBox(height: 59),
          Text(
            AppStrings.mobileNumber,
            style: TextStyle(
                fontSize: 17,
                fontFamily: FontFamily.mediumItalic,
                color: Color(0xFF65657D)),
          ),
          SizedBox(height: 10),
          _buildPhoneContainer(context, _preSelectedCountry),
          SizedBox(height: 63),
          CustomProceedButton(
            buttonLabel: AppStrings.continueText,
            valueChanged: () {
              String? result =
              Utils.validateMobile(_textController.text);
              var _mobileNumber = '+ ${_preSelectedCountry.phoneCode}$phoneNo';
              if (result == null) {
                if (ConnectivityManager.getInstance().hasConnection) {
                  AppProgressDialog.styleDialog(context);
                  AppProgressDialog.show();
                  FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: _mobileNumber,
                    verificationCompleted: (PhoneAuthCredential credential) {
                      _dismissDialog();
                    },
                    verificationFailed: (FirebaseAuthException ex) {
                      _dismissDialog();
                      AppSnackBar.showSnackBar(
                          _scaffoldKey.currentState, ex.message);
                    },
                    codeSent: (String verificationId, int? forceResendingToken) {
                      _dismissDialog();
                      AppRoutes.navigateToOTP(context, OTPArguments(_mobileNumber, verificationId));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      _dismissDialog();
                    },
                    timeout: Duration(seconds: 30),
                  );
                } else {
                  _dismissDialog();
                  AppSnackBar.showSnackBar(_scaffoldKey.currentState,
                      "Please check your internet connection");
                }
              } else {
                _dismissDialog();
                AppSnackBar.showSnackBar(_scaffoldKey.currentState, result);
              }
            },
          )
        ]);
  }

  _dismissDialog() {
    AppProgressDialog.hide();
  }


  _buildPhoneContainer(BuildContext context, Country country) {
    return Container(
      height: 70,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 2.0, style: BorderStyle.solid, color: Color(0xFFE9EDF9)),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            GestureDetector(
              child: Row(
                children: [
                  CountryPickerUtils.getDefaultFlagImage(country),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
              onTap: () {
                result = AppRoutes.navigateToCountriesPage(
                    context, _preSelectedCountry.isoCode!);
                result.then((result) {
                  setState(() {
                    if (result != null)
                      _preSelectedCountry = (result) as Country;
                  });
                });
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              "+${country.phoneCode}",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: FontFamily.semiBoldItalic,
                  color: AppColors.color_65657D),
            ),
            SizedBox(
              width: 17.0,
            ),
            buildPhoneNumberTextField(),
          ],
        ),
      ),
    );
  }

  Widget buildPhoneNumberTextField() {
    return Expanded(
        child: TextFormField(
          controller: _textController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          cursorColor: AppColors.primary_blue,
          maxLength: 10,
          maxLines: 1,
          onChanged: (value) {
            this.phoneNo = value;
          },
          decoration: InputDecoration(
            hintText: AppStrings.mobileNumberHint,
            counterText: "",
            border: InputBorder.none,
            labelStyle: TextStyle(
                fontSize: 18,
                fontFamily: FontFamily.semiBoldItalic,
                decoration: TextDecoration.none,
                color: AppColors.color_34364F),
          ),
        ));
  }

}
