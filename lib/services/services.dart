import 'package:chatgpt/widgets/drop_down_widget.dart';
import 'package:flutter/material.dart';

import '../constants/const.dart';
import '../widgets/text_widget.dart';

class Services{
  static Future<void> showModalSheet({required BuildContext context}) async{
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20)
          ),
        ),
        backgroundColor: ColorConstant.scaffoldDarkBackgroundColor,
        context: context, builder: (context){
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Flexible(child: TextWidget(label: "Chosen Model:",fontSize: 16,)),
            Flexible(
                flex : 2,child: DropDownWidget()),
          ],
        ),
      );
    });

  }
}