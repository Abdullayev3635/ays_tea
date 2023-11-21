import 'dart:math';
import 'package:zilol_ays_tea/Canstants/Texts.dart';
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
  double countBloc = 0;
  num norma = 0;
  bool _buttonPressed = false;
  bool _loopActive = false;
  bool _buttonPressedBloc = false;
  bool _loopActiveBloc = false;
  DataHelper _dataHelper = DataHelper();
  var numGenerator = new Random();

  String edit_narx = "";

  KarzinaModel? _karzinaModel;

  TextEditingController countController = TextEditingController();
  TextEditingController countControllerBloc = TextEditingController();

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
    norma = double.tryParse(widget.tovarList.norma ?? "0") ?? 0;
    _karzinaModel =
        await _dataHelper.getCartById(widget.tovarList.tovarId.toString());
    if (_karzinaModel == null) {
      countController.text = "1.0";
      countControllerBloc.text = "0.0";
      final s =
          '${_formatNumber(getNarx(widget.tovarList.nalichNarxi!).replaceAll(',', ''))}';
    } else {
      countController.text = _karzinaModel!.miqdorSoni.toString();
      countControllerBloc.text = _karzinaModel!.miqdorBlok.toString();
      count = double.parse(_karzinaModel!.miqdorSoni);
      countBloc = double.parse(_karzinaModel!.miqdorBlok);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackColor,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.only(top: 50, right: 0, left: 0, bottom: 0),
          color: cBackColor,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
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
                      baseUrl + imgTovar + widget.tovarList.tovarId! + ".png",
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
                      _formatNumber(widget.tovarList.nalichNarxi!) + " сўм",
                      style: TextStyle(
                          color: cFirstColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      child: Divider(
                        height: 1,
                        color: cTextColor2,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Блокда",
                      style: TextStyle(
                          color: cFirstColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    Center(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Listener(
                              child:
                                  SvgPicture.asset('assets/icons/minus_oq.svg', height: 45, width: 45,),
                              onPointerDown: (details) {
                                _buttonPressedBloc = true;
                                _decreaseCounterWhilePressedBloc();
                              },
                              onPointerUp: (details) {
                                _buttonPressedBloc = false;
                              },
                            ),
                            SizedBox(
                              width: 18,
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
                                  controller: countControllerBloc,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  readOnly: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                      color: cWhiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                  onChanged: (value) {
                                    try {
                                      countController
                                          .text = (double.tryParse(value)! *
                                              double.tryParse(
                                                  widget.tovarList.blokSoni!)!)
                                          .toString();
                                      countBloc = double.parse(value);
                                      count = countBloc * double.tryParse(widget.tovarList.blokSoni!)!;
                                      setState(() {});
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            Listener(
                              child:
                                  SvgPicture.asset('assets/icons/plus_oq.svg', height: 45, width: 45,),
                              onPointerDown: (details) {
                                _buttonPressedBloc = true;
                                _increaseCounterWhilePressedBloc();
                              },
                              onPointerUp: (details) {
                                _buttonPressedBloc = false;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      child: Divider(
                        height: 1,
                        color: cTextColor2,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "Донада",
                      style: TextStyle(
                          color: cFirstColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    Center(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Listener(
                              child:
                                  SvgPicture.asset('assets/icons/minus_oq.svg', height: 45, width: 45,),
                              onPointerDown: (details) {
                                _buttonPressed = true;
                                _decreaseCounterWhilePressed();
                              },
                              onPointerUp: (details) {
                                _buttonPressed = false;
                              },
                            ),
                            SizedBox(
                              width: 18,
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
                                  readOnly: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                      color: cWhiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                  onChanged: (value) {
                                    try {
                                      count = double.parse(value);
                                      setState(() {});
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            Listener(
                              child:
                                  SvgPicture.asset('assets/icons/plus_oq.svg', height: 45, width: 45,),
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
                    ),
                    SizedBox(
                      height: 7,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          // if(count>0){
          if (norma > 0) {
            if (norma >= num.tryParse(countController.text)!) {
              onSaveToCart();
            } else {
              _showToast(context,
                  "Махсулотни $norma тадан ортиқ сотиб олиб бўлмайди!");
            }
          } else {
            onSaveToCart();
          }
          // }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.only(left: 30),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cFirstColor,
          ),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Қўшиш',
                style: TextStyle(
                    color: cWhiteColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSaveToCart() {
    var cartInfo = KarzinaModel(
      id: _karzinaModel == null
          ? numGenerator.nextInt(1000000000)
          : _karzinaModel!.id,
      nomi: widget.tovarList.nomi!,
      tovarId: widget.tovarList.tovarId!,
      brendId: widget.tovarList.brendId!,
      blokSoni: widget.tovarList.blokSoni!,
      kirimNarxi: widget.tovarList.kirimNarxi!,
      nalichNarxi: widget.tovarList.nalichNarxi!,
      perechNarxi: widget.tovarList.perechNarxi!,
      optomNarxi: widget.tovarList.perechNarxi!,
      qoldiq: norma.toString(),
      rasmi: widget.tovarList.rasmi!,
      miqdorBlok: countControllerBloc.text,
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
      setState(() {
        count++;
        countController.text = count.toString();
      });
      await Future.delayed(Duration(milliseconds: 200));
    }
    _loopActive = false;
  }

  void _increaseCounterWhilePressedBloc() async {
    if (_loopActiveBloc) return;
    _loopActiveBloc = true;
    while (_buttonPressedBloc) {
      setState(() {
        countBloc++;
        countControllerBloc.text = countBloc.toString();
        countController.text =
            (countBloc * double.tryParse(widget.tovarList.blokSoni!)!)
                .toString();
        count = countBloc * double.tryParse(widget.tovarList.blokSoni!)!;
      });
      await Future.delayed(Duration(milliseconds: 200));
    }
    _loopActiveBloc = false;
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

  void _decreaseCounterWhilePressedBloc() async {
    if (_loopActiveBloc) return;
    _loopActiveBloc = true;
    while (_buttonPressedBloc) {
      if (countBloc > 0) {
        setState(() {
          countBloc--;
          countControllerBloc.text = countBloc.toString();
          countController.text =
              (countBloc * double.tryParse(widget.tovarList.blokSoni!)!)
                  .toString();
          count = countBloc * double.tryParse(widget.tovarList.blokSoni!)!;
        });
      }
      await Future.delayed(Duration(milliseconds: 200));
    }
    _loopActiveBloc = false;
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
