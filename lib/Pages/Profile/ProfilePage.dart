import 'dart:convert';

import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/LocalStorage/Db_Halper.dart';
import 'package:zilol_ays_tea/Pages/Login/LoginPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Canstants/Texts.dart';
import '../../Canstants/Widgets/PopupMenu.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

enum ButtonAction {
  cancel,
  agree,
}

class _ProfilePageState extends State<ProfilePage> {
  DataHelper _dataHelper = DataHelper();

  @override
  void initState() {
    _dataHelper.initializeDatabase().then((value) {
      print('------database intialized');
    });
    doSomeAsyncStuff();
    check().then((intenet) async {
      if (intenet) {
        // checkXodimFun();
      }
    });
    super.initState();
  }

  File? image;
  String ism = 'Абдуллаев Оллаёр';
  String telefon = '+998 (93) 213-36-35';

  String rasmi = "";
  String turi = "";
  String userId = "";

  @override
  Widget build(BuildContext context) {
    void showMaterialDialog<T>(
        {required BuildContext context, required Widget child}) {
      showDialog<T>(
        context: context,
        builder: (BuildContext context) => child,
      );
    }

    return Scaffold(
      backgroundColor: cBackColor2,
      body: Container(
        padding: EdgeInsets.all(25),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
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
                    'Шахсий кабинет',
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
              SizedBox(
                height: 50,
              ),
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
                              ? CachedNetworkImage(
                                  imageUrl:
                                      baseUrlImg + userId + "^" + turi + ".png",
                                  placeholder: (context, url) => Container(
                                    margin: EdgeInsets.all(20),
                                    child: SvgPicture.asset(
                                      'assets/icons/placeholder.svg',
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/images/person_png.png",
                                    height: 120,
                                    width: 120,
                                  ),
                                  fit: BoxFit.fill,
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
                height: 40,
              ),

              /// Ism
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: cWhiteColor),
                height: 55,
                child: Row(
                  children: [
                    SizedBox(
                      width: 22,
                    ),
                    SvgPicture.asset(
                      'assets/icons/person.svg',
                      height: 24,
                      width: 24,
                      color: cFirstColor,
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Expanded(
                        child: Text(ism,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: cFirstColor),
                            maxLines: 1)),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),

              /// nomer
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: cWhiteColor),
                height: 55,
                child: Row(
                  children: [
                    SizedBox(
                      width: 22,
                    ),
                    SvgPicture.asset(
                      'assets/icons/call.svg',
                      height: 20,
                      width: 20,
                      color: cFirstColor,
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Text(
                      telefon,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: cFirstColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  showMaterialDialog<ButtonAction>(
                    context: context,
                    child: AlertDialog(
                      title: const Text('Дастурдан чиқмоқчимисиз?'),
                      content: Text(
                        'Агар дастурдан чиқсангиз, телефонингиздаги маълумотлар ўчиб кетади.',
                        //  style: dialogTextStyle,
                      ),
                      actions: <Widget>[
                        // ignore: deprecated_member_use
                        TextButton(
                          child: const Text('Бекор қилиш'),
                          onPressed: () {
                            Navigator.pop(context, ButtonAction.cancel);
                          },
                        ),
                        // ignore: deprecated_member_use
                        TextButton(
                          child: const Text('Давом этиш'),
                          onPressed: () {
                            logUOut();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: cWhiteColor),
                  height: 55,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                      ),
                      SvgPicture.asset(
                        'assets/icons/logout.svg',
                        height: 20,
                        width: 20,
                        color: cFirstColor,
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Expanded(
                          child: Text(
                        "Дастурдан чиқиш",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: cFirstColor),
                        maxLines: 2,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxHeight: 512, maxWidth: 512);
      if (image == null) return;
      final imageTemp = File(image.path);
      saveImage();
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void logUOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => route is ProfilePage);
  }

  void doSomeAsyncStuff() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ism = prefs.getString('fio') ?? "";
    telefon = prefs.getString('telefon') ?? "";
    rasmi = prefs.getString('rasmi') ?? "";
    turi = prefs.getString("turi") ?? "0";
    if (turi == "1") {
      userId = prefs.getString("mijoz_id") ?? "0";
    } else if (turi == "2") {
      userId = prefs.getString("agent_id") ?? "0";
    }
    setState(() {});
  }

  void saveImage() async {
    if (image != null) {
      List<int> imageBytes = image!.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      final Dio dio = Dio();
      var formData = FormData.fromMap({
        "id": userId + "^" + "1",
        "rasm": base64Image,
      });
      final response = await dio.post(
        baseUrl + "in_mijoz_rasm.php",
        data: formData,
        options: Options(
          receiveTimeout: 30000,
          sendTimeout: 30000,
        ),
      );
      if (response.statusCode == 200) {
        print("success");
      }
    }
  }
}
