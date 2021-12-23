import 'package:flutter/material.dart';
import 'package:mvvm_angela/common/helpers/progress_dialog.dart';
import 'package:synchronized/synchronized.dart';

class AppProgressDialog {
  static AppProgressDialog? _singleton;
  static Lock _lock = Lock();
  static ProgressDialog? _progressDialog;

  static Future<AppProgressDialog?> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // keep local instance till it is fully initialized.
          var singleton = AppProgressDialog();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  static ProgressDialog? styleDialog(BuildContext context) {
    _progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    return _progressDialog;
  }

  static show([message = "Loading, Please wait..."]) {
    if (_progressDialog != null && !_progressDialog!.isShowing()) {
      _progressDialog!.update(message: message);
      _progressDialog!.show();
    }
  }

  static hide() {
    if (_progressDialog != null && _progressDialog!.isShowing()) {
      _progressDialog!.hide();
    }
  }
}
