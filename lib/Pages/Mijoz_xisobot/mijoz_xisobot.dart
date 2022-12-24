import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/NotInternetDialog.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/XizobotMijozDialogAylanma.dart';
import 'package:zilol_ays_tea/Pages/Dialogs/XizobotMijozDialogQarzdorlik.dart';

import 'package:flutter/material.dart';

import '../../Canstants/Widgets/PopupMenu.dart';

class MijozXisobot extends StatefulWidget {
  const MijozXisobot({Key? key}) : super(key: key);

  @override
  State<MijozXisobot> createState() => _MijozXisobotState();
}

class _MijozXisobotState extends State<MijozXisobot> {
  int _groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            children: [
              Spacer(),
              Center(
                child: Text(
                  'Ҳисобот',
                  style: TextStyle(fontSize: 15, color: cFirstColor),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  _myRadioButton(
                    title: "Қарздорлик",
                    value: 1,
                    isCheck: false,
                    onChanged: (newValue) =>
                        setState(() => _groupValue = newValue!),
                  ),
                  _myRadioButton(
                    title: "Савдо айланмаси",
                    value: 2,
                    isCheck: false,
                    onChanged: (newValue) =>
                        setState(() => _groupValue = newValue!),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              MaterialButton(
                onPressed: () {
                  if (_groupValue == 1) {
                    check().then((intenet) async {
                      if (intenet) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return XisobotMijozDialogQarzdorlik();
                          },
                        );
                      } else if (!intenet) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return NotInternetDialog();
                          },
                        );
                      }
                    });
                  } else if(_groupValue ==2) {
                    check().then((intenet) async {
                      if (intenet) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return XisobotMijozDialogAylanma();
                          },
                        );
                      } else if (!intenet) {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return NotInternetDialog();
                          },
                        );
                      }
                    });
                  }
                },
                //since this is only a UI app
                child: Text(
                  'Давом этиш',
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
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myRadioButton({
    required String title,
    required int value,
    required bool isCheck,
    required void Function(int?)? onChanged,
  }) {
    return RadioListTile(
      value: value,
      selectedTileColor: cFirstColor,
      activeColor: cFirstColor,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(color: cFirstColor, fontSize: 14),
      ),
    );
  }
}
