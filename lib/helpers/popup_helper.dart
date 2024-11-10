import 'package:flutter/cupertino.dart';

class PopupHelper{
  static fecharPopup(BuildContext context){
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}