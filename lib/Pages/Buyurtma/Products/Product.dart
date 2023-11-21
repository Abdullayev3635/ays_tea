import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Models/BrendModel.dart';
import 'package:zilol_ays_tea/Models/TovarModel.dart';
import 'package:zilol_ays_tea/Pages/Buyurtma/ProductInfo/ProductInfo.dart';
import 'package:zilol_ays_tea/Services/webServis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';

class Product extends StatefulWidget {
  final BrendModel brendList;

  const Product({
    required this.brendList,
  }) : super();

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  TextEditingController search = TextEditingController();
  List<TovarModel> tovarList = [];
  List<TovarModel> tovarListFake = [];
  String released = "0";
  bool loadingProduct = true;
  late Widget widgetProduct = Center(
      child: CupertinoActivityIndicator(
    color: cFirstColor,
  ));
  final format = new NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    super.initState();
    doSomeBrend(widget.brendList.id.toString());
  }

  Future<void> doSomeBrend(String bolim_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    released = prefs.getString("boshagan") ?? "0";
    webServis netService = webServis();
    tovarList = await netService.getTovar(bolim_id);
    tovarListFake.addAll(tovarList);
    loadingProduct = false;
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<TovarModel> dummySearchList = [];
    dummySearchList.addAll(tovarListFake);
    if (query.isNotEmpty) {
      List<TovarModel> dummyListData = [];
      dummyListData = dummySearchList
          .where((element) =>
              element.nomi!.toUpperCase().contains(query.toUpperCase()))
          .toList();
      tovarList.clear();
      tovarList.addAll(dummyListData);
      setState(() {});
      return;
    } else {
      setState(() {
        tovarList.clear();
        tovarList.addAll(tovarListFake);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: cBackColor,
      body: Container(
        color: cBackColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 0, top: 20, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkResponse(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/icons/back_register.svg',
                        color: cFirstColor,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      widget.brendList.nomi,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: cFirstColor,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: cWhiteColor),
              height: 55,
              padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
              child: Container(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  cursorColor: cFirstColor,
                  textCapitalization: TextCapitalization.none,
                  controller: search,
                  autofocus: false,
                  onChanged: (text) {
                    filterSearchResults(text);
                  },
                  decoration: InputDecoration(
                    hintText: 'Қидириш',
                    hintStyle: TextStyle(
                      color: cTextColor2,
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
                        'assets/icons/search.svg',
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 16, color: cFirstColor),
                ),
                width: MediaQuery.of(context).size.width - 60,
                // margin: EdgeInsets.only(right: 50),
              ),
            ),
            Expanded(
              child: loadingProduct
                  ? Center(child: widgetProduct)
                  : Container(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        itemCount: tovarList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: cWhiteColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7)),
                                    child: InkResponse(
                                      onTap: () {
                                        if (tovarList[index].tovarId != "")
                                          _showSecondPage(
                                              context,
                                              baseUrl +
                                                  imgTovar +
                                                  (tovarList[index].tovarId!) +
                                                  ".png",
                                              baseUrl +
                                                  imgTovar +
                                                  (tovarList[index].tovarId!) +
                                                  ".png");
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.3,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.transparent,
                                        child: CachedNetworkImage(
                                          imageUrl: baseUrl +
                                              imgTovar +
                                              tovarList[index]
                                                  .tovarId
                                                  .toString() +
                                              ".png",
                                          placeholder: (context, url) =>
                                              Container(
                                            margin: EdgeInsets.all(32),
                                            child: SvgPicture.asset(
                                              'assets/icons/placeholder.svg',
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            margin: EdgeInsets.all(32),
                                            child: SvgPicture.asset(
                                              'assets/icons/placeholder.svg',
                                            ),
                                          ),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  ),
                                  flex: 12,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            tovarList[index].nomi!.trim(),
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: cFirstColor,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          getNarx(index),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: cRedColor,
                                          ),
                                          maxLines: 1,
                                        ),
                                        Visibility(
                                          child: Text(
                                            "Ҳозирда сотиб олиб бўлмайди!",
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: cRedColor,
                                            ),
                                            maxLines: 1,
                                          ),
                                          visible: tovarList[index].bloklandi !=
                                                  "0" &&
                                              released == "0",
                                        ),
                                        Visibility(
                                          child: Text(
                                            "Сизнинг фаолиятингиз чекланган!",
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: cRedColor,
                                            ),
                                            maxLines: 1,
                                          ),
                                          visible: released == "1",
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              MaterialButton(
                                                onPressed: () {
                                                  if (tovarList[index]
                                                              .bloklandi ==
                                                          "0" &&
                                                      released == "0") {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductInfo(
                                                          tovarList:
                                                              tovarList[index],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  'Саватчага қушиш',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: cWhiteColor,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                color: tovarList[index]
                                                                .bloklandi ==
                                                            "0" &&
                                                        released == "0"
                                                    ? cFirstColor
                                                    : cGrayColor,
                                                height: 30,
                                                minWidth: 115,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                elevation: 0,
                                              ),
                                            ],
                                          ),
                                          margin:
                                              EdgeInsets.only(right: 0, top: 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  flex: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSecondPage(BuildContext context, String imgUrl, String hero) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          body: Center(
            child: Hero(
              tag: hero,
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(imgUrl),
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getNarx(int index) {
    String narx = format
            .format(double.tryParse(tovarList[index].nalichNarxi!.toString()))
            .toString() +
        " сўм";
    return narx;
  }
}
