import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Models/KarzinaModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuyurtmaInfoAgent extends StatefulWidget {
  final List<KarzinaModel> karzinaModel;

  const BuyurtmaInfoAgent({
    required this.karzinaModel,
  }) : super();

  @override
  _BuyurtmaInfoAgentState createState() =>
      _BuyurtmaInfoAgentState();
}

class _BuyurtmaInfoAgentState extends State<BuyurtmaInfoAgent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: cBackColor2,
        body: Container(
          height: double.infinity,
          color: cBackColor2,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 30, right: 0, top: 20, bottom: 20),
                color: cWhiteColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15.0, 15.0, 15.0),
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
                      'Буюртмалар № ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: cFirstColor,
                          fontSize: 18),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.karzinaModel.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(right: 16, left: 16, top: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), color: cWhiteColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              widget.karzinaModel[index].nomi,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: cTextColor3,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            margin: EdgeInsets.only(top: 15, left: 20),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 20,
                          //     ),
                          //     RichText(
                          //       text: TextSpan(children: <TextSpan>[
                          //         TextSpan(
                          //             text: "Бўлими: ",
                          //             style: TextStyle(
                          //                 color: cTextColor,
                          //                 fontSize: 13,
                          //                 fontWeight: FontWeight.w500)),
                          //         TextSpan(
                          //             text: "yangiBuyList[index].mijoz_nomi",
                          //             style: TextStyle(
                          //                 color: cFirstColor,
                          //                 fontSize: 14,
                          //                 fontWeight: FontWeight.w500)),
                          //       ]),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            child: Text(
                              widget.karzinaModel[index].miqdorSoni.toString() + " x " + widget.karzinaModel[index].nalichNarxi,
                              style: TextStyle(
                                  color: cFirstColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
