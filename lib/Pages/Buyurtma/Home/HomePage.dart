import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/LocalStorage/Db_Halper.dart';
import 'package:zilol_ays_tea/Models/BrendModel.dart';
import 'package:zilol_ays_tea/Pages/Buyurtma/Cart/CartPage.dart';
import 'package:zilol_ays_tea/Pages/Buyurtma/Products/Product.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/BlockDialog.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/NotInternetDialog.dart';
import 'package:zilol_ays_tea/Services/webServis.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Cart/CartPage2.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataHelper _dataHelper = DataHelper();

  int? countZak = 0;

  TextEditingController search = TextEditingController();

  List<BrendModel> brendList = [];
  List<BrendModel> brendListFake = [];
  bool loadingBrend = true;
  double kurs = 0;
  String valyuta_turi = "";

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  late Widget widgetBolim = Center(
      child: CupertinoActivityIndicator(
    color: cFirstColor,
  ));

  late Widget widgetBrend = Center(
      child: CupertinoActivityIndicator(
    color: cFirstColor,
  ));

  Future<void> doSomeBrend() async {
    webServis netService = webServis();

    brendList = await netService.getBrend();

    brendListFake.addAll(brendList);
    loadingBrend = false;
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<BrendModel> dummySearchList = [];
    dummySearchList.addAll(brendListFake);
    if (query.isNotEmpty) {
      List<BrendModel> dummyListData = [];
      dummyListData = dummySearchList
          .where((element) =>
              element.nomi.toUpperCase().contains(query.toUpperCase()))
          .toList();
      setState(() {
        brendList.clear();
        brendList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        brendList.clear();
        brendList.addAll(brendListFake);
      });
    }
  }

  @override
  void initState() {
    check().then((intenet) async {
      if (intenet) {
        doSomeBrend();
      } else if (!intenet) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return NotInternetDialog();
          },
        ).then((value) => doSomeBrend());
      }
    });
    _loadCount();

    super.initState();
  }

  void load() {
    _loadCount();
  }

  void _loadCount() async {
    countZak = await _dataHelper.getCount();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var _media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cBackColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
            ),
          ),
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: cBackColor,
            flexibleSpace: Row(
              children: [
                SizedBox(
                  width: 12,
                ),
                InkResponse(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Image.asset(
                    "assets/images/menu_icon.png",
                    color: cFirstColor,
                    height: 30,
                    width: 30,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 20,
                      bottom: _media.height / 35,
                      top: _media.height / 35,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: cWhiteColor,
                    ),
                    height: 65,
                    padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => Product(
                                      brendList: BrendModel(
                                        id: "",
                                        nomi: "Барча товарлар",
                                        count: "1",
                                        img: "",
                                      ),
                                    ),
                                  ),
                                ).then((value) => {load()});
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
                                contentPadding: EdgeInsets.only(
                                    top: 5 // HERE THE IMPORTANT PART
                                    ),
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2.0, 0, 6.0, 0),
                                  child: SvgPicture.asset(
                                    'assets/icons/search.svg',
                                  ),
                                ),
                              ),
                              style:
                                  TextStyle(fontSize: 16, color: cFirstColor),
                              textAlign: TextAlign.justify,
                            ),
                            width: MediaQuery.of(context).size.width - 100,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => CartPage2(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
                            child: (countZak ?? 0) > 0
                                ? SvgPicture.asset(
                                    'assets/icons/cart_addition.svg',
                                    width: 24,
                                    height: 24,
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/cart_none.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            collapsedHeight: MediaQuery.of(context).size.height / 8,
            expandedHeight: 0,
          ),
          loadingBrend
              ? SliverToBoxAdapter(
                  child: Container(
                    child: widgetBrend,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 4),
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: cWhiteColor,
                              borderRadius: BorderRadius.circular(17)),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Product(
                                              brendList: brendList[index],
                                            ),
                                          ),
                                        ).then((value) => {load()});
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
                                              imgBrand +
                                              brendList[index].img,
                                          placeholder: (context, url) =>
                                              Container(
                                            margin: EdgeInsets.all(36),
                                            child: SvgPicture.asset(
                                              'assets/icons/placeholder.svg',
                                              color: cFirstColor,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            margin: EdgeInsets.all(36),
                                            child: SvgPicture.asset(
                                              'assets/icons/placeholder.svg',
                                              color: cFirstColor,
                                            ),
                                          ),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    flex: 3,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(17.0),
                                          bottomRight: Radius.circular(17.0),
                                        ),
                                        color: cWhiteColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          brendList[index].nomi,
                                          style: TextStyle(
                                              color: cFirstColor, fontSize: 16),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ),
                              Align(
                                child: Container(
                                  height: _media.height / 30,
                                  width: _media.height / 30,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.indigo[100]),
                                  child: Center(
                                    child: Text(
                                      brendList[index].count == ""
                                          ? "0"
                                          : brendList[index].count,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black87),
                                    ),
                                  ),
                                ),
                                alignment: Alignment.topRight,
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: brendList.length,
                    ),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void checkState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final released = prefs.getString("boshagan");
    if (released == "1") {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BlockDialog();
        },
      ).then((value) => {
            if (value["success"] == null) {checkState()}
          });
    }
  }
}
