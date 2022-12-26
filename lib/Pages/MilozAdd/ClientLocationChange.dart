import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
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
  bool loadingSave = false;
  Position? position;
  String addresName = 'Локация ўзгартириш';
  bool loadinggetLoacation = false;
  late double latitude;
  late double longitude;
  File? image;

  late Widget widgetSave = Center(
      child: CircularProgressIndicator(
    color: cWhiteColor,
    strokeWidth: 3,
  ));

  loadLocation() async {
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
                                          placeholder: (context, url) =>
                                              Container(
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                            if (intenet) {
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
        "id": client_id + "^" + "1",
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
