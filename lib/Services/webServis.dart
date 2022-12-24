import 'dart:convert';

import 'package:zilol_ays_tea/Canstants/Texts.dart';

import 'package:zilol_ays_tea/Models/BrendModel.dart';
import 'package:zilol_ays_tea/Models/TovarModel.dart';
import 'package:zilol_ays_tea/Models/XodimModel.dart';
import 'package:dio/dio.dart';

class webServis {
  Future<List<XodimModel>?> inRegister(String fio, String telefon, String parol,
      String turi, String latitude, String longitude) async {
    BaseOptions options = new BaseOptions(
      baseUrl: baseUrl + "servis/xodimlar",
      connectTimeout: 60000,
      receiveTimeout: 30000,
    );
    Dio dio = new Dio(options);
    var params = {
      "fio": fio,
      "telefon": telefon,
      "parol": parol,
      "turi": turi,
      "lat": latitude,
      "lng": longitude,
      "options": jsonEncode([1, 2, 3]),
    };

    Response response = await dio.post(
      "${baseUrl}servis/xodimlar",
      data: jsonEncode(params),
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 500) {
      return [];
    }
    List<XodimModel> list = [];

    for (int i = 0; i < (response.data as List).length; i++) {
      list.add(XodimModel.fromJson(response.data[i]));
    }
    return list;
  }

  Future<List<dynamic>?> inLogin(
    String telefon,
    String parol,
    String turi,
  ) async {
    BaseOptions options = new BaseOptions(
      baseUrl: baseUrl + "/get_login.php",
      connectTimeout: 60000,
      receiveTimeout: 30000,
    );
    Dio dio = new Dio(options);
    var formData = FormData.fromMap({
      "tel": telefon,
      "parol": parol,
      "turi": turi,
    });

    Response response = await dio.post(
      "$baseUrl/get_login.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    return json.decode(response.data);
  }

  Future<List<TovarModel>> getTovar(String brend_id) async {
    final Dio dio = Dio();
    var formData = FormData.fromMap({
      'brend_id': brend_id,
    });
    Response response = await dio.post(
      baseUrl + "get_tovar.php",
      data: formData,
      options: Options(
        receiveTimeout: 60000,
        sendTimeout: 60000,
      ),
    );
    List<TovarModel> list = [];
    if (response.statusCode == 200) {
      final parsed = json.decode(response.data);
      for (int i = 0; i < (parsed as List).length; i++) {
        list.add(TovarModel.fromJson(parsed[i]));
      }
    }
    return list;
  }

  Future<List<BrendModel>> getBrend() async {
    try {
      final Dio dio = Dio();
      Response response = await dio.get(
        baseUrl + "get_brand.php",
        options: Options(
          receiveTimeout: 6000,
          sendTimeout: 6000,
        ),
      );
      if (response.statusCode == 200) {
        final parsed = json.decode(response.data);
        List<BrendModel> list = [];
        for (int i = 0; i < (parsed as List).length; i++) {
          list.add(BrendModel.fromJson(parsed[i]));
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<TovarModel>> getAllTovarlar() async {
    final Dio dio = Dio();
    Response response =
        await dio.post(baseUrl + "alldata2", data: ["tovarlar"]);
    List<TovarModel> list = [];
    for (int i = 0; i < (response.data["tovarlar"] as List).length; i++) {
      list.add(TovarModel.fromJson(response.data["tovarlar"][i]));
    }
    return list;
  }
}
