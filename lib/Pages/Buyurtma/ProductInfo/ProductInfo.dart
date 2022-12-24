import 'dart:math';
import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/LocalStorage/Db_Halper.dart';
import 'package:zilol_ays_tea/Models/KarzinaModel.dart';
import 'package:zilol_ays_tea/Models/TovarModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ProductInfo extends StatefulWidget {
  final TovarModel tovarList;

  const ProductInfo({
    required this.tovarList,
  }) : super();

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  double count = 1;
  bool _buttonPressed = false;
  bool _loopActive = false;
  DataHelper _dataHelper = DataHelper();
  var numGenerator = new Random();

  String edit_narx = "";

  KarzinaModel? _karzinaModel;

  TextEditingController countController = TextEditingController();

  ScrollController _scrollController = new ScrollController();
  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(double.parse(s));

  @override
  void initState() {
    super.initState();
    loadCount();
  }

  void loadCount() async {
    _karzinaModel =
        await _dataHelper.getCartById(widget.tovarList.tovarId.toString());
    if (_karzinaModel == null) {
      countController.text = "1.0";
      final s =
          '${_formatNumber(getNarx(widget.tovarList.nalichNarxi!).replaceAll(',', ''))}';
    } else {
      countController.text = _karzinaModel!.miqdorSoni.toString();
      count = double.parse(_karzinaModel!.miqdorSoni);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: cBackColor,
        body: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            margin: EdgeInsets.only(top: 0, right: 0, left: 0, bottom: 0),
            color: cBackColor,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              controller: _scrollController,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15, 15.0, 15.0, 15.0),
                          child: SvgPicture.asset(
                            'assets/icons/back_register.svg',
                            color: cFirstColor,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.tovarList.nomi!.trim(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: cFirstColor,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.3,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png",
                    placeholder: (context, url) => Container(
                      margin: EdgeInsets.all(80),
                      child: SvgPicture.asset(
                        'assets/icons/placeholder.svg',
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      margin: EdgeInsets.all(80),
                      child: SvgPicture.asset(
                        'assets/icons/placeholder.svg',
                      ),
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tovarList.nomi!.replaceAll(",", "."),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: cFirstColor,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.tovarList.nalichNarxi! + " сўм",
                        style: TextStyle(
                            color: cFirstColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(
                          height: 1,
                          color: cTextColor2,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      // Text(
                      //   "Махсулот қолдиғи: " +
                      //       widget.tovarList.qoldiq.toString(),
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w300,
                      //       color: cRedColor,
                      //       fontSize: 16),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 120,
                ),
                Text(
                  's',
                  style: TextStyle(color: cWhiteColor),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.only(left: 30),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cFirstColor,
          ),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Listener(
                      child: SvgPicture.asset('assets/icons/minus_oq.svg'),
                      onPointerDown: (details) {
                        _buttonPressed = true;
                        _decreaseCounterWhilePressed();
                      },
                      onPointerUp: (details) {
                        _buttonPressed = false;
                      },
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 35,
                      width: 90,
                      padding: EdgeInsets.only(bottom: 3),
                      decoration: BoxDecoration(
                          color: cBackColor4,
                          borderRadius: BorderRadius.circular(18)),
                      child: Center(
                        child: TextField(
                          controller: countController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              color: cWhiteColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                          onChanged: (value) {
                            try {
                              if (double.parse(widget.tovarList.qoldiq!) >
                                  double.parse(value)) {
                                count = double.parse(value);
                              } else {
                                _showToast(
                                  context,
                                  "Махсулот қолдиғи етарли эмас",
                                );
                                countController.text =
                                    widget.tovarList.qoldiq.toString();
                                count = double.parse(
                                    widget.tovarList.qoldiq.toString());
                              }
                              setState(() {});
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Listener(
                      child: SvgPicture.asset('assets/icons/plus_oq.svg'),
                      onPointerDown: (details) {
                        _buttonPressed = true;
                        _increaseCounterWhilePressed();
                      },
                      onPointerUp: (details) {
                        _buttonPressed = false;
                      },
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onSaveToCart,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: cBackColor4,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Text(
                        'Қўшиш',
                        style: TextStyle(
                            color: cWhiteColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      SvgPicture.asset(
                        'assets/icons/history_icon.svg',
                        width: 20,
                        height: 20,
                        color: cWhiteColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSaveToCart() {
    var cartInfo = KarzinaModel(
      id: _karzinaModel == null ? numGenerator.nextInt(1000000000) : _karzinaModel!.id,
      nomi: widget.tovarList.nomi!,
      tovarId: widget.tovarList.tovarId!,
      brendId: widget.tovarList.brendId!,
      blokSoni: widget.tovarList.blokSoni!,
      kirimNarxi: widget.tovarList.kirimNarxi!,
      nalichNarxi: widget.tovarList.nalichNarxi!,
      perechNarxi: widget.tovarList.perechNarxi!,
      optomNarxi: widget.tovarList.perechNarxi!,
      qoldiq: widget.tovarList.qoldiq!,
      rasmi: widget.tovarList.rasmi!,
      miqdorBlok: "1",
      miqdorSoni: countController.text,
      userId: "1",
    );
    _dataHelper.upsert(cartInfo, _karzinaModel == null);
    Navigator.pop(context);
  }

  void _increaseCounterWhilePressed() async {
    if (_loopActive) return;
    _loopActive = true;
    while (_buttonPressed) {
      if (double.tryParse(widget.tovarList.qoldiq!)! > count) {
        setState(() {
          count++;
          countController.text = count.toString();
        });
      } else {
        _showToast(context, "Махсулот қолдиғи етарли эмас");
        _buttonPressed = false;
      }

      await Future.delayed(Duration(milliseconds: 200));
    }
    _loopActive = false;
  }

  void _decreaseCounterWhilePressed() async {
    if (_loopActive) return;
    _loopActive = true;
    while (_buttonPressed) {
      if (count > 1) {
        setState(() {
          count--;
          countController.text = count.toString();
        });
      }
      await Future.delayed(Duration(milliseconds: 200));
    }
    _loopActive = false;
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

  String getNarx(String narx) {
    return narx;
  }
}
