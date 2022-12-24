import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QrScannerInfoDialog extends StatefulWidget {
  const QrScannerInfoDialog({required this.params});

  final params;

  @override
  _QrScannerInfoDialogState createState() => _QrScannerInfoDialogState();
}

class _QrScannerInfoDialogState extends State<QrScannerInfoDialog> {
  var dataSp;

  @override
  void initState() {
    print(widget.params);
    dataSp = widget.params.split(':');
    print(dataSp.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: cWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/xisobot.svg',
                  alignment: Alignment.centerRight,
                  width: 20,
                  height: 20,
                  color: cFirstColor,
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  'Тўлов маълумотлари',
                  style: TextStyle(fontSize: 15, color: cFirstColor),
                ),
                Spacer(),
                InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                    child: SvgPicture.asset(
                      'assets/icons/back_dialog.svg',
                      alignment: Alignment.centerRight,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),

            Row(
              children: [
                Text(
                  'Mijoz:',
                  style: TextStyle(fontSize: 15, color: cFirstColor),
                ),
                Spacer(),
                Text(
                  dataSp[1],
                  style: TextStyle(fontSize: 16, color: cFirstColor),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Text(
                  'Сумма:',
                  style: TextStyle(fontSize: 15, color: cFirstColor),
                ),
                Spacer(),
                Text(
                  dataSp[2],
                  style: TextStyle(fontSize: 16, color: cFirstColor),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Text(
                  'Изох:',
                  style: TextStyle(fontSize: 15, color: cFirstColor),
                ),
                Spacer(),
                Text(
                  dataSp[3],
                  style: TextStyle(fontSize: 16, color: cFirstColor),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Text(
                  'Қарзи:',
                  style: TextStyle(fontSize: 15, color: cFirstColor),
                ),
                Spacer(),
                Text(
                  dataSp[4],
                  style: TextStyle(fontSize: 16, color: cFirstColor),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Жўнатиш',
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
