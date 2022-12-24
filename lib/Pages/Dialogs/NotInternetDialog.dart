import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotInternetDialog extends StatelessWidget {
  const NotInternetDialog({Key? key}) : super(key: key);

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
              height: 20,
            ),
            Image.asset(
              'assets/images/image404.png',
              width: MediaQuery.of(context).size.width - 100,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Маълумот юкланаётганда хатолик юз берди, қайтадан урининг!',
              textAlign: TextAlign.center,
              style: TextStyle(color: cTextColor2, fontSize: 16),
            ),
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
                width: 300,
                height: 50,
                child: Center(
                  child: Text(
                    'Қайта уриниш',
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
