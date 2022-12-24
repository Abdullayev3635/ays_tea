import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';


import 'package:zilol_ays_tea/Models/XodimModel.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/NotInternetDialog.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/XodimBorDialog.dart';

import 'package:zilol_ays_tea/Services/webServis.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../Canstants/Widgets/PopupMenu.dart';
import 'MapAndChage.dart';
import 'package:getwidget/getwidget.dart';

class MijozAdd extends StatefulWidget {
  @override
  _MijozAddState createState() => _MijozAddState();
}

class _MijozAddState extends State<MijozAdd> {
  bool checkedValue = false;
  bool loading = false;
  bool loadinggetLoacation = false;
  late Widget widgetMain;
  TextEditingController pass = TextEditingController();
  TextEditingController pass_again = TextEditingController();
  TextEditingController fio = TextEditingController();
  TextEditingController telefon = TextEditingController();
  TextEditingController sana = TextEditingController();
  TextEditingController manzil = TextEditingController();
  late Position position;
  String vil_id = '';
  String shax_id = '';
  String reg_id = '';
  String addresName = 'Локация қўшиш';

  late double latitude=0;
  late double longitude=0;
  String vil_nomi = 'Вилоятни танланг';
  List<XodimModel> list = [];
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
  var maskFormatterSana = new MaskTextInputFormatter(mask: ' ####-##-##');

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

  Future<void> inRegisterFun() async {
    loading = true;
    widgetMain = Center(
      child: CircularProgressIndicator(
        color: cBackColor,
      ),
    );
    setState(() {});
    webServis netService = webServis();
    list = (await netService.inRegister(
      fio.text,
      "998" + maskFormatter.getUnmaskedText(),
      pass.text,
      "3",
      latitude.toString(),
      longitude.toString(),
    ))!;
    FocusScope.of(context).requestFocus(FocusNode());
    if (list == []) {
      _showToast(context, 'Маълумотларни тўлиқ киритинг');
      loading = false;
      setState(() {});
    } else if(list[0].turi.toString()=="10"){
      loading = false;
      setState(() {});
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return XodimBorDialog(ism: list[0].fio);
        },
      );
    } else if (list.isNotEmpty) {
      Navigator.of(context).pop();
      loading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  loadLocation() async {
    loadinggetLoacation = true;
    setState(() {});
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    loadinggetLoacation = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: loadinggetLoacation
            ? GFLoader(type: GFLoaderType.ios, size: MediaQuery.of(context).size.width/4,)
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: cBackColor,
                child: Center(
                  child: ListView(
                    padding: EdgeInsets.all(30),
                    shrinkWrap: true,
                    children: <Widget>[
                      Row(
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
                            'Мижоз қўшиш',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: cFirstColor,
                                fontSize: 22),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cWhiteColor),
                        height: 55,
                        padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                        child: Center(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            cursorColor: cFirstColor,
                            controller: fio,
                            decoration: InputDecoration(
                              hintText: 'Исм Фамилия',
                              hintStyle: TextStyle(
                                color: cSecondColor,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'Iltimos Parol kiriting';
                            //   }
                            //   return null;
                            // },
                            style: TextStyle(fontSize: 16, color: cFirstColor),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      /// --------------------------------------
                      /// Text Form Field for submitting Login
                      /// --------------------------------------
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cWhiteColor),
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
                                  controller: telefon,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIconConstraints: BoxConstraints(
                                      maxWidth: 30,
                                      maxHeight: 30,
                                      minHeight: 25,
                                      minWidth: 25,
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16, color: cFirstColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cWhiteColor),
                        height: 55,
                        padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                        child: Center(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            cursorColor: cFirstColor,
                            controller: manzil,
                            decoration: InputDecoration(
                              hintText: 'Манзил',
                              hintStyle: TextStyle(
                                color: cSecondColor,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'Iltimos Parol kiriting';
                            //   }
                            //   return null;
                            // },
                            style: TextStyle(fontSize: 16, color: cFirstColor),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      /// --------------------------------------
                      /// Text Form Field for submitting password
                      /// --------------------------------------
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cWhiteColor),
                        height: 55,
                        padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                        child: Center(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            cursorColor: cFirstColor,
                            obscureText: true,
                            controller: pass_again,
                            decoration: InputDecoration(
                              hintText: 'Парол',
                              hintStyle: TextStyle(
                                color: cSecondColor,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              prefixIconConstraints: BoxConstraints(
                                maxWidth: 30,
                                maxHeight: 30,
                                minHeight: 25,
                                minWidth: 25,
                              ),
                              contentPadding: EdgeInsets.only(
                                  top: 5 // HERE THE IMPORTANT PART
                                  ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(2.0, 0, 6.0, 0),
                                child: SvgPicture.asset(
                                  'assets/icons/pass_lock.svg',
                                ),
                              ),
                            ),
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'Iltimos Parol kiriting';
                            //   }
                            //   return null;
                            // },
                            style: TextStyle(fontSize: 16, color: cFirstColor),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      /// ---------------------------------------------
                      /// Text Form Field for submitting password again
                      /// ---------------------------------------------
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cWhiteColor),
                        height: 55,
                        padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                        child: Center(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            cursorColor: cFirstColor,
                            controller: pass,
                            decoration: InputDecoration(
                              hintText: 'Паролни тасдиқланг',
                              hintStyle: TextStyle(
                                color: cSecondColor,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              prefixIconConstraints: BoxConstraints(
                                maxWidth: 30,
                                maxHeight: 30,
                                minHeight: 25,
                                minWidth: 25,
                              ),
                              contentPadding: EdgeInsets.only(
                                  top: 5 // HERE THE IMPORTANT PART
                                  ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(2.0, 0, 6.0, 0),
                                child: SvgPicture.asset(
                                  'assets/icons/pass_lock.svg',
                                ),
                              ),
                            ),
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'Iltimos Parol kiriting';
                            //   }
                            //   return null;
                            // },
                            style: TextStyle(fontSize: 16, color: cFirstColor),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),
                      InkResponse(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapAndChange(
                                position: position,
                              ),
                            ),
                          ).then((value) {
                            setState(() {
                              latitude = value['lat'];
                              longitude = value['lng'];
                              addresName = value['address'];
                            });
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: cWhiteColor),
                          height: 55,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/locatsiya_qoshish.svg',
                                alignment: Alignment.centerRight,
                                width: 24,
                                height: 24,
                                color: cFirstColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                addresName,
                                style:
                                    TextStyle(color: cFirstColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      /// --------------------------------------
                      /// MaterialButton for execute sign in button
                      /// --------------------------------------

                      MaterialButton(
                        onPressed: () {
                          if (pass.text != pass_again.text) {
                            _showToast(context, 'Қайта киритилган пароль аввалгисидан фарқ қилади');
                          } else if(fio.text=="") {
                            _showToast(context, 'Исм фамилия киритинг!');
                          } else if(telefon.text=="") {
                            _showToast(context, 'Илтимос телефон номерни киритнг');
                          } else if(vil_id=="") {
                            _showToast(context, 'Илтимос вилоят танланг');
                          } else if(shax_id=="") {
                            _showToast(context, 'Илтимос шаҳар танланг');
                          } else if(reg_id=="") {
                            _showToast(context, 'Илтимос регион танланг');
                          } else if(pass.text.length<3) {
                            _showToast(context, 'Пароль белгилари сони 4 тадан кам бўлмаслиги керак');
                          } else if(latitude.toString().length<2) {
                            _showToast(context, 'Илтимос жойлашув танланг');
                          } else {
                            check().then((intenet) async {
                              if (intenet != null && intenet) {
                                inRegisterFun();
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
                          }
                        },
                        //since this is only a UI app
                        child: loading
                            ? widgetMain
                            : Text(
                                'Сақлаш',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'SFUIDisplay',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        color: cFirstColor,
                        elevation: 0,
                        minWidth: 400,
                        height: 50,
                        textColor: Colors.white,

                        /// --------------------------------------
                        /// changing border shape of material button.
                        /// --------------------------------------
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),

                      /// --------------------------------------
                      /// Text Don't have an account.
                      /// --------------------------------------
                    ],
                  ),
                ),
              ),
      ),
    );
  }


}
