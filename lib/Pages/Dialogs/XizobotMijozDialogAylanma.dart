import 'dart:convert';

import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/SelectDialogAgent.dart';
import 'package:zilol_ays_tea/Pages/Xisobot/webview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SelectDialogClient.dart';

class XisobotMijozDialogAylanma extends StatefulWidget {
  const XisobotMijozDialogAylanma({Key? key}) : super(key: key);

  @override
  _XisobotMijozDialogAylanmaState createState() => _XisobotMijozDialogAylanmaState();
}

class _XisobotMijozDialogAylanmaState extends State<XisobotMijozDialogAylanma> {
  DateTime? selectedDatebosh;
  DateTime? selectedDateoxir;
  var customFormat = DateFormat('yyyy-MM-dd');
  DateTime selectedOnly = DateTime.now();
  String clientId = "";
  String regionId = "";
  String agentId = "";
  String agentName = "Агентни танланг";
  bool loadingSave = false;
  late Widget widgetSave = Center(
      child: CircularProgressIndicator(
    color: cWhiteColor,
    strokeWidth: 3,
  ));
  @override
  void initState() {
    super.initState();
    _load();
  }
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
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
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
                  width: 5,
                ),
                Text(
                  'Савдо айланмаси',
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
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => showPicker(context, '1'),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: cBackColor3),
                      height: 55,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDatebosh == null
                                ? "Дата 1"
                                : customFormat.format(selectedDatebosh!),
                            style:
                            TextStyle(color: cFirstColor, fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            color: cFirstColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => showPicker(context, '2'),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: cBackColor3),
                      height: 55,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDateoxir == null
                                ? "Дата 2"
                                : customFormat.format(selectedDateoxir!),
                            style:
                            TextStyle(color: cFirstColor, fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            color: cFirstColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),

            InkWell(
              onTap: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return SelectDialogAgent(client_id: clientId, region_id: regionId);
                  },
                ).then((value) {
                  setState(() {
                    agentName = value['agent_nomi'];
                    agentId = value['id'];
                  });
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: cBackColor3),
                height: 55,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      agentName,
                      style: TextStyle(color: cFirstColor, fontSize: 14),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: cFirstColor,
                    )
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 25,
            ),
            MaterialButton(
              onPressed: () {
                getHTMLQoldiq(
                    customFormat
                        .format(selectedDatebosh ?? DateTime.now())
                        .toString(),
                    customFormat
                        .format(selectedDateoxir ?? DateTime.now())
                        .toString(),
                    clientId);
              },
              //since this is only a UI app
              child: loadingSave
                  ? Container(
                      child: widgetSave,
                      height: 30,
                      width: 30,
                    )
                  : Text(
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

  void getHTMLQoldiq(String sana, String sana2, String mijoz_id) async {
    try {
      loadingSave = true;
      setState(() {});

      var params = {
        "sana": sana,
        "sana2": sana2,
        "mijoz_id": mijoz_id,
        "agent_id": agentId,
        "options": jsonEncode([1, 2, 3]),
      };
      final Dio dio = Dio();
      dio.options.connectTimeout = 60000;
      dio.options.receiveTimeout = 60000;
      Response response = await dio.post(
        baseUrl + "hisobot/plus-minus-mijoz",
        data: jsonEncode(params),
      );
      print(response.data["html"].toString());
      if (response.data["html"].toString() != "") {
        if (context.loaderOverlay.visible) {
          context.loaderOverlay.hide();
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Webview(html: response.data["html"].toString()),
          ),
        );
        loadingSave = false;
        setState(() {});
      } else {
        _showToast(context, "Санани тоғри танланг");
        loadingSave = false;
        setState(() {});
      }
    } catch (e) {
      print(e.toString());
      loadingSave = false;
      setState(() {});
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

  Future<void> showPicker(BuildContext context, String a) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(
          DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: cFirstColor,
            accentColor: cSecondColor,
            colorScheme: ColorScheme.light(primary: cFirstColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && a == '1') {
      setState(() {
        selectedDatebosh = picked;
      });
    } else {
      setState(() {
        selectedDateoxir = picked;
      });
    }
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clientId = prefs.getString('Id') ?? "";
    regionId = prefs.getString('reg_id') ?? "";
  }
}
