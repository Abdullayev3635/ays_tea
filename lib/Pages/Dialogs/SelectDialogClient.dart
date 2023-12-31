import 'dart:convert';

import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Models/MijozModel.dart';

class SelectDialogClient extends StatefulWidget {
  const SelectDialogClient({this.regionId});

  final regionId;

  @override
  _SelectDialogClientState createState() => _SelectDialogClientState();
}

class _SelectDialogClientState extends State<SelectDialogClient> {
  List<MijozModel> clientList = [];
  List<MijozModel> clientlarList = [];
  TextEditingController search_controller = new TextEditingController();
  bool loading = true;
  late Widget widgetMain;

  void filterSearchResults(String query) {
    List<MijozModel> dummySearchList = [];
    dummySearchList.addAll(clientList);
    if (query.isNotEmpty) {
      List<MijozModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.fio!.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        clientlarList.clear();
        clientlarList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        clientlarList.clear();
        clientlarList.addAll(clientList);
      });
    }
  }

  @override
  void initState() {
    loading = true;
    widgetMain = Center(
        child: CupertinoActivityIndicator(
      color: cBlackColor,
    ));
    setState(() {});
    getMijoz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: cTextColor2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.5,
        margin: EdgeInsets.symmetric(horizontal: 10),
        color: cTextColor2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'Қидириш',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(20.0),
                ),
                onChanged: (text) {
                  filterSearchResults(text);
                }),
            SizedBox(
              height: 20,
            ),
            if (loading)
              Center(child: widgetMain)
            else
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: clientlarList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, {
                          "mijoz_nomi": clientlarList[index].fio!,
                          "mijoz_id": clientlarList[index].mijozId!,
                        });
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cTextColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              clientlarList[index].fio!,
                              style:
                                  TextStyle(fontSize: 16, color: cWhiteColor),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    clientList.forEach((userDetail) {
      if (userDetail.fio!.contains(text)) {
        clientList.clear();
        clientList.add(userDetail);
      }
    });

    setState(() {});
  }

  Future<void> getMijoz() async {
    final Dio dio = Dio();
    Response response = await dio.get(
      baseUrl + "get_mijoz.php",
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.data);
      for (int i = 0; i < (parsed as List).length; i++) {
        if(widget.regionId!=null){
          if(widget.regionId==parsed[i]["region_id"]){
            clientList.add(MijozModel.fromJson(parsed[i]));
          }
        } else {
          clientList.add(MijozModel.fromJson(parsed[i]));
        }
      }
    }
    clientlarList.addAll(clientList);
    if (response.statusCode == 200) {
      loading = false;
      setState(() {});
    }
  }
}
