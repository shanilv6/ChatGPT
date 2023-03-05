import 'dart:developer';
import 'package:chatgpt/constants/const.dart';
import 'package:chatgpt/constants/img_const.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/chats_provider.dart';
import '../providers/dark_theme_provider.dart';
import '../providers/models_provider.dart';
import '../widgets/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool darkMode = false;

  bool _isTyping = false;
  late ScrollController _listscrollController;
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  @override
  void initState() {
    _listscrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  //List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<WhiteThemeProvider>(context);
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(ImageConstant.openaiImage),
          ),
          title:  Text("ChatGPT",style: TextStyle(color: themeState.getWhiteTheme ? Colors.black : Colors.white),),
          actions: [
            /*  IconButton(
                onPressed: () async {
                  await Services.showModalSheet(context: context);
                },
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ))*/
          //  SwitchListTile(value: darkMode, onChanged: (bool value) {  })
            SizedBox(
              width: 60,
              height: 40,
              child: CupertinoSwitch(
               //  title: const Text('Theme'),
             /*  secondary: Icon(themeState.getDarkTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),*/
                value: themeState.getWhiteTheme,
                onChanged: (bool value) {
                  setState(() {
                    themeState.setWhiteTheme = value;
                  });
                },
              ),
            ),
          ],

        ),
        body: SafeArea(
            child: Column(children: [
          Expanded(
            child: ListView.builder(
                controller: _listscrollController,
                itemCount: chatProvider.getChatList.length, //chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider
                        .getChatList[index].msg, //chatList[index].msg,
                    chatIndex: chatProvider.getChatList[index]
                        .chatIndex, //chatList[index].chatIndex,
                  );
                }),
          ),
          if (_isTyping) ...[
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 18,
            ),
          ],
          const SizedBox(
            height: 10,
          ),
          Material(
            borderRadius: BorderRadius.circular(20),
            color: themeState.getWhiteTheme ?Colors.grey.shade200 :ColorConstant.cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      style:  TextStyle(color: themeState.getWhiteTheme ?Colors.black :Colors.white),
                      controller: textEditingController,
                      onSubmitted: (value) async {
                        await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider);
                      },
                      decoration:  InputDecoration.collapsed(
                          hintText: "How can i help you?",
                          hintStyle: GoogleFonts.plusJakartaSans(color: themeState.getWhiteTheme ? Colors.black:Colors.grey)),
                    ),
                  ),
                  Container(

                    decoration:  BoxDecoration(
                      color: themeState.getWhiteTheme?Colors.green: Colors.purple,
                      shape: BoxShape.circle
                      ,
                    ),
                    child: IconButton(
                        onPressed: () async {
                          await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
          )
        ])),
      ),
    );
  }

  void scrollListToEnd() {
    _listscrollController.animateTo(
        _listscrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
          label: "You cant send multiple messages at a time",
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
          label: "Please ask something to me",
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      /*  chatList.addAll(await ApiService.sendMessage(
          message: textEditingController.text,
          modelId: modelsProvider.getCurrentModel));*/
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(label: error.toString()),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }
}
