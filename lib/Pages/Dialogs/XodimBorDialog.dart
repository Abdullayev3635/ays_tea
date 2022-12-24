import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class XodimBorDialog extends StatelessWidget {
  final String ism;

  const XodimBorDialog({required this.ism}) : super();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: cWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 2,
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 25,
            ),
            SvgPicture.asset(
              'assets/icons/notallowed.svg',
              alignment: Alignment.center,
              width: 140,
              height: 140,
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: "Киритилган фойдаланувчи аввал ",
                  style: TextStyle(color: cRedColor, fontSize: 20),
                ),
                TextSpan(
                  text: ism,
                  style: TextStyle(color: cFirstColor, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " сифатида рўйҳатдан ўтган!",
                  style: TextStyle(color: cRedColor, fontSize: 20),
                ),
              ]),
            ),
            // Text(
            //   'Киритилган фойдаланувчи аввал $ism сифатида рўйҳатдан ўтган!',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(color: cRedColor, fontSize: 18),
            // ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                check().then((intenet) async {
                  if (intenet != null && intenet) {
                    Navigator.of(context).pop();
                  } else if (!intenet) {
                    _showToast(
                        context, 'Илтимос Интернет билан алоқани текширинг!');
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cFirstColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                width: MediaQuery.of(context).size.width - 70,
                height: 50,
                child: Center(
                  child: Text(
                    'Тушундим',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Nudity',
                        fontWeight: FontWeight.w400,
                        color: cWhiteColor),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
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
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
