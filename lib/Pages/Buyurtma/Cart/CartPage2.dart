import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:zilol_ays_tea/Canstants/Texts.dart';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/LocalStorage/Db_Halper.dart';
import 'package:zilol_ays_tea/Models/KarzinaModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CartPage2 extends StatefulWidget {
  @override
  _CartPage2State createState() => _CartPage2State();
}

enum ButtonAction {
  cancel,
  agree,
}

class _CartPage2State extends State<CartPage2> {
  List<KarzinaModel> cartList = [];
  Future<List<KarzinaModel>>? _carts;
  DataHelper _dataHelper = DataHelper();
  double count = 1;
  String clientId = "";
  String clientName = "";

  String qarzi_som = "0";
  bool loadingQarz = false;
  final format = new NumberFormat("#,##0", "en_US");
  String summa_som = "0.0";

  late Widget widgetQarz = Center(
    child: CupertinoActivityIndicator(
      color: cRedColor,
    ),
  );

  @override
  void initState() {
    loadTuri();
    _dataHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadDataCart();
    });
    super.initState();
  }

  void loadTuri() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    clientId = prefs.getString('mijoz_id') ?? "0";
    clientName = prefs.getString('fio') ?? "0";
    qarzi_som = prefs.getString('qarzi_som') ?? "0";
  }

  void loadDataCart() {
    _carts = _dataHelper.getCart();
    if (mounted) setState(() {});
    A();
  }

  A() {
    var duration = Duration(seconds: 1);
    return Timer(duration, loadTotals);
  }

  void loadTotals() async {
    getTotal();
  }

  void deleteCart(int id) {
    _dataHelper.delete(id);
    //unsubscribe for notification
    loadDataCart();
  }

  void deleteCartAll(int id) {
    _dataHelper.delete(id);
  }

  void showMaterialDialog<T>(
      {required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackColor,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        margin: EdgeInsets.only(top: 30),
        color: cBackColor,
        child: LoaderOverlay(
          useDefaultLoading: false,
          overlayOpacity: 0.2,
          overlayWidget: Center(
            child: GFLoader(
              type: GFLoaderType.ios,
              size: MediaQuery.of(context).size.width / 10,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 0, top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkResponse(
                      child: Padding(
                        padding:
                        const EdgeInsets.fromLTRB(0, 15.0, 15.0, 15.0),
                        child: SvgPicture.asset(
                          'assets/icons/back_register.svg',
                          color: cFirstColor,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
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
              Expanded(
                child: Container(
                  child: FutureBuilder<List<KarzinaModel>>(
                    future: _carts,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        cartList = snapshot.data ?? [];
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cartList.length,
                          itemBuilder: (context, index) {
                            return InkResponse(
                              onLongPress: () {
                                showMaterialDialog<ButtonAction>(
                                  context: context,
                                  child: AlertDialog(
                                    title: const Text('Ўчириш!'),
                                    content: Text(
                                      'Махсулотни ўчиришга розимисиз ?',
                                      //  style: dialogTextStyle,
                                    ),
                                    actions: <Widget>[
                                      // ignore: deprecated_member_use
                                      TextButton(
                                        child: const Text('Йўқ'),
                                        onPressed: () {
                                          Navigator.pop(
                                              context, ButtonAction.cancel);
                                        },
                                      ),
                                      // ignore: deprecated_member_use
                                      TextButton(
                                        child: const Text('Ҳа'),
                                        onPressed: () {
                                          deleteCart(cartList[index].id);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                height: 125,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          margin: EdgeInsets.only(left: 12),
                                          width: 85,
                                          height: 95,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: cBackColor2),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: baseUrl +
                                                  imgTovar +
                                                  (cartList[index].tovarId) +
                                                  ".png",
                                              placeholder: (context, url) =>
                                                  Container(
                                                margin: EdgeInsets.all(32),
                                                child: SvgPicture.asset(
                                                  'assets/icons/placeholder.svg',
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                margin: EdgeInsets.all(32),
                                                child: SvgPicture.asset(
                                                  'assets/icons/placeholder.svg',
                                                ),
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      flex: 12,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Container(
                                              child: Text(
                                                cartList[index].nomi.trim(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: cFirstColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              getNarx(index),
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: cRedColor,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkResponse(
                                                    child: SvgPicture.asset(
                                                        'assets/icons/minus.svg'),
                                                    onTap: () {
                                                      if (double.tryParse(
                                                              cartList[index]
                                                                  .miqdorSoni)! >
                                                          1) {
                                                        count = (double.tryParse(
                                                                cartList[index]
                                                                    .miqdorSoni)! -
                                                            1);
                                                        upSaveToCart(
                                                            cartList[index]);
                                                      } else {
                                                        showMaterialDialog<
                                                            ButtonAction>(
                                                          context: context,
                                                          child: AlertDialog(
                                                            title: const Text(
                                                                'Ўчириш!'),
                                                            content: Text(
                                                              'Махсулотни ўчирилишига розимисиз ?',
                                                              //  style: dialogTextStyle,
                                                            ),
                                                            actions: <Widget>[
                                                              // ignore: deprecated_member_use
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        'Йўқ'),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      ButtonAction
                                                                          .cancel);
                                                                },
                                                              ),
                                                              // ignore: deprecated_member_use
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        'Ҳа'),
                                                                onPressed: () {
                                                                  deleteCart(
                                                                      cartList[
                                                                              index]
                                                                          .id);
                                                                  Navigator.pop(
                                                                      context,
                                                                      ButtonAction
                                                                          .cancel);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                      height: 35,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          color: cBackColor2,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18)),
                                                      child: Center(
                                                        child: Text(
                                                          cartList[index]
                                                              .miqdorSoni
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  cFirstColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  InkResponse(
                                                    child: SvgPicture.asset(
                                                        'assets/icons/plus.svg'),
                                                    onTap: () {
                                                      count = (double.parse(
                                                              cartList[index]
                                                                  .miqdorSoni) +
                                                          1);
                                                      if(double.tryParse(cartList[index].qoldiq)!>=count){
                                                        upSaveToCart(
                                                            cartList[index]);
                                                      } else {
                                                        _showToast(context, "Махсулотни ${cartList[index].qoldiq} тадан ортиқ сотиб олиб бўлмайди!");
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                              margin: EdgeInsets.only(
                                                  right: 0, top: 12),
                                            )
                                          ],
                                        ),
                                      ),
                                      flex: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: CupertinoActivityIndicator(
                          color: cFirstColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 4,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Жами сўм:"),
                Text(format.format(double.tryParse(summa_som)) + " сўм"),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          InkWell(
            onTap: () {
              if (cartList.length > 0) {
                showMaterialDialog<ButtonAction>(
                  context: context,
                  child: AlertDialog(
                    title: const Text('Жўнатиш!'),
                    content: Text(
                      'Махсулотни жўнатишга розимисиз ?',
                      //  style: dialogTextStyle,
                    ),
                    actions: <Widget>[
                      // ignore: deprecated_member_use
                      TextButton(
                        child: const Text('Йўқ'),
                        onPressed: () {
                          Navigator.pop(context, ButtonAction.cancel);
                        },
                      ),
                      // ignore: deprecated_member_use
                      TextButton(
                        child: const Text('Ҳа'),
                        onPressed: () {
                          inZakaz();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              } else {
                _showToast(context, "Буюртма қилинган товарлар мавжуд эмас!");
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: cFirstColor),
              height: 55,
              child: Text(
                'Буюртма бериш',
                style: TextStyle(color: cWhiteColor, fontSize: 17),
              ),
            ),
          ),
          SizedBox(
            height: 14,
          ),
        ],
      ),
    );
  }

  void upSaveToCart(KarzinaModel karzinaModel) {
    var cartInfo = KarzinaModel(
      id: karzinaModel.id,
      nomi: karzinaModel.nomi,
      tovarId: karzinaModel.tovarId,
      brendId: karzinaModel.brendId,
      blokSoni: karzinaModel.blokSoni,
      kirimNarxi: karzinaModel.kirimNarxi,
      nalichNarxi: karzinaModel.nalichNarxi,
      perechNarxi: karzinaModel.perechNarxi,
      optomNarxi: karzinaModel.optomNarxi,
      qoldiq: karzinaModel.qoldiq,
      rasmi: karzinaModel.rasmi,
      miqdorBlok: karzinaModel.miqdorBlok,
      miqdorSoni: count.toString(),
      userId: karzinaModel.userId,
    );
    _dataHelper.update(cartInfo);
    loadDataCart();
  }

  Future<void> inZakaz() async {
    context.loaderOverlay.show(
        widget: GFLoader(
      type: GFLoaderType.ios,
      size: MediaQuery.of(context).size.width / 10,
    ));
    BaseOptions options = new BaseOptions(
      connectTimeout: 6000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    var yourresult = cartList.map((e) => e.toJson()).toList();

    var formData = FormData.fromMap({
      'mijoz_id': clientId,
      'zakaz_turi': "1",
      'mijoz_name': clientName,
      'total_summ': summa_som,
      'document': yourresult,
    });

    Response response = await dio.post(
      "${baseUrl}in_zakaz.php",
      data: formData,
      options: Options(
        receiveTimeout: 30000,
        sendTimeout: 30000,
      ),
    );
    if (response.statusCode == 200) {
      for (int i = 0; cartList.length > i; i++) {
        deleteCartAll(cartList[i].id);
      }
      loadDataCart();
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    } else {
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
      _showToast(context, "Малумотлар нотўгри");
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

  String getNarx(int index) {
    String narx = "";

    narx =
        format.format(double.tryParse(cartList[index].nalichNarxi)).toString() +
            " сўм";

    return narx;
  }

  void getTotal() {
    double jamiSom = 0;
    cartList.forEach((element) {
      jamiSom += double.parse(element.nalichNarxi == ""
          ? "0"
          : (double.parse(element.nalichNarxi.toString()) *
                  double.parse(element.miqdorSoni))
              .toString());
    });
    summa_som = jamiSom.toString();
    setState(() {});
  }
}
