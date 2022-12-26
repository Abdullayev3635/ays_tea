import 'dart:convert';

import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Models/HistoryModel.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/NotInternetDialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Canstants/Widgets/PopupMenu.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool loadingHistory = true;

  late Widget widgetHistory = Center(
      child: CupertinoActivityIndicator(
    color: cFirstColor,
  ));

  String clientId = "";
  List<HistoryModel> historyList = [];

  Widget icon = SvgPicture.asset(
    'assets/icons/history_icon.svg',
    width: 20,
    height: 20,
  );

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackColor2,
      body: Container(
        margin: EdgeInsets.only(top: 30),
        color: cBackColor2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 0, top: 20, bottom: 20),
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
                    'Буюртмалар тарихи',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: cFirstColor,
                        fontSize: 22),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                ],
              ),
            ),
            loadingHistory
                ? Container(
                    child: Center(child: widgetHistory),
                    height: MediaQuery.of(context).size.height / 2,
                  )
                : Expanded(
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: () => check().then((intenet) async {
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
                      }),
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          return InkResponse(
                            onTap: () {},
                            child: Container(
                              height: 115,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: cWhiteColor),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Буюртма №" +
                                              historyList[index].id.toString(),
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: cTextColor3,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Container(
                                          width: 70,
                                          child: Text(
                                            historyList[index].timeCreate!,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 9,
                                                color: cTextColor3,
                                                fontWeight: FontWeight.w300),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.only(top: 15, left: 40),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      getIcon(index),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 300,
                                        child: RichText(
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: "Мижоз номи: ",
                                                style: TextStyle(
                                                    color: cTextColor,
                                                    fontSize: 13)),
                                            TextSpan(
                                                text: historyList[index]
                                                        .mijozName ??
                                                    "",
                                                style: TextStyle(
                                                    color: cFirstColor,
                                                    fontSize: 14)),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: SvgPicture.asset(
                                        'assets/icons/line.svg'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: "Жами сўм: ",
                                            style: TextStyle(
                                                color: cTextColor,
                                                fontSize: 15)),
                                        TextSpan(
                                          text: historyList[index]
                                                  .totalSumm
                                                  .toString() +
                                              " сўм",
                                          style: TextStyle(
                                              color: cFirstColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ]),
                                    ),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 40),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clientId = prefs.getString('mijoz_id') ?? "0";

    final Dio dio = Dio();

    var formData = FormData.fromMap({
      'user_id': clientId,
    });
    Response response = await dio.post(
      baseUrl + "get_history.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 200) {
      final params = jsonDecode(response.data);
      historyList.clear();
      for (int i = 0; i < (params as List).length; i++) {
        historyList.add(HistoryModel.fromJson(params[i]));
      }
      loadingHistory = false;
      setState(() {});
    }
    loadingHistory = false;
    setState(() {});
  }

  Widget getIcon(int position) {
    if (historyList[position].holati == "0") {
      icon = SvgPicture.asset(
        'assets/icons/history_icon_load.svg',
        width: 20,
        height: 20,
      );
    } else if (historyList[position].holati == "1") {
      icon = SvgPicture.asset(
        'assets/icons/history_icon.svg',
        width: 20,
        height: 20,
        color: Colors.green[200],
      );
    } else if (historyList[position].holati == "2") {
      icon = SvgPicture.asset(
        'assets/icons/history_icon_roate.svg',
        width: 20,
        height: 20,
        color: Colors.green,
      );
    } else if (historyList[position].holati == "3") {
      icon = SvgPicture.asset(
        'assets/icons/history_icon.svg',
        width: 20,
        height: 20,
        color: Colors.green,
      );
    } else if (historyList[position].holati == "4") {
      icon = SvgPicture.asset(
        'assets/icons/history_icon_error.svg',
        width: 20,
        height: 20,
        color: cYellowColor,
      );
    } else {
      icon = SvgPicture.asset(
        'assets/icons/history_icon_error.svg',
        width: 20,
        height: 20,
        color: cRedColor,
      );
    }
    return icon;
  }
}
