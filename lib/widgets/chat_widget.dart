


import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/constants/const.dart';
import 'package:chatgpt/constants/img_const.dart';
import 'package:chatgpt/providers/dark_theme_provider.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatWidget extends StatefulWidget {
  final String msg;
  final int chatIndex;
   ChatWidget({Key? key, required this.msg, required this.chatIndex})
      : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  bool likeButton = false;

  bool unlikeButton = false;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<WhiteThemeProvider>(context);
    return Column(
      children: [
        Container(
          color:themeState.getWhiteTheme? ColorConstant.scaffoldLightBackgroundColor: widget.chatIndex == 0 ?
              ColorConstant.scaffoldDarkBackgroundColor :ColorConstant.cardColor


        ,  child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  widget.chatIndex == 0
                      ? ImageConstant.userImage
                      : ImageConstant.botImage,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: widget.chatIndex == 0
                        ? TextWidget(label: widget.msg,color:themeState.getWhiteTheme ? Colors.deepOrange : Colors.white,)
                        : DefaultTextStyle(
                      style: GoogleFonts.plusJakartaSans(color: themeState.getWhiteTheme ? Colors.black : Colors.white,fontWeight: FontWeight.w700,fontSize: 16),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                              repeatForever: false,
                              displayFullTextOnTap: true,
                              totalRepeatCount: 1,
                             // (color: Colors.white,fontWeight: FontWeight.w700,fontSize: 16)
                              animatedTexts: [TyperAnimatedText(widget.msg.trim())]),
                        )),
                widget.chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                likeButton = true;
                                unlikeButton = false;
                              });
                            },
                            child: likeButton == true ?
                             Icon(
                              Icons.thumb_up_rounded,
                              color: themeState.getWhiteTheme ?Colors.black: Colors.white,
                            )
                           :   Icon(
                              Icons.thumb_up_alt_outlined,
                              color: themeState.getWhiteTheme ?Colors.black: Colors.white,
                            )
                          ),
                          const SizedBox(width: 5,),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                likeButton = false;
                                unlikeButton = true;
                              });
                            },
                            child: unlikeButton == true?  Icon(Icons.thumb_down_rounded,color:themeState.getWhiteTheme ?Colors.black: Colors.white,):  Icon(Icons.thumb_down_alt_outlined,
                                color:themeState.getWhiteTheme ?Colors.black: Colors.white,)
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
