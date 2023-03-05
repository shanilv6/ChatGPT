import 'package:chatgpt/providers/chats_provider.dart';
import 'package:chatgpt/providers/dark_theme_provider.dart';
import 'package:chatgpt/providers/models_provider.dart';
import 'package:chatgpt/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WhiteThemeProvider themeChangeProvider = WhiteThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setWhiteTheme =
    await themeChangeProvider.whiteThemePrefs.getTheme();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModelsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => themeChangeProvider)
      ],

      child: Consumer <WhiteThemeProvider>(builder: (context, themeProvider, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(themeProvider.getWhiteTheme,context),
          home: const ChatScreen(),
        );
  },
      )
    );
  }
}
