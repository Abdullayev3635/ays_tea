import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class PopupMenu {
  PopupMenu({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  static PopupMenuButton<String> createPopup(List<PopupMenu> popupItems) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        popupItems.firstWhere((e) => e.title == value).onTap();
      },
      itemBuilder: (context) => popupItems
          .map((item) => PopupMenuItem<String>(
                value: item.title,
                child: Text(
                  item.title,
                ),
              ))
          .toList(),
    );
  }
}
Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}