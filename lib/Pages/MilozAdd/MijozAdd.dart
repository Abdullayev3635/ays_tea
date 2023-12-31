import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../Canstants/Texts.dart';
import '../Dialogs/SelectDialogRegion.dart';

class ClientAdd extends StatefulWidget {
  @override
  _ClientAddState createState() => _ClientAddState();
}

class _ClientAddState extends State<ClientAdd> {
  bool loading = false;
  bool loadingINN = false;
  bool loadingINNAvialble = false;

  String errorTXT = "Киритилган Инн дан аввал фойдаланилган";

  File? image;

  int count = 0;

  TextEditingController pass = TextEditingController();
  TextEditingController pass_again = TextEditingController();
  TextEditingController fio = TextEditingController();
  TextEditingController telefon = TextEditingController();
  TextEditingController inn = TextEditingController();

  late double latitude;
  late double longitude;

  String regionName = "Ҳудудни танланг";
  String regionId = "";
  Position? position;

  String urlPath1 = "";
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  var maskFormatterSana = new MaskTextInputFormatter(mask: ' ####-##-##');

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static void _showToast(BuildContext context, String text) {
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

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  void loadLocation() async {
    position = await _determinePosition();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: cBackColor,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 30, bottom: 12),
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
                      'Мижоз яратиш',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: cFirstColor,
                          fontSize: 22),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipOval(
                          child: this.image == null
                              ? Image.asset(
                            "assets/images/person_png.png",
                            height: 120,
                            width: 120,
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.file(
                              this.image!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: SvgPicture.asset("assets/icons/plus.svg"),
                    ),
                    bottom: 2,
                    right: 2,
                  ),
                ],
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
                    controller: fio,
                    decoration: InputDecoration(
                      hintText: 'Исм Фамилия',
                      hintStyle: TextStyle(
                        color: cSecondColor,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16, color: cFirstColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                        style: TextStyle(fontSize: 16, color: cFirstColor),
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
                          style: TextStyle(fontSize: 16, color: cFirstColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: cWhiteColor),
                height: 55,
                padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          cursorColor: cFirstColor,
                          controller: inn,
                          decoration: InputDecoration(
                            hintText: 'ИНН',
                            hintStyle: TextStyle(
                              color: cSecondColor,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if ((value.length < 9) || (value.length > 9)) {
                              loadingINNAvialble = true;
                              errorTXT =
                              "Киритилган Инн нинг узунлиги 9 та болиши керак!";
                              setState(() {});
                            } else {
                              loadingINNAvialble = false;
                              setState(() {});
                            }
                          },
                          onEditingComplete: () {
                            checkInn(inn.text);
                          },
                          style: TextStyle(fontSize: 16, color: cFirstColor),
                        ),
                      ),
                      loadingINN
                          ? const CupertinoActivityIndicator()
                          : Container(),
                      loadingINNAvialble
                          ? const Icon(Icons.error, color: Colors.red)
                          : Container()
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 12),
                child: loadingINNAvialble
                    ? Text(
                  errorTXT,
                  style: TextStyle(color: cRedColor, fontSize: 8),
                )
                    : SizedBox(),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
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
                      color: cWhiteColor),
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
              SizedBox(
                height: 10,
              ),
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
                      contentPadding:
                      EdgeInsets.only(top: 5 // HERE THE IMPORTANT PART
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0, 6.0, 0),
                        child: SvgPicture.asset(
                          'assets/icons/pass_lock.svg',
                        ),
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: cFirstColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
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
                      contentPadding:
                      EdgeInsets.only(top: 5 // HERE THE IMPORTANT PART
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(2.0, 0, 6.0, 0),
                        child: SvgPicture.asset(
                          'assets/icons/pass_lock.svg',
                        ),
                      ),
                    ),
                    style: TextStyle(fontSize: 16, color: cFirstColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () {
                  if (pass.text != pass_again.text) {
                    _showToast(context,
                        'Қайта киритилган пароль аввалгисидан фарқ қилади!');
                  } else if (loadingINN) {
                    _showToast(context, 'Жараён тўлиқ амалга ошишини кутинг!');
                  } else if (fio.text == "") {
                    _showToast(context, 'Исм Фамилянгизни киритинг!');
                  } else if (maskFormatter.getUnmaskedText().toString() == "") {
                    _showToast(context, 'Телефон рақамингизни киритинг!');
                  } else {
                    inRegister();
                  }
                },
                //since this is only a UI app
                child: loading
                    ? Center(
                    child: CupertinoActivityIndicator(
                      color: cWhiteColor,
                    ))
                    : Text(
                  'РЎЙХАТДАН ЎТИШ',
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
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void checkInn(String text) async {
    loadingINN = true;
    setState(() {});
    final Dio dio = Dio();
    var formData = FormData.fromMap({"inn": text});
    final response1 = await dio.post(
      baseUrl + "check_inn.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response1.statusCode == 200) {
      if (response1.data == "yes") {
        loadingINNAvialble = true;
        errorTXT = "Киритилган Инн базада мавжуд!";
      } else {
        loadingINNAvialble = false;
      }
      errorTXT = "";
      loadingINN = false;
      setState(() {});
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera, maxHeight: 1024, maxWidth: 1024);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }



  void inRegister() async {
    loading = true;
    setState(() {});
    final Dio dio = Dio();
    final txt = fio.text +
        "~+998" +
        maskFormatter.getUnmaskedText().toString() +
        "~" +
        inn.text +
        "~" +
        regionId +
        "~" +
        pass.text +
        "~" +
        position!.latitude.toString() +
        "~" +
        position!.longitude.toString();

    var formData = FormData.fromMap({
      "user_id": "1",
      "sorov_turi": "1",
      "sorov_izox": txt,
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
    count += count;
    final formData2 = FormData.fromMap({"user_id": "1", "sorov_id": lastId});
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
        if (response2.data != "0") {
          loading = false;
          setState(() {});
          saveImage(lastId);
          fio.text="";
          inn.text="";
          telefon.text="";
          pass.text="";
          pass_again.text="";
          regionId = "";
          regionName = "Ҳудудни танланг";
          _showToast(context,
              "Мижоз қўшиш муваффақиятли бажарилди!");
        } else {
          _showToast(context, "Регистрация қилишда хатолик!");
        }

      } else {
        if (count < 60) {
          await Future.delayed(const Duration(milliseconds: 500));
          lastQuery(lastId);
        } else {
          _showToast(context,
              "Сервер актив ҳолатда эмас Дастур яратувчилари билан боғланинг!");
          loading = false;
          setState(() {});
        }
      }
    }
  }

  void saveImage(String lastId) async {
    if (image != null) {
      List<int> imageBytes = image!.readAsBytesSync();
      print(imageBytes);
      String base64Image = base64Encode(imageBytes);
      final Dio dio = Dio();
      var formData = FormData.fromMap({
        "id": lastId,
        "rasm": base64Image,
      });
      final response1 = await dio.post(
        baseUrl + "in_mijoz_rasm.php",
        data: formData,
        options: Options(
          receiveTimeout: 30000,
          sendTimeout: 30000,
        ),
      );
      if (response1.statusCode == 200) {
        print("seccess");
      }
    }
  }
}
