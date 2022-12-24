import 'dart:convert';
import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Pages/MilozAdd/MapAndChage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';

import '../../Canstants/Widgets/PopupMenu.dart';
import 'NotInternetDialog.dart';
import 'SelectDialogClient.dart';

class Mijoz_ozgartirish extends StatefulWidget {
  @override
  _Mijoz_ozgartirishState createState() => _Mijoz_ozgartirishState();
}

class _Mijoz_ozgartirishState extends State<Mijoz_ozgartirish> {
  TextEditingController summa = TextEditingController();
  String client_name = "Мижозни танланг";
  String client_id = "0";
  bool loadingSave = false;
  late Position position;
  String addresName = 'Локация ўзгартириш';
  bool loadinggetLoacation = false;
  late double latitude;
  late double longitude;

  late Widget widgetSave = Center(
      child: CircularProgressIndicator(
    color: cWhiteColor,
    strokeWidth: 3,
  ));

  loadLocation() async {
    loadinggetLoacation = true;
    setState(() {});
    // position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    loadinggetLoacation = false;
    setState(() {});
  }

  @override
  void initState() {
    loadLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Dialog(
          backgroundColor: cWhiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          insetPadding: EdgeInsets.symmetric(horizontal: 15),
          child: loadinggetLoacation
              ? Container(
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 9),
                  child: GFLoader(
                    type: GFLoaderType.ios,
                    size: MediaQuery.of(context).size.width / 4,
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/mijozlar.svg',
                            alignment: Alignment.centerRight,
                            width: 24,
                            height: 24,
                            color: cFirstColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Мижоз ўзгартириш',
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
                        height: 25,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cBackColor3),
                        height: 55,
                        alignment: Alignment.centerLeft,
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
                                client_name = value['client_nomi'];
                                client_id = value['id'];
                              });
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  client_name,
                                  style: TextStyle(
                                      color: cFirstColor, fontSize: 14),
                                ),
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
                        height: 30,
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
                              color: cBackColor3),
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
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: () {
                          check().then((intenet) async {
                            if (intenet != null && intenet) {
                              changeClient();
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
                        child: loadingSave
                            ? widgetSave
                            : Text(
                                'Сақлаш',
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
        ),
      ),
    );
  }

  changeClient() async {
    loadingSave = true;
    setState(() {});
    BaseOptions options = new BaseOptions(
      baseUrl: baseUrl + "servis/xodimlar",
      connectTimeout: 6000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    var params = {
      "Id": client_id,
      "lat": latitude.toString(),
      "lng": longitude.toString()
    };

    Response response = await dio.post(
      "${baseUrl}servis/xodimlarlatlng",
      data: jsonEncode(params),
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 200) {
      loadingSave = false;
      setState(() {});
      Navigator.pop(context);
    } else {
      loadingSave = false;
      setState(() {});
      _showToast(context, "Малумотни сақлашда хотолик юз берди");
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
