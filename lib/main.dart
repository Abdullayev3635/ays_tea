import 'dart:convert';
import 'package:battery/battery.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'Canstants/Texts.dart';
import 'Pages/Splash/Splash.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // FlutterBackgroundService.initialize(onStart);

  runApp(MyApp());
}

var _battery = Battery();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zilol.uz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

// void isolate1(String arg) async {
//
//   lat = position.latitude.toString();
//   lng = position.longitude.toString();
// }

void onStart() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final service = FlutterBackgroundService();
  //
  // service.onDataReceived.listen((event) {
  //   if (event!["action"] == "setAsForeground") {
  //     service.setForegroundMode(true);
  //     service.setAutoStartOnBootMode(true);
  //     return;
  //   }
  //
  //   if (event["action"] == "setAsBackground") {
  //     service.setForegroundMode(false);
  //   }
  //
  //   if (event["action"] == "stopService") {
  //     service.stopBackgroundService();
  //   }
  // });
  // service.setForegroundMode(true);
  //
  // Timer.periodic(Duration(minutes: 2), (timer) async {
  //   if (!(await service.isServiceRunning())) timer.cancel();
  //   try {
  //     var position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String id = prefs.getString('Id') ?? "";
  //     String turi = prefs.getString('turi') ?? "";
  //     service.setNotificationInfo(
  //         title: "AysTea", content: "Иш режимида...");
  //     if (id != "" && turi != "3") {
  //       check().then((intenet) async {
  //         if (intenet) {
  //           upLatLng(
  //               id,
  //               position.latitude.toString(),
  //               position.longitude.toString(),
  //               (await _battery.batteryLevel).toString());
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // });
}

void upLatLng(String id, String lat, String lng, String battery) async {
  try {
    Dio dio = new Dio();
    var params = {"Id": id, "lat": lat, "lng": lng, "battery": battery};
    Response response = await dio.post(
      baseUrl + "dostavshik-buyurtma-latlng",
      data: jsonEncode(params),
      options: Options(
        receiveTimeout: 6000,
        sendTimeout: 6000,
      ),
    );
    if (response.statusCode == 200) {
      print(response.statusCode.toString());
    }
  } catch (e) {
    print(e);
  }
}
