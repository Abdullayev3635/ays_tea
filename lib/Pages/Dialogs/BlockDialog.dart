import 'dart:convert';

import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Pages/Buyurtma/Home/HomePage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Canstants/Texts.dart';
import '../Login/LoginPage.dart';

class BlockDialog extends StatelessWidget {
  const BlockDialog({Key? key}) : super(key: key);

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
            Text(
              'Дастур яратувчилари томонидан сизнинг фаолиятингиз чекландан Илтимос улар билан боғланинг!',
              textAlign: TextAlign.center,
              style: TextStyle(color: cRedColor, fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                check().then((intenet) async {
                  if (intenet) {
                    checkState(context);
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
                    'Ҳолатни текшириш',
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

  void checkState(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final type = prefs.getString("turi") ?? "0";
    final clientId = prefs.getString("mijoz_id") ?? "0";
    final userId = prefs.getString("agent_id") ?? "0";
    if (type == "1") {
      updateClient(clientId, type, context);
    } else if (type == "2") {
      updateUser(userId, type, context);
    } else {
      logUOut(context);
    }
  }

  void updateClient(String userId, String type, BuildContext context) async {
    Dio dio = new Dio();
    var formData = FormData.fromMap({
      "user_id": userId,
      "turi": type,
    });
    Response response = await dio.post(
      "$baseUrl/check_state.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 200) {
      final params = jsonDecode(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (params["success"]) {
        if (params["boshagan"].toString() == "0") {
          await prefs.setString('boshagan', params["boshagan"].toString());
          Navigator.pop(context, {"success": false});
        } else {
          await prefs.setString('boshagan', params["boshagan"].toString());
          Navigator.pop(context, {"success": true});
        }
      }
    }
  }

  void updateUser(String userId, String type, BuildContext context) async {
    Dio dio = new Dio();
    var formData = FormData.fromMap({
      "user_id": userId,
      "turi": type,
    });
    Response response = await dio.post(
      "$baseUrl/check_state.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 200) {
      final params = jsonDecode(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (params["success"]) {
        if (params["boshagan"].toString() == "0") {
          Navigator.pop(context, {"success": false});
          await prefs.setString('boshagan', params["boshagan"].toString());
        } else {
          Navigator.pop(context, {"success": true});
          await prefs.setString('boshagan', params["boshagan"].toString());
        }
      }
    }
  }

  void logUOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => route is HomePage);
  }
}
