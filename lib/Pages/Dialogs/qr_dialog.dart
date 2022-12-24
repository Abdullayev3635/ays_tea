import 'package:zilol_ays_tea/Canstants/color_const.dart';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDialog extends StatefulWidget {
  const QrCodeDialog({required this.params});

  final params;

  @override
  _QrCodeDialogState createState() => _QrCodeDialogState();
}

class _QrCodeDialogState extends State<QrCodeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: cWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImage(
              data: widget.params.toString(),
              version: QrVersions.auto,
              size: 280,
            ),
            SizedBox(
              height: 18,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context, {
                  "tugadi": true,
                });
              },
              child: Text(
                'Тугатиш',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'SFUIDisplay',
                  fontWeight: FontWeight.w400,
                ),
              ),
              color: cFirstColor,
              elevation: 0,
              minWidth: 300,
              height: 55,
              textColor: Colors.white,

              /// --------------------------------------
              /// changing border shape of material button.
              /// --------------------------------------
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}
