import 'dart:convert';

import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/Widgets/PopupMenu.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Dialogs/NotInternetDialog.dart';
import '../Dialogs/qr_dialog.dart';

class ClientPay extends StatefulWidget {
  const ClientPay({Key? key}) : super(key: key);

  @override
  _ClientPayState createState() => _ClientPayState();
}

class _ClientPayState extends State<ClientPay> {
  TextEditingController summasum = TextEditingController();

  TextEditingController izoh = TextEditingController();
  String clientId = "";
  String qarzi_som_text = 'Қарзи сўм:';

  final _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));

  bool loadingSave = false;

  double qarzi_som = 0;
  bool loadingQarz = false;

  late Widget widgetQarz = Center(
    child: CupertinoActivityIndicator(
      color: cThreeColor,
    ),
  );

  @override
  void initState() {
    loadInfo();
    super.initState();
  }

  void loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clientId = prefs.getString('mijoz_id') ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhiteColor,
      body: Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 0, top: 10, bottom: 20),
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
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  Text(
                    qarzi_som_text,
                    style: TextStyle(color: cFirstColor, fontSize: 15),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  loadingQarz
                      ? Container(
                          child: widgetQarz,
                          height: 15,
                          width: 15,
                        )
                      : Text(
                          qarzi_som.toString(),
                          style: TextStyle(color: cRedColor, fontSize: 16),
                        ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      check().then((intenet) async {
                        if (intenet) {
                          getHistory();
                        } else if (!intenet) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return NotInternetDialog();
                            },
                          ).then((value) => getHistory());
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.refresh_rounded,
                        color: cFirstColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            SvgPicture.asset(
              'assets/icons/line.svg',
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: cBackColor3),
              height: 55,
              child: Center(
                child: TextFormField(
                  controller: summasum,
                  keyboardType: TextInputType.number,
                  cursorColor: cFirstColor,
                  decoration: InputDecoration(
                    hintText: 'Суммани киритинг',
                    hintStyle: TextStyle(
                      color: cTextColor,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    value = '${_formatNumber(value.replaceAll(',', ''))}';
                    summasum.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                  style: TextStyle(fontSize: 16, color: cFirstColor),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: cBackColor3),
              height: 55,
              child: Center(
                child: TextFormField(
                  controller: izoh,
                  keyboardType: TextInputType.text,
                  cursorColor: cFirstColor,
                  decoration: InputDecoration(
                    hintText: 'Изох киритинг',
                    hintStyle: TextStyle(
                      color: cTextColor,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 16, color: cFirstColor),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Spacer(),
            MaterialButton(
              onPressed: () {
                if (summasum.text != "") {
                  String st = clientId.toString() +
                      ":" +
                      "Abdullayev Olloyor" +
                      ":" +
                      summasum.text.toString() +
                      ":" +
                      izoh.text.toString() +
                      ":" +
                      qarzi_som.toString();
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return QrCodeDialog(params: st);
                    },
                  ).then((value) {
                    if (value['tugadi'] ?? false) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      summasum.text = "";
                      izoh.text = "";
                      setState(() {});
                    }
                  });
                } else {
                  _showToast(context, "Илтимос суммани киритинг!");
                }
              },
              child: Text(
                'Давом этиш',
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
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void getHistory() async {
    loadingQarz = true;
    setState(() {});
    final Dio dio = Dio();
    var formData = FormData.fromMap({
      "user_id": clientId,
      "sorov_turi": "2",
      "sorov_izox": clientId,
    });
    final response1 = await dio.post(
      baseUrl + "insert_savol.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response1.statusCode == 200) {
      final lastId = response1.data;
      lastQuery(lastId);
    }
  }

  void lastQuery(final lastId) async {
    final formData2 =
        FormData.fromMap({"user_id": clientId, "sorov_id": lastId});
    final response2 = await Dio().post(
      baseUrl + "get_javob.php",
      data: formData2,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response2.statusCode == 200) {
      if (response2.data != "" && response2.data != "no") {
        qarzi_som = double.tryParse(response2.data.toString()) ?? 0;
        loadingQarz = false;
        setState(() {});
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
        lastQuery(lastId);
        print(lastId);
      }
    }
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
