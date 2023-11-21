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
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          color: cWhiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 20, bottom: 20),
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
                      'Хисоботлар',
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
              Spacer(),

              /// type 3
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
                          isRegion: false,
                          queryType: "3",
                          isSelectClient: turi == "2" ? true : false,
                        );
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
                visible: AktSverka == "0" || turi == "1",
              ),
              Visibility(
                child: SizedBox(
                  height: 15,
                ),
                visible: AktSverka == "0" || turi == "1",
              ),

              ///type 4
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
                          isRegion: false,
                          queryType: "4",
                          isSelectClient: false,
                        );
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
                visible: ReestrRealizatsiya == "0" || turi == "1",
              ),
              Visibility(
                child: SizedBox(
                  height: 15,
                ),
                visible: ReestrRealizatsiya == "0" || turi == "1",
              ),

              ///type 5
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
                          queryType: "5",
                          isRegion: turi != "1",
                          isSelectClient: false,
                        );
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
                visible: DtKtOstatkaKlient == "0" || turi == "1",
              ),
              Spacer(),
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
    setState(() {});
  }
}
