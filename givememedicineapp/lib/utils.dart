import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showConnectivitySnackBar(BuildContext context, ConnectivityResult result) {
  if (result == ConnectivityResult.none) {
    showSimpleNotification(
      const Text('No Internet Connection'),
      background: Colors.red,
      trailing: const Icon(Icons.error),
    );
  } else {
    showSimpleNotification(
      Text(
        result == ConnectivityResult.mobile
            ? 'You are connected to a mobile network.'
            : result == ConnectivityResult.wifi
                ? 'You are connected to a wifi network.'
                : 'You are offline.',
      ),
      background: Colors.green,
      trailing: const Icon(Icons.check),
    );
  }
}

Future<void> showRAlertDialog(
    BuildContext context, String title, String desc, AlertType type) async {
  Alert(
    context: context,
    type: type,
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        child: const Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.of(context).pop(),
        color: const Color.fromRGBO(0, 179, 134, 1.0),
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}

Future<void> showAlertDialog(BuildContext context, String title, String desc) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(desc),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
