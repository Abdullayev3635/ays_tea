import 'package:zilol_ays_tea/Canstants/color_const.dart';
import 'package:zilol_ays_tea/Pages/Buyurtma/Cart/CartPage.dart';
import 'package:zilol_ays_tea/Pages/Buyurtma/Home/HomePage.dart';
import 'package:zilol_ays_tea/Pages/History/HistoryPage.dart';
import 'package:zilol_ays_tea/Pages/Profile/ProfilePage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Canstants/Texts.dart';
import '../../Login/LoginPage.dart';
import '../../MilozAdd/ClientLocationChange.dart';
import '../../MilozAdd/MijozAdd.dart';
import '../../Payment/ClientPay.dart';
import '../../Payment/XodimPay.dart';
import '../../Xisobot/Hisobot_page.dart';
import '../items/drewer_item.dart';

class MainPage extends StatefulWidget {
  MainPage(this.turi);

  final turi;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedDrawerIndex = 0;
  String? type;
  var drawerItem;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomePage();
      case 1:
        return HistoryPage();
      case 2:
        return CartPage();
      case 3:
        return ProfilePage();
      case 4:
        return ReportPage();
      case 5:
        return ClientPay();
      default:
        return new Text("Error");
    }
  }

  _getDrawerItemWidgetXodim(int pos) {
    switch (pos) {
      case 0:
        return XodimPay();
      case 1:
        return ProfilePage();
      case 2:
        return ReportPage();
      case 3:
        return ClientAdd();
      case 4:
        return ClientLocationChange();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  String userId = "";
  String turi = "";

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    turi = prefs.getString("turi") ?? "0";
    if (turi == "1") {
      userId = prefs.getString("mijoz_id") ?? "0";
    } else if (turi == "2") {
      userId = prefs.getString("agent_id") ?? "0";
    }
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.turi == "2") {
      drawerItem = [
        DrawerItem("Тўлов", Icons.payment, IconThemeData(color: cFirstColor)),
        DrawerItem("Профиль", Icons.person, IconThemeData(color: cFirstColor)),
        DrawerItem("Хисобот", Icons.report_outlined,
            IconThemeData(color: cFirstColor)),
        DrawerItem("Мижоз қўшиш", Icons.add_task_rounded,
            IconThemeData(color: cFirstColor)),
      ];
    } else {
      drawerItem = [
        DrawerItem(
            "Буюртма", Icons.home_outlined, IconThemeData(color: cFirstColor)),
        DrawerItem("Тарих", Icons.history, IconThemeData(color: cFirstColor)),
        DrawerItem(
            "Саватча", Icons.recycling, IconThemeData(color: cFirstColor)),
        DrawerItem("Профиль", Icons.person, IconThemeData(color: cFirstColor)),
        DrawerItem("Хисобот", Icons.report_outlined,
            IconThemeData(color: cFirstColor)),
        DrawerItem("Тўлов", Icons.payment, IconThemeData(color: cFirstColor)),
      ];
    }
    var drawerOptions = <Widget>[];
    for (var i = 0; i < drawerItem.length; i++) {
      var d = drawerItem[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: cFirstColor),
              accountName: Text(
                "Abdullayev Olloyor",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "+998932133635",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: Container(
                height: 120,
                width: 120,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        baseUrl + imgClient + userId + "^" + turi + ".png",
                    placeholder: (context, url) => Container(
                      margin: EdgeInsets.all(20),
                      child: SvgPicture.asset(
                        'assets/icons/placeholder.svg',
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/person_png.png",
                      height: 120,
                      width: 120,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Column(
              children: drawerOptions,
            ),
            ListTile(
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return ClientLocationChange();
                  },
                );
              },
              leading: Icon(Icons.add_location_alt),
              title: Text("Мижозни ўзгартириш"),
            ),
            ListTile(
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Дастурдан чиқмоқчимисиз?'),
                  content: Text(
                      'Дастурдан чиқмоқчи бўлсангиз маълумотларингиз ўчиб кетади! Маълумотлар ўчишига розимисиз?'),
                  actions: <Widget>[
                    InkResponse(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('Йўқ'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    InkResponse(
                      onTap: () {
                        logUOut();
                      },
                      child: Text('Ха'),
                    ),
                  ],
                  actionsPadding: EdgeInsets.all(30),
                ),
              ),
              leading: Icon(Icons.logout),
              title: Text("Logout"),
            ),
          ],
        ),
      ),
      body: widget.turi == "2"
          ? _getDrawerItemWidgetXodim(_selectedDrawerIndex)
          : _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

  void logUOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => route is ProfilePage);
  }
}
