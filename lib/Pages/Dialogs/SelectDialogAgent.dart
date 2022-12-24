import 'dart:convert';
import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Models/AgentModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SelectDialogAgent extends StatefulWidget {

  final String client_id;
  final String region_id;

  const SelectDialogAgent({
    required this.client_id,
    required this.region_id,
  }) : super();


  @override
  _SelectDialogAgentState createState() => _SelectDialogAgentState();
}

class _SelectDialogAgentState extends State<SelectDialogAgent> {
  List<AgentModel> agentList = [];
  List<AgentModel> agentlarList = [];
  TextEditingController search_controller = new TextEditingController();
  bool loading = true;
  late Widget widgetMain;

  void filterSearchResults(String query) {
    List<AgentModel> dummySearchList =[];
    dummySearchList.addAll(agentList);
    if (query.isNotEmpty) {
      List<AgentModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.fio!.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        agentlarList.clear();
        agentlarList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        agentlarList.clear();
        agentlarList.addAll(agentList);
      });
    }
  }

  @override
  void initState() {
    loading = true;
    widgetMain = Center(child: CircularProgressIndicator());
    setState(() {});
    getAgent();
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
                onChanged:(text){
                  filterSearchResults(text);
                }
              ),
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
                    itemCount: agentlarList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, {
                            "agent_nomi": agentlarList[index].fio,
                            "id": agentlarList[index].id.toString(),
                            // "qarzi_som": agentlarList[index].qarziSom.toString(),
                            // "qarzi_val": agentlarList[index].qarziVal.toString()
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
                                agentlarList[index].fio!,
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
    agentList.forEach((userDetail) {
      if (userDetail.fio!.contains(text)) {
        agentList.clear();
        agentList.add(userDetail);
      }
    });

    setState(() {});
  }

  Future<void> getAgent() async {
    final Dio dio = Dio();

    var params = {
      "region_id": widget.region_id,
      "mijoz_id": widget.client_id
    };
    Response response = await dio.post(
      baseUrl + "mijozagents",
      data: jsonEncode(params),
      options: Options(
        receiveTimeout: 6000,
        sendTimeout: 6000,
      ),
    );
    for (int i = 0; i < (response.data as List).length; i++) {
      if(response.data[i]["region_id"].toString()==widget.region_id){
        agentList.add(AgentModel.fromJson(response.data[i]));
      }
    }
    agentlarList.addAll(agentList);
    if (response.statusCode == 200) {
      loading = false;
      setState(() {});
    }
  }
}


