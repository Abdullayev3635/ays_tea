import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Pages/MilozAdd/MijozAdd.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Mijoz_joylashuvini_korish.dart';
import 'Mijoz_ozgartirish.dart';

// ignore: camel_case_types
class Mijoz_change extends StatefulWidget {
  @override
  _Mijoz_changeState createState() => _Mijoz_changeState();
}

// ignore: camel_case_types
class _Mijoz_changeState extends State<Mijoz_change> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: cWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 2,
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/mijozlar.svg',
                  alignment: Alignment.centerRight,
                  width: 20,
                  height: 20,
                  color: cFirstColor,
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  'Мижозлар',
                  style: TextStyle(fontSize: 15, color: cFirstColor),
                ),
                Spacer(),
                InkResponse(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                    child: SvgPicture.asset(
                      'assets/icons/back_dialog.svg',
                      alignment: Alignment.centerRight,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MijozAdd(),
                //   ),
                // );
              },
              //since this is only a UI app
              child: Text(
                'Янги мижоз қўшиш',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'SFUIDisplay',
                  fontWeight: FontWeight.w400,
                ),
              ),
              color: cFirstColor,
              elevation: 0,
              minWidth: 400,
              height: 55,
              textColor: Colors.white,

              /// --------------------------------------
              /// changing border shape of material button.
              /// --------------------------------------
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Mijoz_ozgartirish();
                  },
                );
              },
              //since this is only a UI app
              child: Text(
                'Мижоз маьлумотларини ўзгартириш',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'SFUIDisplay',
                  fontWeight: FontWeight.w400,
                ),
              ),
              color: cFirstColor,
              elevation: 0,
              minWidth: 400,
              height: 55,
              textColor: Colors.white,
              /// --------------------------------------
              /// changing border shape of material button.
              /// --------------------------------------
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Mijoz_joylashuvini_korish();
                  },
                );
              },
              //since this is only a UI app
              child: Text(
                'Мижоз жойлашувини кўриш',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'SFUIDisplay',
                  fontWeight: FontWeight.w400,
                ),
              ),
              color: cFirstColor,
              elevation: 0,
              minWidth: 400,
              height: 55,
              textColor: Colors.white,
              /// --------------------------------------
              /// changing border shape of material button.
              /// --------------------------------------
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}

