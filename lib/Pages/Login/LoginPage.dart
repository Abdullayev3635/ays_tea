import 'dart:convert';

import 'package:zilol_ays_tea/Canstants/color_const.dart';

import 'package:zilol_ays_tea/Pages/Dialogs/NotInternetDialog.dart';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Canstants/Texts.dart';
import '../../LocalStorage/Db_Halper.dart';
import '../MainPages/MainPage/MainPage.dart';
import '../Register/RegistrPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _textvisible = false;
  bool checkedValue = true;
  bool loading = false;
  late Widget widgetMain;

  TextEditingController pass = TextEditingController();
  TextEditingController login = TextEditingController();

  var maskFormatter = new MaskTextInputFormatter(mask: '##) ###-##-##');

  Future<void> inLoginFun() async {
    FocusScope.of(context).requestFocus(FocusNode());
    loading = true;
    widgetMain = Center(
      child: CupertinoActivityIndicator(
        color: cBackColor,
      ),
    );
    setState(() {});

    Dio dio = new Dio();
    var formData = FormData.fromMap({
      "tel": "+998" + maskFormatter.getUnmaskedText(),
      "parol": pass.text,
      "turi": checkedValue ? "1" : "2",
    });

    Response response = await dio.post(
      "$baseUrl/get_login.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 200) {
      final params = jsonDecode(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.reload();
      if (checkedValue) {
        if (params["success"]) {
          await prefs.setString('mijoz_id', params["mijoz_id"].toString());
          await prefs.setString('fio', params["fio"].toString());
          await prefs.setString('boshagan', params["boshagan"].toString());
          await prefs.setString('rasmi', params["rasmi"].toString());
          await prefs.setString('inn', params["inn"].toString());
          await prefs.setString('telefon', params["telefon"].toString());
          await prefs.setString('parol', params["parol"].toString());
          await prefs.setString('turi', "1");
        } else {
          _showToast(context,
              'Маълумотлар нотўғри киритилди илтимос қайтадан текширинг');
          loading = false;
          setState(() {});
          return;
        }
      } else {
        if (params["success"]) {
          await prefs.setString('agent_id', params["agent_id"].toString());
          await prefs.setString('fio', params["fio"].toString());
          await prefs.setString('boshagan', params["boshagan"].toString());
          await prefs.setString('can_zakaz', params["can_zakaz"].toString());
          await prefs.setString(
              'tolovTasdiq', params["tolovTasdiq"].toString());
          await prefs.setString(
              'ReestrRealizatsiya', params["ReestrRealizatsiya"].toString());
          await prefs.setString('AktSverka', params["AktSverka"].toString());
          await prefs.setString(
              'DtKtOstatkaKlient', params["DtKtOstatkaKlient"].toString());
          await prefs.setString('can_tolov', params["can_tolov"].toString());
          await prefs.setString('telefon', params["telefon"].toString());
          await prefs.setString('parol', params["parol"].toString());
          await prefs.setString('turi', "2");
        } else {
          _showToast(context,
              'Маълумотлар нотўғри киритилди илтимос қайтадан текширинг');
          loading = false;
          setState(() {});
          return;
        }
      }
      loading = false;
      setState(() {});
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) =>
              new MainPage(checkedValue ? "1" : "2"),
        ),
      );
    }
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

  @override
  void initState() {
    DataHelper _dataHelper = DataHelper();
    _dataHelper.initializeDatabase().then((value) {
      print('------database intialized');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backimage.png"),
              fit: BoxFit.fill,
            ),
            gradient: cBackGradient,
          ),
          child: Center(
            child: InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: cWhiteColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200,
                      height: 100,
                      child: SvgPicture.asset(
                        'assets/icons/logoMain.svg',
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    /*

                     */
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: cBackColor2),
                      height: 55,
                      padding: EdgeInsets.fromLTRB(15, 2, 5, 0),
                      child: Center(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/call.svg',
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              '+998(',
                              style:
                                  TextStyle(fontSize: 16, color: cFirstColor),
                            ),
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [maskFormatter],
                                keyboardType: TextInputType.phone,
                                cursorColor: cFirstColor,
                                controller: login,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIconConstraints: BoxConstraints(
                                    maxWidth: 30,
                                    maxHeight: 30,
                                    minHeight: 25,
                                    minWidth: 25,
                                  ),
                                ),
                                style:
                                    TextStyle(fontSize: 16, color: cFirstColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    /// --------------------------------------
                    /// Text Form Field for submitting password
                    /// --------------------------------------
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: cBackColor2),
                      height: 55,
                      padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                      child: Center(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          obscureText: !_textvisible,
                          cursorColor: cFirstColor,
                          controller: pass,
                          decoration: InputDecoration(
                            hintText: 'Парол',
                            hintStyle: TextStyle(
                              color: cTextColor2,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _textvisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: cGrayColor1,
                              ),
                              onPressed: () {
                                setState(() {
                                  _textvisible = !_textvisible;
                                });
                              },
                            ),
                            prefixIconConstraints: BoxConstraints(
                              maxWidth: 30,
                              maxHeight: 30,
                              minHeight: 25,
                              minWidth: 25,
                            ),
                            contentPadding: EdgeInsets.only(
                                top: 15 // HERE THE IMPORTANT PART
                                ),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(2.0, 0, 6.0, 0),
                              child: SvgPicture.asset(
                                'assets/icons/pass_lock.svg',
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Iltimos Parol kiriting';
                            }
                            return null;
                          },
                          style: TextStyle(fontSize: 16, color: cFirstColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              checkedValue = !checkedValue;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      checkedValue = !checkedValue;
                                    });
                                  },
                                  child: checkedValue
                                      ? Icon(
                                          Icons.radio_button_unchecked,
                                          color: cFirstColor,
                                          size: 17,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/check_box.svg",
                                          color: cFirstColor,
                                          height: 17,
                                          width: 17,
                                        ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Инкассатор сизфатида кириш",
                                  style: TextStyle(
                                    color: cTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(),
                      ],
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    MaterialButton(
                      onPressed: () {
                        check().then((intenet) async {
                          if (intenet != null && intenet) {
                            if (login.text.isEmpty) {
                              _showToast(context,
                                  'Телефон рақамингизни киритиб, қайта уриниб кўринг');
                            } else if (pass.text.isEmpty) {
                              _showToast(context,
                                  'Паролингизни киритинг ва қайтадан урининг');
                            } else {
                              inLoginFun();
                            }
                          } else if (!intenet) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return NotInternetDialog();
                              },
                            );
                          }
                        });
                      },
                      //since this is only a UI app
                      child: loading
                          ? widgetMain
                          : Text(
                              'КИРИШ',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'SFUIDisplay',
                                fontWeight: FontWeight.bold,
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
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Рўйхатдан ўтмаганмисиз?",
                            style: TextStyle(
                              color: cTextColor,
                              fontSize: 13,
                            )),

                        /// --------------------------------------
                        /// Text sign up.
                        /// --------------------------------------

                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => RegistPage(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 4, top: 2, bottom: 2, right: 0),
                            child: Text("Рўйхатдан ўтиш",
                                style: TextStyle(
                                  color: cFirstColor,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
