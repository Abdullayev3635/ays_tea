import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';

import '../../Canstants/Widgets/PopupMenu.dart';
import '../Dialogs/NotInternetDialog.dart';
import '../Dialogs/SelectDialogClient.dart';
import 'MapAndChange.dart';

class ClientLocationChange extends StatefulWidget {
  @override
  _ClientLocationChangeState createState() => _ClientLocationChangeState();
}

class _ClientLocationChangeState extends State<ClientLocationChange> {
  TextEditingController summa = TextEditingController();
  String client_name = "Мижозни танланг";
  String client_id = "0";
  String agentId = "0";
  bool loadingSave = false;
  Position? position;
  String addresName = 'Локация ўзгартириш';
  bool loadinggetLoacation = false;
  late double latitude;
  late double longitude;
  File? image;

  late Widget widgetSave = Center(
      child: CupertinoActivityIndicator(
    color: cWhiteColor,
  ));

  loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    agentId = prefs.getString("agent_id") ?? "0";
    loadinggetLoacation = true;
    setState(() {});
    position = await _determinePosition();
    loadinggetLoacation = false;
    setState(() {});
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
  void initState() {
    loadLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadinggetLoacation
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 0, top: 50, bottom: 12),
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
                          'Саватча',
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
                                      imageUrl: baseUrl +
                                          imgClient +
                                          client_id +
                                          ".png",
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
                            if (client_id != "0") {
                              pickImage();
                            } else {
                              _showToast(
                                  context, "Илтимос аввал клиент танланг!");
                            }
                          },
                          child: SvgPicture.asset("assets/icons/plus.svg"),
                        ),
                        bottom: 2,
                        right: 2,
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
                            client_name = value['mijoz_nomi'];
                            client_id = value['mijoz_id'];
                          });
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              client_name,
                              style:
                                  TextStyle(color: cFirstColor, fontSize: 14),
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
                          builder: (context) => MapChange(
                            position: position!,
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
                            style: TextStyle(color: cFirstColor, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  MaterialButton(
                    onPressed: () {
                      check().then((intenet) async {
                        if (intenet) {
                          if (client_id != "0") {
                            changeClient();
                          } else {
                            _showToast(
                                context, "Илтимос аввал клиент танланг!");
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

  void saveImage() async {
    if (image != null) {
      List<int> imageBytes = image!.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      final Dio dio = Dio();
      var formData = FormData.fromMap({
        "id": client_id,
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

  void changeClient() async {
    count = 1;
    loadingSave = true;
    setState(() {});
    final Dio dio = Dio();

    var formData = FormData.fromMap({
      "user_id": agentId,
      "sorov_turi": "6",
      "sorov_izox":
          position!.latitude.toString() + "~" + position!.longitude.toString(),
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
    count += 1;
    final formData2 =
        FormData.fromMap({"user_id": agentId, "sorov_id": lastId});
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
        _showToast(context, "Малумотлар ўзгартирилди!");
        loadingSave = false;
        setState(() {});
        Navigator.pop(context);
      } else {
        if (count < 60) {
          await Future.delayed(const Duration(milliseconds: 500));
          lastQuery(lastId);
        } else {
          _showToast(context,
              "Сервер актив ҳолатда эмас Дастур яратувчилари билан боғланинг!");
          loadingSave = false;
          setState(() {});
        }
      }
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
