import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/XisobotDialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String turi = "";
  String ReestrRealizatsiya = "";
  String AktSverka = "";
  String DtKtOstatkaKlient = "";

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhiteColor,
      appBar: AppBar(
        leading: InkResponse(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              "assets/images/menu_icon.png",
              color: cFirstColor,
              height: 30,
              width: 30,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: cWhiteColor,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          color: cWhiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return XisobotDialog(
                            title: "Мижоз Акт Сверка",
                            isClient: turi == "1",
                            date2: true,
                            isRegion: false);
                      },
                    );
                  },
                  child: Text(
                    'Мижоз Акт Сверка',
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
                visible: AktSverka == "0"||turi=="1",
              ),
              Visibility(
                child: SizedBox(
                  height: 15,
                ),
                visible: AktSverka == "0"||turi=="1",
              ),
              Visibility(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return XisobotDialog(
                            title: "Савдо Рейстри",
                            isClient: turi == "1",
                            date2: true,
                            isRegion: false);
                      },
                    );
                  },
                  child: Text(
                    'Савдо Рейстри',
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
                visible: ReestrRealizatsiya == "0"||turi=="1",
              ),
              // SizedBox(
              //   height: 15,
              // ),
              // MaterialButton(
              //   onPressed: () {
              //     showDialog(
              //       barrierDismissible: false,
              //       context: context,
              //       builder: (BuildContext context) {
              //         return XisobotDialog(
              //           title: "Тўлов Рейстри",
              //           isClient: turi=="1",
              //           date2: true,
              //           isRegion: false,
              //         );
              //       },
              //     );
              //   },
              //   child: Text(
              //     'Тўлов Рейстри',
              //     style: TextStyle(
              //       fontSize: 14,
              //       fontFamily: 'SFUIDisplay',
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              //   color: cFirstColor,
              //   elevation: 0,
              //   minWidth: 400,
              //   height: 55,
              //   textColor: Colors.white,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10)),
              // ),
              Visibility(
                child: SizedBox(
                  height: 15,
                ),
                visible: ReestrRealizatsiya == "0"||turi=="1",
              ),
              Visibility(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return XisobotDialog(
                            title: "ДТ-КТ қолдиғи",
                            isClient: turi == "1",
                            date2: false,
                            isRegion: true);
                      },
                    );
                  },
                  child: Text(
                    'ДТ-КТ қолдиғи',
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
                visible: DtKtOstatkaKlient == "0"||turi=="1",
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    turi = prefs.getString('turi') ?? "";
    ReestrRealizatsiya = prefs.getString('ReestrRealizatsiya') ?? "";
    AktSverka = prefs.getString('AktSverka') ?? "";
    DtKtOstatkaKlient = prefs.getString('DtKtOstatkaKlient') ?? "";
  }
}
