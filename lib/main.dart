// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:news/dynamic_link.dart';
import 'package:news/provider/anya_rajya_provider.dart';
import 'package:news/provider/apna_ragya_provider.dart';
import 'package:news/provider/apna_sheher_provider.dart';
import 'package:news/provider/homePageIndex_provider.dart';
import 'package:news/provider/radio_collection_provider.dart';
import 'package:news/provider/sheher_change_provider.dart';
import 'package:news/provider/song_management_provider.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/provider/world_provider.dart';
import 'package:news/screens/home_screen/home_screen.dart';
import 'package:news/screens/home_screen/states_screen.dart';
import 'package:flutter/material.dart';
import 'package:news/screens/radio/sub_screen_scrollManagement.dart';
import 'package:news/type/types.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

themeDataManagement() async {
  final instance = await SharedPreferences.getInstance();
  final getThemeMode = instance.get(ThemeKey);

  if (getThemeMode != null) return getThemeMode;

  await instance.setString(ThemeKey, ThemeModeTypes().lightMode);
  return ThemeModeTypes().lightMode;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  MobileAds.instance.initialize();

  final currentThemeData = await themeDataManagement();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SheherChangeProvider()),
        ChangeNotifierProvider(create: (_) => HomePageIndexProvider()),
        ChangeNotifierProvider(create: (_) => ApnaSheherIndexProvider()),
        ChangeNotifierProvider(create: (_) => ApnaRagyaIndexProvider()),
        ChangeNotifierProvider(create: (_) => SongManagementProvider()),
        ChangeNotifierProvider(create: (_) => WorldIndexProvider()),
        ChangeNotifierProvider(create: (_) => SubScrollManagement()),
        ChangeNotifierProvider(create: (_) => RadioCollectionProvider()),
        ChangeNotifierProvider(create: (_) => AnyaRajyaProvider()),
        ChangeNotifierProvider(create: (_) => ThemeChanger(currentThemeData))
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          // final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.0);
          return MediaQuery(
            child: child!,
            data: mediaQueryData.copyWith(textScaleFactor: 1.0),
          );
        },
        home: MyApp(),
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool isrunning = true;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("RESUMEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEED");
    isrunning = state == AppLifecycleState.resumed;
  }

  void navigate() async {
    await startDynamicLink();
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    navigate();

    print("CALLLLLLLLLLLLLLLLLLLLLLLLLLLLEDDDDDDDDDDDDdddd");
    // WidgetsBinding.instance.addObserver(this);
    // this.initDynamicLink();
    var d = const Duration(seconds: 1);
    // delayed 3 seconds to next page
    int c = 0;
    int x = 0;
    List s = [];

    var getallState;

    Future<void> getstate() async {
      String fileName = 'getStatesData.json';
      var dir = await getTemporaryDirectory();

      File file = File(dir.path + "/" + fileName);

      if (file.existsSync()) {
        final data = file.readAsStringSync();
        final res = jsonDecode(data);
        log('AllState==>$res');
        setState(() {
          getallState = res;
          c = getallState.length;
        });
      } else {
        try {
          final result = await InternetAddress.lookup('www.google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            String fileName = 'getStatesData.json';
            var dir = await getTemporaryDirectory();

            File file = File(dir.path + "/" + fileName);
            print("reading from internet");
            //final url = "http://5.161.78.72/api/home_top_bar_news_category";
            final url = "http://5.161.78.72/api/get_state";
            final req = await http.get(Uri.parse(url));
            log('main api call ==>${req.body}');
            if (req.statusCode == 200) {
              final body = req.body;

              file.writeAsStringSync(body, flush: true, mode: FileMode.write);
              final res = jsonDecode(body);
              setState(() {
                getallState = res;
                c = getallState.length;
              });
            } else {
              x = 0;
            }
          }
        } on SocketException catch (_) {
          setState(() {
            x = 1;
            // Toast.show("आपका इंटरनेट बंद है |");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        }
      }
      numberOfStates = c;
    }

    Future.delayed(d, () {
      getstate().then((value) {
        if (x == 0) {
          setState(() {
            states = c;
            for (int i = 0; i < c; i++) {
              s.add(getallState[i]["title"].toString());
            }
            si = s;
            print(s.length);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        //StatesScreen(s)),(route) => false);
                        MyApps(s)),
                (route) => false);
          });
        }
      });
    });
  }

  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken),
          image: AssetImage('images/hdpi_splash.png'),
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}

class MyApps extends StatefulWidget {
  MyApps(this.s, {Key? key}) : super(key: key);
  List s;

  @override
  _MyAppsState createState() => _MyAppsState();
}

class _MyAppsState extends State<MyApps> with WidgetsBindingObserver {
  Future<String> getData() async {
    String fileName = 'state_id.txt';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    if (file.existsSync()) {
      final data = file.readAsStringSync();
      return data;
    } else {
      return "0";
    }
  }

  void navigate() async {
    await startDynamicLink();
  }

  void initState() {
    print("IN INIT********************************************");
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    navigate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data != "0" ? HomeScreen() : StatesScreen(widget.s);
      },
    );
  }
}
