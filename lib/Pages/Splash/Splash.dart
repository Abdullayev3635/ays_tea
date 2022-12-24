import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Pages/Login/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Canstants/Texts.dart';
import '../MainPages/MainPage/MainPage.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // void startServices() async {
  //   if(Platform.isAndroid){
  //     try{
  //       var methodChannel = MethodChannel("backgroundServices");
  //       String data = await methodChannel.invokeMethod("startServices");
  //       debugPrint(data);
  //     } on PlatformException catch(ex){
  //       print(ex);
  //     }
  //   }
  // }
  // void stopServices() async {
  //   try{
  //     dynamic value = await platform.invokeMethod('stopServices');
  //     print(value);
  //   } on PlatformException catch(ex){
  //     print(ex);
  //   }
  // }
  @override
  void initState() {
    super.initState();
    Spl();
    // loadLocation();
  }

  loadLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void stopService() async {
    FlutterBackgroundService().sendData({"action": "stopService"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: cBackColor,
        child: Center(
          child: Container(
            width: 170,
            height: 150,
            child: SvgPicture.asset(
              'assets/icons/logoMain.svg',
            ),
          ),
        ),
      ),
    );
  }

  Spl() {
    var duration = Duration(seconds: 1);
    return Timer(duration, route);
  }

  route() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final type = prefs.getString("turi") ?? "0";
    final clientId = prefs.getString("mijoz_id") ?? "0";
    final userId = prefs.getString("agent_id") ?? "0";
    if ((prefs.getString('mijoz_id') ?? "") != "" ||
        (prefs.getString('agent_id') ?? "") != "") {
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => MainPage(prefs.getString('turi')!),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }

    if (type == "1") {
      updateClient(clientId, type);
    } else if (type == "2") {
      updateUser(userId, type);
    }
  }

  void updateClient(String userId, String type) async {
    Dio dio = new Dio();
    var formData = FormData.fromMap({
      "user_id": userId,
      "turi": type,
    });
    Response response = await dio.post(
      "$baseUrl/check_state.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 200) {
      final params = jsonDecode(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (params["success"]) {
        await prefs.setString('mijoz_id', params["mijoz_id"].toString());
        await prefs.setString('fio', params["fio"].toString());
        await prefs.setString('boshagan', params["boshagan"].toString());
        await prefs.setString('inn', params["inn"].toString());
        await prefs.setString('rasmi', params["rasmi"].toString());
        await prefs.setString('telefon', params["telefon"].toString());
        await prefs.setString('parol', params["parol"].toString());
        await prefs.setString('turi', "1");
      }
    }
  }

  void updateUser(String userId, String type) async {
    Dio dio = new Dio();
    var formData = FormData.fromMap({
      "user_id": userId,
      "turi": type,
    });
    Response response = await dio.post(
      "$baseUrl/check_state.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 200) {
      final params = jsonDecode(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (params["success"]) {
        await prefs.setString('agent_id', params["agent_id"].toString());
        await prefs.setString('fio', params["fio"].toString());
        await prefs.setString('boshagan', params["boshagan"].toString());
        await prefs.setString('can_zakaz', params["can_zakaz"].toString());
        await prefs.setString('tolovTasdiq', params["tolovTasdiq"].toString());
        await prefs.setString(
            'ReestrRealizatsiya', params["ReestrRealizatsiya"].toString());
        await prefs.setString('AktSverka', params["AktSverka"].toString());
        await prefs.setString(
            'DtKtOstatkaKlient', params["DtKtOstatkaKlient"].toString());
        await prefs.setString('can_tolov', params["can_tolov"].toString());
        await prefs.setString('telefon', params["telefon"].toString());
        await prefs.setString('parol', params["parol"].toString());
        await prefs.setString('turi', "2");
      }
    }
  }
}
