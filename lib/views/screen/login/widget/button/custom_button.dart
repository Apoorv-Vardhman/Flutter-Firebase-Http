import 'package:flutter/material.dart';
import 'package:mvvm_angela/views/resource/app_color.dart';
import 'package:mvvm_angela/views/resource/dimens.dart';


class CustomProceedButton extends StatelessWidget {
  final String buttonLabel;
  final VoidCallback? valueChanged;

  const CustomProceedButton(
      {Key? key, required this.buttonLabel, this.valueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildProceedButton();
  }

  _buildProceedButton() {
    return ButtonTheme(
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.gap_dp10)),
      child: RaisedButton(
        elevation: Dimens.gap_dp10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              this.buttonLabel,
            ),
            Container(
              width: Dimens.gap_dp50,
              height: Dimens.gap_dp50,
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.white,
                size: Dimens.gap_dp18,
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(0.1)),
            )
          ],
        ),
        color: AppColors.primary_blue,
        padding: EdgeInsets.fromLTRB(
            Dimens.gap_dp20, Dimens.gap_dp10, Dimens.gap_dp20, Dimens.gap_dp10),
        onPressed: () {
          this.valueChanged!();
        },
      ),
    );
  }
}
