import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:zilol_ays_tea/Pages/Payment/XodimPay.dart';
import 'package:zilol_ays_tea/Pages/Payment/qr_scan.dart';

import '../Dialogs/qr_scann_info_dialog.dart';

class XodimPaySelect extends StatefulWidget {
  const XodimPaySelect({Key? key}) : super(key: key);

  @override
  _XodimPaySelectState createState() => _XodimPaySelectState();
}

class _XodimPaySelectState extends State<XodimPaySelect> {
  String canPay = "";
  String payConfirm = "";

  @override
  void initState() {
    super.initState();
    loadInfo();
  }

  void loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    canPay = prefs.getString('can_tolov') ?? "";
    payConfirm = prefs.getString('tolovTasdiq') ?? "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhiteColor,
      body: Container(
        margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 18, top: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkResponse(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Image.asset(
                      "assets/images/menu_icon.png",
                      color: cFirstColor,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Text(
                    'Тўлов Қилиш',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: cFirstColor,
                        fontSize: 22),
                  ),
                  SizedBox(
                    width: 45,
                  ),
                ],
              ),
            ),
            Spacer(),
            MaterialButton(
              onPressed: () {
                if (canPay == "1") {
                  _showToast(
                      context, "Сизнинг тўлов қилишга ҳуқуқингиз йўқ");
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => XodimPay(),
                    ),
                  );
                }
              },
              child: Text(
                'Тўлов қилиш',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'SFUIDisplay',
                  fontWeight: FontWeight.w400,
                ),
              ),
              color: cFirstColor,
              elevation: 0,
              minWidth: 400,
              height: 55,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () {
                if (payConfirm == "0") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => QRViewExample(),
                    ),
                  ).then((value) => {
                        if (value["value"] != null)
                          {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return QrScannerInfoDialog(
                                    params: value["value"]);
                              },
                            )
                          }
                      });
                } else {
                  _showToast(context,
                      "Сизга тўлов тасдиқлаш учун рухсат берилмаган!");
                }
              },
              child: Text(
                'Sсаннер қилиш',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'SFUIDisplay',
                  fontWeight: FontWeight.w400,
                ),
              ),
              color: cFirstColor,
              elevation: 0,
              minWidth: 400,
              height: 55,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
