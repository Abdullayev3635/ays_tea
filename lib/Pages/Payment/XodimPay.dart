import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/SelectDialogRegion.dart';
import 'package:zilol_ays_tea/Pages/Payment/qr_scan.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Dialogs/BlockDialog.dart';
import '../Dialogs/SelectDialogClient.dart';
import '../Dialogs/qr_scann_info_dialog.dart';

class XodimPay extends StatefulWidget {
  const XodimPay({Key? key}) : super(key: key);

  @override
  _XodimPayState createState() => _XodimPayState();
}

enum ButtonAction {
  cancel,
  agree,
}

class _XodimPayState extends State<XodimPay> {
  TextEditingController summasum = TextEditingController();

  TextEditingController izoh = TextEditingController();
  String client_name = "Мижозни танланг";
  String regionName = "Худудни танланг";
  String regionId = "";
  String clientId = "";
  String agent_id = "";
  String canPay = "";
  String payConfirm = "";
  String qarzi_som_text = 'Қарзи сўм: ';

  final _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));

  bool loadingSave = false;

  double qarzi_som = 0;
  bool loadingQarz = false;

  late Widget widgetQarz = Center(
    child: CupertinoActivityIndicator(
      color: cFirstColor,
    ),
  );
  late Widget widgetSave = Center(
    child: CupertinoActivityIndicator(
      color: cWhiteColor,
    ),
  );

  @override
  void initState() {
    loadInfo();
    checkState();
    super.initState();
  }

  void loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    agent_id = prefs.getString('agent_id') ?? "";
    canPay = prefs.getString('can_tolov') ?? "";
    payConfirm = prefs.getString('tolovTasdiq') ?? "";
    setState(() {});
  }

  Future<void> inPay() async {
    loadingSave = true;
    setState(() {});
    BaseOptions options = new BaseOptions(
      connectTimeout: 6000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);

    var formData = FormData.fromMap({
      "agent_id": agent_id,
      'mijoz_id': clientId,
      'summa': summasum.text.replaceAll(",", ""),
      'izox': izoh.text,
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
      Navigator.pop(context);
    } else {
      loadingSave = false;
      setState(() {});
      _showToast(context, "Малумотлар нотўгри");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showMaterialDialog<T>(
      {required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    );
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15.0, 15.0, 15.0),
                      child: SvgPicture.asset(
                        'assets/icons/back_register.svg',
                        color: cFirstColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
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
              height: 25,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: cBackColor3),
              height: 55,
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SelectDialogRegion();
                    },
                  ).then((value) {
                    if (value != null) {
                      regionName = value['region_name'];
                      regionId = value['region_id'];
                      setState(() {});
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        regionName,
                        style: TextStyle(color: cFirstColor, fontSize: 14),
                        maxLines: 1,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: cFirstColor,
                    ),
                  ],
                ),
              ),
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
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  if(regionId==""){
                    _showToast(context, "Худудни танланг");
                  } else {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SelectDialogClient(regionId: regionId,);
                      },
                    ).then((value) {
                      if (value != null) {
                        client_name = value['mijoz_nomi'];
                        clientId = value['mijoz_id'];
                        getHistory();
                      }
                    });
                  }

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        client_name,
                        style: TextStyle(color: cFirstColor, fontSize: 14),
                        maxLines: 1,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_sharp,
                      color: cFirstColor,
                    ),
                  ],
                ),
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
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      if (clientId == "") {
                        _showToast(context, "Илтимос мижоз танланг");
                      } else if (canPay == "1") {
                        _showToast(
                            context, "Сизнинг тўлов қилишга ҳуқуқингиз йўқ");
                      } else {
                        showMaterialDialog<ButtonAction>(
                          context: context,
                          child: AlertDialog(
                            title: const Text('Тўлов!'),
                            content: Text(
                              'Тўловни амалга оширишни хохлайсизми ?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Йўқ'),
                                onPressed: () {
                                  Navigator.pop(context, ButtonAction.cancel);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                              ),
                              TextButton(
                                child: const Text('Ҳа'),
                                onPressed: () {
                                  inPay();
                                  Navigator.pop(context, ButtonAction.cancel);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
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
                    minWidth: 300,
                    height: 55,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  flex: 6,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
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
                    child: Icon(
                      Icons.qr_code_2_rounded,
                      size: 35,
                      color: cFirstColor,
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getHistory() async {
    count = 1;
    loadingQarz = true;
    setState(() {});
    final Dio dio = Dio();
    var formData = FormData.fromMap({
      "user_id": agent_id,
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

  int count = 0;

  void lastQuery(final lastId) async {
    if (count < 30) {
      final formData2 =
          FormData.fromMap({"user_id": agent_id, "sorov_id": lastId});
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
          count += 1;
          await Future.delayed(const Duration(milliseconds: 500));
          lastQuery(lastId);
          print("last Id:" + lastId + "count:" + count.toString());
        }
      }
    } else {
      _showToast(context, "Малумотни юклашда хатолик бўлди");
      loadingQarz = false;
      setState(() {});
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

  void checkState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final released = prefs.getString("boshagan");
    if (released == "1") {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BlockDialog();
        },
      ).then((value) => {
            if (value["success"]) {checkState()}
          });
    }
  }
}
