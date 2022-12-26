import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Canstants/Texts.dart';

class QrScannerInfoDialog extends StatefulWidget {
  const QrScannerInfoDialog({required this.params});

  final params;

  @override
  _QrScannerInfoDialogState createState() => _QrScannerInfoDialogState();
}

class _QrScannerInfoDialogState extends State<QrScannerInfoDialog> {
  var dataSp;
  String userId = "";
  bool loading = false;

  @override
  void initState() {
    print(widget.params);
    dataSp = widget.params.split(':');
    loadInfo();
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
                inZakaz();
              },
              child: loading
                  ? CupertinoActivityIndicator(
                      color: cWhiteColor,
                    )
                  : Text(
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> inZakaz() async {
    loading = true;
    setState(() {});
    BaseOptions options = new BaseOptions(
      connectTimeout: 6000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);

    var formData = FormData.fromMap({
      "agent_id": userId,
      'mijoz_id': dataSp[0],
      'summa': dataSp[2],
      'izox': dataSp[3],
    });


    Response response = await dio.post(
      "${baseUrl}in_tolov.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 200) {
      loading = false;
      setState(() {});
      Navigator.pop(context);
    } else {
      loading = false;
      setState(() {});
      _showToast(context, "Малумотлар нотўгри");
    }
  }

  void _showToast(BuildContext context, String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('agent_id') ?? "0";
    print(userId);
  }
}
