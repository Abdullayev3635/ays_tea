import 'package:shared_preferences/shared_preferences.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../Canstants/Texts.dart';
import '../Xisobot/webview.dart';
import 'SelectDialogClient.dart';
import 'SelectDialogRegion.dart';

class XisobotDialog extends StatefulWidget {
  const XisobotDialog(
      {Key? key,
      required this.title,
      required this.isClient,
      required this.date2,
      required this.queryType,
      required this.isRegion,
      required this.isSelectClient})
      : super(key: key);

  final title;
  final isClient;
  final date2;
  final isRegion;
  final queryType;
  final isSelectClient;

  @override
  _XisobotDialogState createState() => _XisobotDialogState();
}

class _XisobotDialogState extends State<XisobotDialog> {
  DateTime? selectedDatebosh;
  DateTime? selectedDateoxir;
  var customFormat = DateFormat('yyyy-MM-dd');

  String clientName = "Мижозни танланг";
  String regionName = "Ҳудудни танланг";
  String clientId = "";
  String agentId = "";
  String regionId = "";
  String turi = "";
  bool loadingSave = false;
  late Widget widgetSave = Center(
      child: CupertinoActivityIndicator(
    color: cWhiteColor,
  ));

  @override
  void initState() {
    loadInfo();
    super.initState();
  }

  void loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    agentId = prefs.getString('agent_id') ?? "0";
    turi = prefs.getString('turi') ?? "0";
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
                  widget.title,
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
                  flex: 1,
                ),
                SizedBox(
                  width: 20,
                ),
                Visibility(
                  child: Expanded(
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
                  visible: widget.date2,
                ),
              ],
            ),
            SizedBox(height: 25),
            Visibility(
              child: InkWell(
                onTap: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SelectDialogClient();
                    },
                  ).then((value) {
                    setState(() {
                      clientName = value['mijoz_nomi'];
                      clientId = value['mijoz_id'];
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
                        clientName,
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
              visible: !widget.isClient,
            ),
            Visibility(
              child: SizedBox(
                height: 25,
              ),
              visible: !widget.isClient,
            ),
            Visibility(
              child: InkWell(
                onTap: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SelectDialogRegion();
                    },
                  ).then((value) {
                    setState(() {
                      regionName = value['region_name'];
                      regionId = value['region_id'];
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
                        regionName,
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
              visible: widget.isRegion,
            ),
            Visibility(
              child: SizedBox(
                height: 25,
              ),
              visible: widget.isRegion,
            ),
            MaterialButton(
              onPressed: () {
                if (widget.isSelectClient && clientId == "") {
                  _showToast(context, "Илтимос мижоз танланг!");
                } else {
                  getHistory();
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

  int count = 0;

  void getHistory() async {
    count = 1;
    loadingSave = true;
    setState(() {});
    final Dio dio = Dio();
    var formData = FormData.fromMap({
      "user_id": agentId,
      "sorov_turi": widget.queryType,
      "sorov_izox": customFormat.format(selectedDatebosh!).toString() +
          "~" +
          customFormat.format(selectedDateoxir!).toString() +
          "~" +
          clientId +
          "~" +
          regionId,
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
    if (count < 60) {
      final formData2 = FormData.fromMap({
        "user_id": agentId,
        "sorov_id": lastId,
      });
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Webview(html: response2.data.toString()),
            ),
          ).then((value) => {Navigator.pop(context)});

          _showToast(context, "Success");
          loadingSave = false;
          setState(() {});
        } else {
          count += 1;
          await Future.delayed(const Duration(milliseconds: 500));
          lastQuery(lastId);
          print(lastId);
        }
      }
    } else {
      _showToast(context, "Сервер билан боғланишда хатолик бўлди");
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
}
