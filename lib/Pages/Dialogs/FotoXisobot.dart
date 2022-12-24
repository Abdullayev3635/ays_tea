import 'dart:convert';
import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NotInternetDialog.dart';
import 'SelectDialogClient.dart';

class FotoXisobot extends StatefulWidget {
  const FotoXisobot({Key? key}) : super(key: key);

  @override
  _FotoXisobotState createState() => _FotoXisobotState();
}

class _FotoXisobotState extends State<FotoXisobot> {
  TextEditingController izox = TextEditingController();
  File? _imageFile;
  File? _imageFile1;
  File? _imageFile2;
  final _picker = ImagePicker();

  String region_nomi = "Регион танланг";
  String client_name = "Мижозни танланг";
  String agent_id = "";
  String client_id = "";
  String urlPath1 = "";
  String urlPath2 = "";
  String urlPath3 = "";
  late Widget widgetSave = Center(
      child: CircularProgressIndicator(
    color: cWhiteColor,
    strokeWidth: 3,
  ));
  bool loadingSave = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          backgroundColor: cWhiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
          insetPadding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/kamera.svg',
                      alignment: Alignment.centerRight,
                      width: 21,
                      height: 21,
                      color: cFirstColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Фото ҳисобот',
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
                // InkWell(
                //   onTap: () {
                //     showDialog(
                //       barrierDismissible: true,
                //       context: context,
                //       builder: (BuildContext context) {
                //         return SelectDialogRegion();
                //       },
                //     ).then((value) {
                //       print("fake");
                //       agent_id = value['region_id'];
                //       region_nomi = value['region_nomi'];
                //       setState(() {});
                //     });
                //   },
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 15),
                //     width: MediaQuery.of(context).size.width,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: cBackColor3),
                //     height: 55,
                //     alignment: Alignment.centerLeft,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           region_nomi,
                //           style: TextStyle(color: cFirstColor, fontSize: 14),
                //         ),
                //         Icon(
                //           Icons.arrow_drop_down_sharp,
                //           color: cFirstColor,
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                InkWell(
                  onTap: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SelectDialogClient();
                      },
                    ).then((value) {
                      client_name = value['client_nomi'];
                      client_id = value['id'];
                      setState(() {});
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          client_name,
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
                  height: 30,
                ),
                Container(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async => _pickImageFromCamera("0"),
                          child: this._imageFile == null
                              ? SvgPicture.asset(
                                  'assets/icons/default_image.svg')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(
                                    this._imageFile!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ),
                        flex: 1,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async => _pickImageFromCamera("1"),
                          child: this._imageFile1 == null
                              ? SvgPicture.asset(
                                  'assets/icons/default_image.svg')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(
                                    this._imageFile1!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ),
                        flex: 1,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async => _pickImageFromCamera("2"),
                          child: this._imageFile2 == null
                              ? SvgPicture.asset(
                                  'assets/icons/default_image.svg')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(
                                    this._imageFile2!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: cBackColor3),
                  height: 55,
                  child: Center(
                    child: TextFormField(
                      controller: izox,
                      keyboardType: TextInputType.text,
                      cursorColor: cFirstColor,
                      decoration: InputDecoration(
                        hintText: 'Изох',
                        hintStyle: TextStyle(
                          color: cTextColor,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 16, color: cFirstColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    if (client_id == "") {
                      _showToast(context, "Илтимос мижоз танланг");
                    } else {
                      uploadImage();
                    }
                    // check().then((intenet) async {
                    //   if (intenet) {
                    //
                    //   } else if (!intenet) {
                    //     showDialog(
                    //       barrierDismissible: false,
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return NotInternetDialog();
                    //       },
                    //     );
                    //   }
                    // });
                  },
                  //since this is only a UI app
                  child: loadingSave
                      ? Container(
                          child: widgetSave,
                          height: 30,
                          width: 30,
                        )
                      : Text(
                          'Давом этиш',
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

  Future<void> _pickImageFromGallery() async {
    final PickedFile? pickedFile =
        await _picker.getImage(source: ImageSource.gallery);
    setState(() => this._imageFile = File(pickedFile!.path));
  }

  Future<void> _pickImageFromCamera(String key) async {
    final PickedFile? pickedFile = await _picker.getImage(
        source: ImageSource.camera, maxHeight: 1024, maxWidth: 1024);
    setState(() {
      if (key == "0") {
        this._imageFile = File(pickedFile!.path);
      } else if (key == "1") {
        this._imageFile1 = File(pickedFile!.path);
      } else if (key == "2") {
        this._imageFile2 = File(pickedFile!.path);
      }
    });
  }

  void uploadImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      agent_id = prefs.getString('Id') ?? "";
      loadingSave = true;
      setState(() {});
      BaseOptions options = new BaseOptions(
        baseUrl: baseUrl + "hisobot/photo",
        connectTimeout: 600000,
        receiveTimeout: 600000,
      );
      Dio dio = new Dio(options);
      String fileName;
      FormData formData;
      Response response;

      try {
        if(_imageFile!=null) {
          fileName = _imageFile!
              .path
              .split('/')
              .last;
          formData = FormData.fromMap({
            "image": await MultipartFile.fromFile(_imageFile!.path,
                filename: fileName),
          });
          response = await dio.post(baseUrl + "hisobot/photo", data: formData);

          if (response.statusCode == 200) {
            urlPath1 = response.data.toString();
          }
        }
      } catch (e) {
        print(e.toString());
      }

      try {
        if(_imageFile1!=null) {
          fileName = _imageFile1!
              .path
              .split('/')
              .last;
          formData = FormData.fromMap({
            "image": await MultipartFile.fromFile(_imageFile1!.path,
                filename: fileName),
          });
          response = await dio.post(baseUrl + "hisobot/photo", data: formData);

          if (response.statusCode == 200) {
            urlPath2 = response.data.toString();
          }
        }
      } catch (e) {
        print(e.toString());
      }

      try {
        if(_imageFile2!=null){
          fileName = _imageFile2!.path.split('/').last;
          formData = FormData.fromMap({
            "image": await MultipartFile.fromFile(_imageFile2!.path,
                filename: fileName),
          });
          response = await dio.post(baseUrl + "hisobot/photo", data: formData);

          if (response.statusCode == 200) {
            urlPath3 = response.data.toString();
          }
        }
      } catch (e) {
        print(e.toString());
      }

      var params = {
        "img1": urlPath1,
        "img2": urlPath2,
        "img3": urlPath3,
        "mijoz_id": client_id,
        "agent_id": agent_id,
        "izoh" : izox.text
      };

      response = await dio.post(
        baseUrl + "hisobot/photomalumot",
        data: jsonEncode(params),
        options: Options(
          receiveTimeout: 60000,
          sendTimeout: 60000,
        ),
      );

      if (response.statusCode == 200) {
        print(response.data.toString());
        Navigator.pop(context);
        loadingSave = false;
        setState(() {});
      } else {
        _showToast(context, "Маълумот юклашда хатолик юз берди");
        loadingSave = false;
        setState(() {});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _showToast(BuildContext context, String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
