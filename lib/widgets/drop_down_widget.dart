import 'package:chatgpt/constants/const.dart';
import 'package:chatgpt/models/models_model.dart';
import 'package:chatgpt/providers/models_provider.dart';
import 'package:chatgpt/services/api_services.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class DropDownWidget extends StatefulWidget {
  const DropDownWidget({Key? key}) : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? currentModel;

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context,listen: false);
currentModel = modelsProvider.getCurrentModel;
    return FutureBuilder(
        future: modelsProvider.getAllModels(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Center(child: TextWidget(label: snapshot.error.toString()));
          }
          return snapshot.data == null || snapshot.data!.isEmpty ? const SizedBox.shrink() :
          FittedBox(
            child: DropdownButton(items: List<DropdownMenuItem<String>>.generate(
                snapshot.data!.length,
                    (index) => DropdownMenuItem(
                    value: snapshot.data![index].id,
                    child: TextWidget(
                      label:snapshot.data![index].id,
                      fontSize: 15,
                    ))),
                dropdownColor: ColorConstant.scaffoldDarkBackgroundColor,
                iconEnabledColor: Colors.white,
                value: currentModel,
                onChanged:(value){
                  setState(() {
                    currentModel= value.toString();
                  });
           modelsProvider.setCurrentModel(value.toString());
                }),
          );

        });
  }
}

