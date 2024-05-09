import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news/data/image_data_collection.dart';
import 'package:news/data/text_collection.dart';
import 'package:news/provider/anya_rajya_provider.dart';
import 'package:news/provider/apna_ragya_provider.dart';
import 'package:news/provider/homePageIndex_provider.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/provider/world_provider.dart';
import 'package:news/screens/bookmark_page.dart';
import 'package:news/screens/feedback_form.dart';
import 'package:news/screens/home_screen/anyaRajya.dart';
import 'package:news/screens/home_screen/news_gallery.dart';
import 'package:news/screens/home_screen/search_screen.dart';
import 'package:news/screens/home_screen/states_screen.dart';
import 'package:news/screens/home_screen/top_news.dart';
import 'package:news/screens/home_screen/topbar_categories.dart';
import 'package:news/screens/home_screen/trendingScreen.dart';
import 'package:news/screens/humare_bare_me.dart';
import 'package:news/screens/liveTV/liveTV_screen.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/screens/niyam_aur_shartein.dart';
import 'package:news/screens/radio/radio_screen.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/inter_management.dart';
import 'package:news/widgets/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'ads/add_helper.dart';
import 'mera_sheher.dart';
import 'package:circular_menu/circular_menu.dart';

// GlobalKey<_HomeScreenState> _homeScreenStateKey = GlobalKey<_HomeScreenState>();
///okay
ValueNotifier<bool> showAppBarValue = ValueNotifier(true);
ValueNotifier<bool> showNavBarValue = ValueNotifier(true);

class HomeScreen extends StatefulWidget {
  // void showAppBar(bool value) {
  //   showAppBarValue.value = value;
  // }

  // void showBottomBar() {
  //   _HomeScreenState().showBottombar();
  // }

  // void hideBottomBar() {
  //   _HomeScreenState().hideBottombar();
  // }

  static int stId = 0;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // void turnLightMode() {
  //   setState(() {
  //     // if ((currentTheme == themeMode.darkMode)) {
  //     dark = 0;
  //     // putColor("0");
  //     // }
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomeScreen()),
  //             (route) => false);
  //   });
  // }

  // void turnDarkMode() {
  //   setState(() {
  //     // if (!(currentTheme == themeMode.darkMode)) {
  //     dark = 1;
  //     // putColor("1");
  //     // }
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomeScreen()),
  //             (route) => false);
  //   });
  // }

  // void automaticSunset() {
  //   putColor('3');
  //   DateTime now = DateTime.now();
  //   if (now.hour > 6 && now.hour < 18) {
  //     turnLightMode();
  //   } else {
  //     turnDarkMode();
  //   }
  // }
  int stid = 0;
  List homeNewsDataList = [];
  bool isLoading = true;
  int skip = 0;
  List ragyaName = [];
  List ragyaId = [];
  int topBarIndex = 0;
  int topWBarIndex = 0;
  List<dynamic> topBarData = [];
  List<dynamic> topWBarData = [];
  List<dynamic> topAnyaBarData = [];

  var topbarCoontroller = new ScrollController();
  var anyaRajyContoller = new ScrollController();
  var arCoontroller = new ScrollController();
  var wCoontroller = new ScrollController();
  bool _isMenuOpen = false;

  void _toggleMenu() {
    log('toggle call');
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

//var cCoontroller = new ScrollController();

  // category of states news
  Future<void> getTopBarData() async {
    isLoading = true;
    log('home news call ===>111111111111');
    String fileName = 'getTopBarData.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);
    var res = [];
    log('home news call ===>1111111111112');
    if (stChange == 1) {
      print(
          "get home news reading from internet because FILE DOES NOT EXIST or State changed");
      final url =
          "http://5.161.78.72/api/home_top_bar_news_category?st_id=$state_id";

      final req = await http.get(Uri.parse(url));

      log('home news call ===>1111111111112${req.body}');
      if (req.statusCode == 200) {
        print("in status 200 home news");
        final body = req.body;
        res = jsonDecode(body);
        try {
          await file.writeAsString(body, flush: true, mode: FileMode.write);
          print("FILE CREATED AND WRITTEN");
        } on Exception catch (e) {
          print("$e");
        }
        topBarData = res;
      }
    } else if (file.existsSync()) {
      print('this is running bro');
      final data = file.readAsStringSync();
      res = jsonDecode(data);
      if (res.length == 0) {
        print("get home news reading from internet FILE EXIST and DATA is []");
        final url =
            "http://5.161.78.72/api/home_top_bar_news_category?st_id=$state_id";
        final req = await http.get(Uri.parse(url));
        if (req.statusCode == 200) {
          print("in status 200 home news");
          final body = req.body;
          final res = jsonDecode(body);
          try {
            file.writeAsStringSync(body, flush: true, mode: FileMode.write);
            // print("data written in cache = $res");
          } on Exception catch (e) {
            print("$e");
          }
          topBarData = res;
        } else {
          print('file is empty and internet not connected');
        }
      } else {
        topBarData = res;
      }
    } else {
      try {
        print(
            "get home news reading from internet because FILE DOES NOT EXIST ");
        final url =
            "http://5.161.78.72/api/home_top_bar_news_category?st_id=$state_id";
        log('home news call ===>1111111111113');
        final req = await http.get(Uri.parse(url));

        if (req.statusCode == 200) {
          print("in status 200 home news");
          final body = req.body;
          res = jsonDecode(body);
          try {
            await file.writeAsString(body, flush: true, mode: FileMode.write);
            print("FILE CREATED AND WRITTEN");
          } on Exception catch (e) {
            print("$e");
          }
          topBarData = res;
        }
      } catch (e) {
        log('home news call ===>${e.toString()}');
      }
    }
    isLoading = false;
  }
  // if (file.existsSync()) {
  //   print("reading from the topbar data cache file");

  //   final data = file.readAsStringSync();
  //   final res = jsonDecode(data);

  //   topBarData = res;
  // }

  // try {
  //   final result = await InternetAddress.lookup('www.google.com');

  //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //     print('Internet connected');
  //     // print(result[0].rawAddress);
  //     String fileName = 'getTopBarData.json';
  //     var dir = await getTemporaryDirectory();

  //     File file = File(dir.path + "/" + fileName);
  //     print("reading from internet");
  //     //final url = "http://5.161.78.72/api/home_top_bar_news_category";
  //     final url =
  //         "http://5.161.78.72/api/home_top_bar_news_category?st_id=$state_id";
  //     final req = await http.get(Uri.parse(url));

  //     if (req.statusCode == 200) {
  //       final body = req.body;
  //       print(body);
  //       file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //       final res = jsonDecode(body);

  //       topBarData = res;
  //     } else {}
  //   }
  // } on SocketException catch (_) {
  //   print('not connected top data');
  // }

  // var request = http.Request('GET',
  //     Uri.parse('http://5.161.78.72/api/home_top_bar_news_category'));
  //
  // http.StreamedResponse response = await request.send();
  //
  // if (response.statusCode == 200) {
  //   var res = jsonDecode(await response.stream.bytesToString());
  //   setState(() {
  //     topBarData = res;
  //   });
  // } else {
  //   print(response.reasonPhrase);
  // }

// var request = http.Request('GET', Uri.parse('http://5.161.78.72/api/get_news_world'));

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }

  List<dynamic> topBarNewsData = [];
  String districtName = "";

  // Future<void> getTopBarNewsData() async {
  //   String fileName = 'getTopBarHoataScrolling.json';
  //   var dir = await getTemporaryDirectory();
  //
  //   File file = File(dir.path + "/" + fileName);
  //
  //   if (file.existsSync()) {
  //     print("reading from cache");
  //     final data = file.readAsStringSync();
  //     final res = jsonDecode(data);
  //
  //     setState(() {
  //       topBarNewsData = res["news"]["sourcedata"];
  //       districtName = res["district"]["title"];
  //       // scrollingDistrict=res;
  //     });
  //   } else {
  //     // print("reading from internet");
  //     // var request = http.Request(
  //     //     'GET',
  //     //     Uri.parse(
  //     //         'http://5.161.78.72/api/get_latest_news_by_district?page=1&did=8'));
  //     //
  //     // http.StreamedResponse response = await request.send();
  //     //
  //     // if (response.statusCode == 200) {
  //     //   final body = await response.stream.bytesToString();
  //     //
  //     //   file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //     //   final res = jsonDecode(body);
  //     //
  //     //   topBarNewsData = res["news"]["data"];
  //     //   districtName = res["district"]["title"];
  //     // } else {}
  //     try {
  //       final result = await InternetAddress.lookup('www.google.com');
  //       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //         print('connected');
  //         String fileName = 'getTopBarNewsDataScrolling.json';
  //         var dir = await getTemporaryDirectory();
  //         File file = File(dir.path + "/" + fileName);
  //         print("reading from internet");
  //         final url =
  //             "http://5.161.78.72/api/get_latest_news_by_district?page=1&did=8";
  //         final req = await http.get(Uri.parse(url));
  //         if (req.statusCode == 200) {
  //           final body = req.body;
  //           file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //           final res = jsonDecode(body);
  //           // scrollingDistrict=res;
  //           setState(() {
  //             topBarNewsData = res["news"]["data"];
  //             districtName = res["district"]["title"];
  //           });
  //         } else {}
  //       }
  //     } on SocketException catch (_) {
  //       print('not connected getTopBarNewsData');
  //     }
  //   }
  //
  //
  //
  // }

  int yy = 1;

  Future<void> getInfo() async {
    log('on refresh call');
    await getTopBarData();
    // getTopBarNewsData();
    getworld().then((value) {
      yy = getallworld.length;
    });
  }

  // Future<void> getrun() async {
  //   setState(() {});
  // }

  void changePage(int index) {
    // Assuming each item width is 20% of the screen width
    double itemWidth = MediaQuery.of(context).size.width * 0.2;

    // Calculate position to scroll to: center the selected tab
    double scrollToPosition = itemWidth * index -
        (MediaQuery.of(context).size.width / 2) +
        (itemWidth / 2);

    // Ensure the calculated position does not scroll out of bounds
    scrollToPosition = scrollToPosition < 0 ? 0 : scrollToPosition;
    scrollToPosition =
        scrollToPosition > topbarCoontroller.position.maxScrollExtent
            ? topbarCoontroller.position.maxScrollExtent
            : scrollToPosition;

    // Animate the scroll view to the new position
    topbarCoontroller.animateTo(
      scrollToPosition,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Use Provider to update the page index, with listen set to false to avoid unnecessary builds here
    Provider.of<HomePageIndexProvider>(context, listen: false)
        .changePage(index);
  }

  changeAnayRajyPage(int value) {
    // Assuming each item width is 20% of the screen width
    double itemWidth = MediaQuery.of(context).size.width * 0.2;

    // Calculate position to scroll to: center the selected tab
    double scrollToPosition = itemWidth * value -
        (MediaQuery.of(context).size.width / 2) +
        (itemWidth / 2);

    // Ensure the calculated position does not scroll out of bounds
    scrollToPosition = scrollToPosition < 0 ? 0 : scrollToPosition;
    scrollToPosition =
        scrollToPosition > anyaRajyContoller.position.maxScrollExtent
            ? anyaRajyContoller.position.maxScrollExtent
            : scrollToPosition;

    // Animate the scroll view to the new position
    anyaRajyContoller.animateTo(
      scrollToPosition,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    Provider.of<ApnaRagyaIndexProvider>(context, listen: false)
        .changePage(value);
  }

  changePageWorld(int value) {
    print("here: ${value}");
    Provider.of<WorldIndexProvider>(context, listen: false).changePage(value);
  }

  // id of current state
  String state_id = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
    // AnyaRajya().getInfoAboutRajya();
    getData().then((String value) {
      print('then is running after getdata in init');
      // setState(() {
      //  isOpen(o)?dark=1:dark=0;
      //  if(dark==1){putColor("1");}else {putColor("0");}
      state_id = value;
      HomeScreen.stId = int.parse(state_id);

      print("State $state_id");
      stChangeApnaRajya = 1;
      getInfo();
      // changePage(0);
      // myScroll();
      getColor().then((value) {
        if (!mounted) return;

        setState(() {
          // if (value == '3') {
          //   automatic = true;
          //   DateTime now = DateTime.now();
          //   if (now.hour > 6 && now.hour < 18) {
          //     turnLightMode();
          //   } else {
          //     turnDarkMode();
          //   }
          // } else {
          //   dark = value == "0" ? 0 : 1;
          // }
        });
        // });
      });
    });
    getReadNews();
    getAnyaRajyaInfo();
  }

  Future<void> getAnyaRajyaInfo() async {
    // printing all states except current

    String fileName = 'getStateNames.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    var stateList = [];
// 1 changed
// 0 state not changed
    if (file.existsSync() && stChange == 0) {
      final body = file.readAsStringSync();
      final res = jsonDecode(body);
      if (res.length != 0) {
        setState(() {
          stateList = res;
        });
        log('State list ==>${stateList}');
      }
    } else {
      try {
        if (stChangeApnaRajya == 1) {
          final url = "http://5.161.78.72/api/get_state";
          print(
              "get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
          final req = await http.get(Uri.parse(url));
          final body = req.body;
          file.writeAsStringSync(body, flush: true, mode: FileMode.write);
          stateList = jsonDecode(body);
          stChangeApnaRajya = 0;
          // fetching from web
        } else {
          if (file.existsSync()) {
            // is there or not
            final body = file.readAsStringSync();
            final res = jsonDecode(body);
            if (res.length == 0) {
              final url = "http://5.161.78.72/api/get_state";
              print(
                  "get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
              final req = await http.get(Uri.parse(url));
              final body = req.body;
              file.writeAsStringSync(body, flush: true, mode: FileMode.write);
              stateList = jsonDecode(body);
              stChangeApnaRajya = 0;
            } else {
              stateList = res;
            }
          } else {
            stateList = [];
            // no data
          }
        }
      } on SocketException catch (_) {
        final body = file.readAsStringSync();
        final res = jsonDecode(body);
        if (res.length == 0)
          stateList = [];
        else
          stateList = res;
      }
    }

    // if (file.existsSync() && stChangeApnaRajya == 0) {
    //   final body = file.readAsStringSync();
    //   res = jsonDecode(body);
    // } else {
    //   final url = "http://5.161.78.72/api/get_state";
    //   print(
    //       "get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
    //   final req = await http.get(Uri.parse(url));
    //   final body = req.body;
    //   file.writeAsStringSync(body, flush: true, mode: FileMode.write);
    //   res = jsonDecode(body);
    // }

    for (int i = 0; i < numberOfStates; i++) {
      if (stid != stateList[i]['sid']) {
        ragyaName.add(stateList[i]['title']);
      }

      if (stid != stateList[i]['sid']) {
        ragyaId.add(stateList[i]['sid']);
      }
    }
    print('all ragya id are $ragyaId');
    Provider.of<AnyaRajyaProvider>(context).storeRajyaName(ragyaName);
    setState(() {});

    // if (homeNewsDataList.length<=8) {
    //   for (int i = 1; i <= numberOfStates; i++) {
    //     // print('values of i are $i');
    //     if (i!= stid) {
    //       String statesId = i.toString();
    //       await getHomeNews(statesId).then((value){
    //         homeNewsDataList.add(value);
    //         // print('number is $i and data is \n $value');
    //       });
    //       // if (page == 1) {
    //       // }
    //       // else {
    //       //   // String statesId = i.toString();
    //       //   // getHomeNews(statesId).then((value) {
    //       //   //   for (var item in value['news'])
    //       //   //     homeNewsDataList[j]['news'].add(item);
    //       //   // });
    //       //   // j++;
    //       //   // return homeNewsDataList;
    //       // }
    //     }
    //   }
    // }
    // stChangeApnaRajya=0;
    // print('elements are $homeNewsDataList');
    // page++;
    // setState(() {});
  }

  void getReadNews() async {
    final fileName = "readNews.json";
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    print("reading readNews.json");
    if (file.existsSync()) {
      final body = file.readAsStringSync();
      final res = jsonDecode(body);
      setState(() {
        readNews = res;
      });
      print("readNews file " + readNews.toString());
    }
  }

  List<TimeOfDay> o = [
    TimeOfDay(hour: 20, minute: 00),
    TimeOfDay(hour: 8, minute: 00)
  ];

  bool isOpen(List<TimeOfDay> open) {
    TimeOfDay now = TimeOfDay.now();
    return (now.hour >= open[0].hour &&
            now.minute >= open[0].minute &&
            now.hour <= open[1].hour &&
            now.minute <= open[1].minute) ||
        (now.hour > open[0].hour &&
            now.hour <= open[1].hour &&
            now.minute <= open[1].minute);
  }

  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  // void showBottombar() {
  //   showNavBarValue.value = true;
  // }

  // void hideBottombar() {
  //   showNavBarValue.value = false;
  // }

  // void myScroll() async {
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.userScrollDirection ==
  //         ScrollDirection.reverse) {
  //       if (!isscrollDown) {
  //         isscrollDown = true;
  //         showAppBarValue.value = false;
  //         hideBottombar();
  //       }
  //     }
  //     if (_scrollController.position.userScrollDirection ==
  //         ScrollDirection.forward) {
  //       if (isscrollDown) {
  //         isscrollDown = false;
  //         showAppBarValue.value = true;
  //         showBottombar();
  //       }
  //     }
  //   });
  // }

  int c = 0;
  List s = [];
  var getallworld;

// Future<dynamic> getworld() async {
//     var request = http.Request('GET', Uri.parse('http://5.161.78.72/api/get_news_world'));
//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       var responseString = await response.stream.bytesToString();

//    //   print(responseString);
//     var  decode = jsonDecode(responseString);
//     getallworld=decode;

//     } else {

//       var responseString = await response.stream.bytesToString();
// print("world");
//       print(responseString);
//     }
//   }
  Future<void> getworld() async {
    String fileName = 'getWorldData.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    if (file.existsSync()) {
      print("reading from cache");

      final data = file.readAsStringSync();
      if (!mounted) return;

      final res = jsonDecode(data);

      setState(() {
        getallworld = res;
      });
    } else {
      try {
        print("reading from internet1111");
        var request = http.Request(
            'GET', Uri.parse('http://5.161.78.72/api/get_news_world'));

        http.StreamedResponse response = await request.send();
        log('home screen data api response==>${response.statusCode}');
        log('home screen data api response==>${await response.stream.bytesToString()}');
        if (response.statusCode == 200) {
          final body = await response.stream.bytesToString();
          log('home screen data api response==>$body');
          file.writeAsStringSync(body, flush: true, mode: FileMode.write);
          final res = jsonDecode(body);
          if (!mounted) return;

          setState(() {
            getallworld = res;
          });
        } else {}
      } catch (e) {
        log('home screen api response error==>${e.toString()}');
      }
    }

    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        String fileName = 'getWorldData.json';
        var dir = await getTemporaryDirectory();

        File file = File(dir.path + "/" + fileName);
        print("reading from internet");
        //final url = "http://5.161.78.72/api/home_top_bar_news_category";
        final url = "http://5.161.78.72/api/get_news_world";
        final req = await http.get(Uri.parse(url));

        if (req.statusCode == 200) {
          final body = req.body;

          file.writeAsStringSync(body, flush: true, mode: FileMode.write);
          final res = jsonDecode(body);
          setState(() {
            getallworld = res;
          });
        } else {}
      }
    } on SocketException catch (_) {
      print('not connected world');
    }
  }

  var getallState;

// Future<dynamic> getstate() async {
//     var request = http.Request('GET', Uri.parse('http://5.161.78.72/api/get_state'));
//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       var responseString = await response.stream.bytesToString();

//    //   print(responseString);
//     var  decode = jsonDecode(responseString);
//     getallState=decode;
//       c=getallState.length;
// print("state");
//     } else {

//       var responseString = await response.stream.bytesToString();
// print("state");
//       print(responseString);
//     }
//   }

  Future<bool?> cancelDialog(
      context, GlobalKey<ScaffoldState> _scaffoldKey) async {
    if (_scaffoldKey.currentState != null &&
        _scaffoldKey.currentState?.isDrawerOpen == true) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      return await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => StatefulBuilder(
              builder: (context, set) => AlertDialog(
                    title: Text('City News',
                        style: TextStyle(
                            color: !(Provider.of<ThemeChanger>(context)
                                        .getTheme() ==
                                    ThemeModeTypes().darkMode)
                                ? Colors.black
                                : Colors.white)),
                    backgroundColor:
                        (Provider.of<ThemeChanger>(context).getTheme() ==
                                ThemeModeTypes().darkMode)
                            ? Color(0xFF4D555F)
                            : Colors.white,
                    content: Text(
                      'क्या आप ऐप बंद करना चाहते हैं?',
                      style: TextStyle(
                          fontSize: 18,
                          color:
                              !(Provider.of<ThemeChanger>(context).getTheme() ==
                                      ThemeModeTypes().darkMode)
                                  ? Colors.black
                                  : Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                    onTap: () {
                                      try {
                                        launch("market://details?id=" +
                                            'com.newsbank.app');
                                      } on PlatformException catch (_) {
                                        launch(
                                            "https://play.google.com/store/apps/details?id=" +
                                                'com.newsbank.app');
                                      } finally {
                                        launch(
                                            "https://play.google.com/store/apps/details?id=" +
                                                'com.newsbank.app');
                                      }
                                      // _launchURL(
                                      //     'https://play.google.com/store/apps/details?id=com.newsbank.app');
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .20,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .12,
                                        // color: Colors.blue,
                                        child: Center(
                                          child: Text('रेटिंग दें',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.blue,
                                              )),
                                        ))),
                              ],
                            ),
                            // SizedBox(
                            //   width: 20,
                            // ),
                            // InkWell(
                            //     onTap: () {
                            //       try {
                            //         launch("market://details?id=" +
                            //             'com.newsbank.app');
                            //       } on PlatformException catch (_) {
                            //         launch(
                            //             "https://play.google.com/store/apps/details?id=" +
                            //                 'com.newsbank.app');
                            //       } finally {
                            //         launch(
                            //             "https://play.google.com/store/apps/details?id=" +
                            //                 'com.newsbank.app');
                            //       }
                            //       // _launchURL(
                            //       //     'https://play.google.com/store/apps/details?id=com.newsbank.app');
                            //     },
                            //     child: Container(
                            //         width: MediaQuery.of(context).size.width * .15,
                            //         height: MediaQuery.of(context).size.width * .08,
                            //         // color: Colors.blue,
                            //         child: Text('रेटिंग दें',
                            //             style: TextStyle(color: Colors.blue)))),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                    onTap: () => Navigator.pop(context, false),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .20,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .12,
                                        child: Center(
                                          child: Text('नहीं',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue)),
                                        ))),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                    onTap: () => SystemNavigator.pop(),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .20,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .12,
                                        child: Center(
                                          child: Text('बंद करें',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue)),
                                        ))),
                              ],
                            ),

                            // InkWell(
                            //     onTap: () => Navigator.pop(context, false),
                            //     child: Container(
                            //         width: MediaQuery.of(context).size.width * .15,
                            //         height: MediaQuery.of(context).size.width * .08,
                            //         child: Text('नहीं',
                            //             style: TextStyle(color: Colors.blue)))),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // InkWell(
                            //     onTap: () => SystemChannels.platform
                            //         .invokeMethod('SystemNavigator.pop'),
                            //     child: Container(
                            //         width: MediaQuery.of(context).size.width * .15,
                            //         height: MediaQuery.of(context).size.width * .08,
                            //         child: Text('बंद करें',
                            //             style: TextStyle(color: Colors.blue)))),
                          ],
                        ),
                      ),
                    ],
                  )));
    }
    return false;
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> getstate() async {
    String fileName = 'getStatesData.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    if (file.existsSync()) {
      print("reading from cache");

      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      setState(() {
        getallState = res;
        c = getallState.length;
      });
    } else {
      //   print("reading from internet");
      //   var request = http.Request(
      //       'GET', Uri.parse('http://5.161.78.72/api/get_state'));

      //   http.StreamedResponse response = await request.send();

      //   if (response.statusCode == 200) {
      //     final body = await response.stream.bytesToString();

      //     file.writeAsStringSync(body, flush: true, mode: FileMode.write);
      //     final res = jsonDecode(body);
      //     setState(() {
      //       getallState = res;
      //       c = getallState.length;
      //     });
      //   } else {}
      // }

      // try {
      //   final result = await InternetAddress.lookup('www.google.com');
      //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //     print('connected');
      //     String fileName = 'getStatesData.json';
      //     var dir = await getTemporaryDirectory();

      //     File file = File(dir.path + "/" + fileName);
      //     print("reading from internet");
      //     //final url = "http://5.161.78.72/api/home_top_bar_news_category";
      //     final url = "http://5.161.78.72/api/get_state";
      //     final req = await http.get(Uri.parse(url));

      //     if (req.statusCode == 200) {
      //       final body = req.body;

      //       file.writeAsStringSync(body, flush: true, mode: FileMode.write);
      //       final res = jsonDecode(body);
      //       setState(() {
      //         getallState = res;
      //         c = getallState.length;
      //       });
      //     } else {}
      //   }
      // } on SocketException catch (_) {
      //   print('not connected get state');
      // }
    }
  }

  Future<bool> _onBack() async {
    // await storage.clear();
    //
    // setState(() {
    //   list.items = storage.getItem('favourite_news') ?? [];
    // });

    // var items = storage.getItem('favourite_news');
    //
    // if (items != null) {
    //   list.items = List<Favourite>.from(
    //     (items as List).map(
    //           (item) => Favourite(
    //             api: item['api'],
    //             id: item['id'],
    //       ),
    //     ),
    //   );
    //   List<String> fav=list.items.map((item) {
    //     return item.id;
    //   }).toList();
    //   print('these are the $fav');
    //   // print(list.items[0]);
    // }
    // print(s);
    print("On back method");

    if ((_scaffoldKey.currentState!.isDrawerOpen == false)) {
      // print("if clicked");
      setState(() {
        _scaffoldKey.currentState!.openEndDrawer();
      });
      return Future.value(true);
    } else {
      print(
        "Scaffold" + _scaffoldKey.currentState.toString(),
      );

      final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
      final themeMode = ThemeModeTypes();

      return await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: Text('City News',
              style: TextStyle(
                  color: !(currentTheme == themeMode.darkMode)
                      ? Colors.black
                      : Colors.white)),
          backgroundColor: (currentTheme == themeMode.darkMode)
              ? Color(0xFF4D555F)
              : Colors.white,
          content: Text('क्या आप ऐप बंद करना चाहते हैं?',
              style: TextStyle(
                  color: !(currentTheme == themeMode.darkMode)
                      ? Colors.black
                      : Colors.white)),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                      onTap: () {
                        try {
                          launch("market://details?id=" + 'com.newsbank.app');
                        } on PlatformException catch (_) {
                          launch(
                              "https://play.google.com/store/apps/details?id=" +
                                  'com.newsbank.app');
                        } finally {
                          launch(
                              "https://play.google.com/store/apps/details?id=" +
                                  'com.newsbank.app');
                        }
                        // _launchURL(
                        //     'https://play.google.com/store/apps/details?id=com.newsbank.app');
                      },
                      child: Container(
                          child: Text('रेटिंग दें',
                              style: TextStyle(color: Colors.blue)))),
                  SizedBox(
                    width: 120,
                  ),
                  InkWell(
                      onTap: () => Navigator.pop(context, false),
                      child: Container(
                          child: Text('नहीं',
                              style: TextStyle(color: Colors.blue)))),
                  SizedBox(
                    width: 30,
                  ),
                  InkWell(
                      onTap: () => SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop'),
                      child: Container(
                          child: Text('बंद करें',
                              style: TextStyle(color: Colors.blue)))),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  ScrollController _scrollController = ScrollController();

  final _controller = ScrollController();
  bool isscrollDown = false;

  // static bool _show = true;
  double bottomBarHei = 120;

  // static bool _showAppbar = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  // _handle() {
  //   _scaffoldKey.currentState!.openDrawer();
  // }

  int lastPage = 0;
  // int _index = 0;
  int backClicked = 0;
  int lastHomeIndex = 0;
  int selectedPos = 0;
  CircularBottomNavigationController? _navigationController;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;

    _bannerAd = BannerAd(
        // Change Banner Size According to Ur Need
        size: AdSize(
            width: MediaQuery.of(context).size.width.truncate(), height: 60),
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          print("Failed to Load A Banner Ad${error.message}");
          _isBannerAdReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();

    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();
    final isAutomaticMode =
        Provider.of<ThemeChanger>(context).isAutomaticMode();

    print("Getting Current Theme: ${currentTheme}");

    Widget World() {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
          return true;
          // return await showDialog(
          //   context: context,
          //   builder: (context) => new AlertDialog(
          //     title: Text('City News',
          //         style: TextStyle(
          //             color: !(currentTheme == themeMode.darkMode)
          //                 ? Colors.black
          //                 : Colors.white)),
          //     backgroundColor: (currentTheme == themeMode.darkMode)
          //         ? Color(0xFF4D555F)
          //         : Colors.white,
          //     content: Text('क्या आप ऐप बंद करना चाहते हैं?',
          //         style: TextStyle(
          //             color: !(currentTheme == themeMode.darkMode)
          //                 ? Colors.black
          //                 : Colors.white)),
          //     actions: <Widget>[
          //       Padding(
          //         padding: const EdgeInsets.only(bottom: 10, right: 20),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             SizedBox(
          //               width: 20,
          //             ),
          //             InkWell(
          //                 onTap: () {
          //                   try {
          //                     launch(
          //                         "market://details?id=" + 'com.newsbank.app');
          //                   } on PlatformException catch (_) {
          //                     launch(
          //                         "https://play.google.com/store/apps/details?id=" +
          //                             'com.newsbank.app');
          //                   } finally {
          //                     launch(
          //                         "https://play.google.com/store/apps/details?id=" +
          //                             'com.newsbank.app');
          //                   }
          //                   // _launchURL(
          //                   //     'https://play.google.com/store/apps/details?id=com.newsbank.app');
          //                 },
          //                 child: Container(
          //                     child: Text('रेटिंग दें',
          //                         style: TextStyle(color: Colors.blue)))),
          //             SizedBox(
          //               width: 120,
          //             ),
          //             InkWell(
          //                 onTap: () => Navigator.pop(context, false),
          //                 child: Container(
          //                     child: Text('नहीं',
          //                         style: TextStyle(color: Colors.blue)))),
          //             SizedBox(
          //               width: 30,
          //             ),
          //             InkWell(
          //                 onTap: () => SystemChannels.platform
          //                     .invokeMethod('SystemNavigator.pop'),
          //                 child: Container(
          //                     child: Text('बंद करें',
          //                         style: TextStyle(color: Colors.blue)))),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // );
        },
        child: RefreshIndicator(
          onRefresh: () async {
            log('on refresh call start');
            getInfo();
          },
          child: ListView(
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            children: [
              // Container(
              //     height: 1.0,
              //     width: MediaQuery.of(context).size.width * 1,
              //     color: !(currentTheme == themeMode.darkMode)
              //         ? Colors.blue[900]!
              //         : Colors.white),
              Container(
                width: width,
                height: height,
                color: !(currentTheme == themeMode.darkMode)
                    ? Colors.white
                    : Colors.black,
                child: PageView.builder(
                    controller:
                        Provider.of<WorldIndexProvider>(context).pagecontroller,
                    onPageChanged: (value) {
                      if (Provider.of<WorldIndexProvider>(context,
                                  listen: false)
                              .pageIndex <
                          value) {
                        wCoontroller.animateTo(
                            wCoontroller.offset + width * 0.2,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn);
                      } else if (Provider.of<WorldIndexProvider>(context,
                                  listen: false)
                              .pageIndex >
                          value) {
                        wCoontroller.animateTo(
                            wCoontroller.offset - width * 0.2,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn);
                      }

                      Provider.of<WorldIndexProvider>(context, listen: false)
                          .onlychangeIndex(value);
                      setState(() {
                        topWBarIndex = value;
                      });
                    },
                    physics: ScrollPhysics(),
                    itemCount: yy == 1 ? 4 : getallworld.length,
                    itemBuilder: (context, int pageindex) {
                      int ch = getallworld[pageindex]["news_world"].length;
                      var h = (getallworld[pageindex]["news_world"].length / 3)
                          .toInt();
                      return Container(
                        color: !(currentTheme == themeMode.darkMode)
                            ? Colors.white
                            : Colors.white10,
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 76, left: 12, right: 12, top: 12),
                          child: GridView.builder(
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15),
                              itemCount:
                                  getallworld[pageindex]["news_world"].length,
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final newData =
                                    getallworld[pageindex]["news_world"][index];

                                return InkWell(
                                  onTap: () {
                                    final dataNews = {
                                      "newsTitle": newData['title'],
                                      "newsURL": newData["source_url"],
                                      "data": newData,
                                    };
                                    Get.to(WebviewScreen(),
                                        arguments: dataNews);
                                  },
                                  child: Container(
                                      alignment: Alignment.bottomCenter,
                                      // width: MediaQuery.of(context).size.width *
                                      //     0.32,
                                      // height: MediaQuery.of(context).size.width *
                                      //     0.35,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, bottom: 8.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, bottom: 10.0),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: getProperImage(
                                                          newData["logo"]),
                                                      fit: BoxFit.fill),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[900],
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                  newData["title"].toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: !(currentTheme ==
                                                themeMode.darkMode)
                                            ? Colors.white
                                            : Colors.white10,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      )),
                                );
                              }),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    }

    Widget Home() {
      return RefreshIndicator(
        onRefresh: () async {
          log('on refresh call start');
          getInfo();
        },
        child:  ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    width: width,
                    height: height,
                    color: !(currentTheme == themeMode.darkMode)
                        ? Colors.white
                        : Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 125,
                      ),
                      child: PageView.builder(
                        controller: Provider.of<HomePageIndexProvider>(context)
                            .pagecontroller,
                        onPageChanged: (value) {
                          print(value.toString() + " dsadasd");
                          if (Provider.of<HomePageIndexProvider>(context,
                                      listen: false)
                                  .pageIndex <
                              value) {
                            topbarCoontroller.animateTo(
                              topbarCoontroller.offset + width * 0.2,
                              duration: Duration(seconds: 2),
                              curve: Curves.easeIn,
                            );
                          } else if (Provider.of<HomePageIndexProvider>(context,
                                      listen: false)
                                  .pageIndex >
                              value) {
                            topbarCoontroller.animateTo(
                              topbarCoontroller.offset - width * 0.2,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeIn,
                            );
                          }

                          Provider.of<HomePageIndexProvider>(context,
                                  listen: false)
                              .onlychangeIndex(value);
                          setState(() {
                            topBarIndex = value == 0 ? value : value - 1;
                          });
                        },
                        // physics: BouncingScrollPhysics(),
                        itemCount: topBarData.length + 1,
                        itemBuilder: (context, int pageindex) {
                          try {
                            if (pageindex - 1 == -1) {
                              Future.delayed(Duration(milliseconds: 2000));
                            }
                            if (Provider.of<HomePageIndexProvider>(context)
                                    .pageIndex ==
                                0) {
                              return TopNews();
                            } else if (pageindex == 0) {
                              return TopBarCategory(
                                  cpId: topBarData[lastHomeIndex - 1]["cp_id"]);
                            } else {
                              lastHomeIndex = pageindex;
                              return TopBarCategory(
                                  cpId: topBarData[pageindex - 1]["cp_id"]);
                            }
                          } catch (e) {
                            print(e);
                          }
                          return TopNews();

                          // Provider.of<HomePageIndexProvider>(context)
                          //               .pageIndex ==
                          //           0 &&
                          //       pageindex == 0
                          //   ? TopNews(_scrollController)
                          //   :
                        },
                      ),
                    ),
                  ),
                  // Container(
                  //   width: width,
                  //   height: height * 0.9,
                  //   color: !(currentTheme == themeMode.darkMode) ? Colors.white : Colors.black,
                  //   child: PageView.builder(
                  //       controller: Provider.of<HomePageIndexProvider>(context)
                  //           .pagecontroller,
                  //       onPageChanged: (value) {
                  //         if (Provider.of<HomePageIndexProvider>(context,
                  //                     listen: false)
                  //                 .pageIndex <
                  //             value) {
                  //           topbarCoontroller.animateTo(
                  //               topbarCoontroller.offset + width * 0.2,
                  //               duration: Duration(seconds: 1),
                  //               curve: Curves.easeIn);
                  //         } else if (Provider.of<HomePageIndexProvider>(context,
                  //                     listen: false)
                  //                 .pageIndex >
                  //             value) {
                  //           topbarCoontroller.animateTo(
                  //               topbarCoontroller.offset - width * 0.2,
                  //               duration: Duration(seconds: 1),
                  //               curve: Curves.easeIn);
                  //         }

                  //         Provider.of<HomePageIndexProvider>(context, listen: false)
                  //             .onlychangeIndex(value);
                  //         setState(() {
                  //           topBarIndex = value == 0 ? value : value - 1;
                  //         });
                  //       },
                  //       physics: ScrollPhysics(),
                  //       itemCount: topBarData.length + 1,
                  //       itemBuilder: (context, int pageindex) {
                  //         return Provider.of<HomePageIndexProvider>(context)
                  //                     .pageIndex ==
                  //                 0
                  //             ? TopNews(_scrollController)
                  //             : TopBarCategory(_scrollController,
                  //                 cpId: topBarData[pageindex - 1]["cp_id"]);
                  //       }),
                  // ),
                ],
              ),
      );
    }

    // Widget Anayee() {
    //   return RefreshIndicator(
    //     onRefresh: () => getrun(),
    //     child: ListView(
    //       shrinkWrap: true,
    //       physics: ScrollPhysics(),
    //       children: [
    //         Container(
    //             height: 1.0,
    //             width: MediaQuery.of(context).size.width * 1,
    //             color: !(currentTheme == themeMode.darkMode) ? Colors.blue[900]! : Colors.white),
    //         Container(
    //           height: height * 0.05,
    //           child: ListView.builder(
    //               itemCount: states,
    //               controller: arCoontroller,
    //               scrollDirection: Axis.horizontal,
    //               itemBuilder: (context, int index) {
    //                 int ind = index == 0 ? 0 : index - 1;
    //                 return InkWell(
    //                   onTap: () {
    //                     changePage(index);
    //                   },
    //                   child: Container(
    //                     color: !(currentTheme == themeMode.darkMode) ? Colors.white : Colors.black,
    //                     height: height * 0.05,
    //                     width: width * 0.2,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.stretch,
    //                       children: [
    //                         Expanded(
    //                             child: Center(
    //                                 child: heading(
    //                                     text: si[index + 1].toString(),
    //                                     color: topWBarIndex == index
    //                                         ? Colors.orange[900]!
    //                                         : !(currentTheme == themeMode.darkMode)
    //                                             ? Colors.blue[900]!
    //                                             : Colors.white))),
    //                         Container(
    //                             height: 3,
    //                             color: topWBarIndex == index
    //                                 ? Colors.blue
    //                                 : Colors.white)
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //                 //
    //               }),
    //         ),
    //         Container(
    //           width: width,
    //           height: height * 0.9,
    //           color: !(currentTheme == themeMode.darkMode) ? Colors.white : Colors.black,
    //           child: PageView.builder(
    //               controller: Provider.of<HomePageIndexProvider>(context)
    //                   .pagecontroller,
    //               onPageChanged: (value) {
    //                 if (Provider.of<HomePageIndexProvider>(context,
    //                             listen: false)
    //                         .pageIndex <
    //                     value) {
    //                   arCoontroller.animateTo(
    //                       arCoontroller.offset + width * 0.2,
    //                       duration: Duration(seconds: 1),
    //                       curve: Curves.easeIn);
    //                   //      getTop(value+1).then((value) {setState(() {
    //                   // });});
    //                 } else if (Provider.of<HomePageIndexProvider>(context,
    //                             listen: false)
    //                         .pageIndex >
    //                     value) {
    //                   arCoontroller.animateTo(
    //                       arCoontroller.offset - width * 0.2,
    //                       duration: Duration(seconds: 1),
    //                       curve: Curves.easeIn);
    //                   //      getTop(value+1).then((value) {setState(() {
    //                   // });});
    //                 }
    //
    //                 Provider.of<HomePageIndexProvider>(context, listen: false)
    //                     .onlychangeIndex(value);
    //                 setState(() {
    //                   topWBarIndex = value;
    //                 });
    //               },
    //               physics: ScrollPhysics(),
    //               itemCount: states,
    //               itemBuilder: (context, int pageindex) {
    //                 return
    //                     //  Provider.of<HomePageIndexProvider>(context)
    //                     //             .pageIndex.toString() ==
    //                     //         hi
    //                     //     ? SizedBox()
    //                     //     :
    //                     //     Container(child:Text(topWBarIndex.toString()));
    //
    //                     TopBarCategory(_scrollController,
    //                         cpId: cat[topWBarIndex]);
    //               }),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    List<Widget> _pages = <Widget>[
      Home(),
      AnyaRajya(),
      LiveTVScreen(),
      RadioScreen(),
      MeraSheher(),
      // TrendingScreen(),
      // World(),
    ];

    // List<TabItem> tabItems = List.of([
    //   TabItem(Icons.home, "होम", Colors.blue[900]!,
    //       labelStyle: TextStyle(fontWeight: FontWeight.bold)),
    //   TabItem(Icons.location_pin, "मेरा शहर", Colors.blue[900]!,
    //       labelStyle: TextStyle(fontWeight: FontWeight.bold)),
    //   TabItem(Icons.map, "अन्य राज्य", Colors.blue[900]!,
    //       labelStyle: TextStyle(fontWeight: FontWeight.bold)),
    //   TabItem(
    //       Icons.local_fire_department_outlined, "ट्रेंडिंग", Colors.blue[900]!,
    //       labelStyle: TextStyle(fontWeight: FontWeight.bold)),
    //   TabItem(Icons.bakery_dining_outlined, "न्यूज वर्ल्ड", Colors.blue[900]!,
    //       labelStyle: TextStyle(fontWeight: FontWeight.bold)),
    // ]);
    int _tabIndex = Provider.of<HomePageIndexProvider>(context).tabIndex;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          !(currentTheme == themeMode.darkMode) ? Colors.white : Colors.black,
      // floatingActionButton: CircularMenu(
      //   alignment: Alignment.bottomCenter,
      //   radius: 60,
      //   toggleButtonBoxShadow: [BoxShadow(color: Colors.transparent)],
      //   toggleButtonColor: Colors.blue[900],
      //   toggleButtonIconColor: Colors.white,
      //   toggleButtonAnimatedIconData: AnimatedIcons.menu_close,
      //   items: [
      //     CircularMenuItem(
      //         icon: Icons.tv,
      //         color: Colors.blue[900],
      //         boxShadow: [],
      //         onTap: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => LiveTVScreen()));
      //         }),
      //     CircularMenuItem(
      //         icon: Icons.local_fire_department_outlined,
      //         color: Colors.blue[900],
      //         boxShadow: [],
      //         enableBadge: false,
      //         onTap: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => TrendingScreen()));
      //         }),
      //     CircularMenuItem(
      //         icon: Icons.radio,
      //         color: Colors.blue[900],
      //         boxShadow: [],
      //         enableBadge: false,
      //         onTap: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => RadioScreen()));
      //         }),
      //   ],
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 55,
        decoration: BoxDecoration(
          color: !(currentTheme == themeMode.darkMode)
              ? Colors.white
              : Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _bottomNavigationBarItem(
                iconSrc: ImageDataCollection.homeIcon,
                label: "होम",
                tabIndex: 0,
                onTap: () =>
                    Provider.of<HomePageIndexProvider>(context, listen: false)
                        .changeTabIndex(0)),

            _bottomNavigationBarItem(
                iconSrc: ImageDataCollection.otherStateIcon,
                label: "अन्य राज्य",
                tabIndex: 1,
                onTap: () =>
                    Provider.of<HomePageIndexProvider>(context, listen: false)
                        .changeTabIndex(1)),
            _bottomNavigationBarItem(
                iconSrc: ImageDataCollection.liveNewsIcon,
                label: "लाइव न्यूज",
                tabIndex: 2,
                onTap: () =>
                    Provider.of<HomePageIndexProvider>(context, listen: false)
                        .changeTabIndex(2)),
            _bottomNavigationBarItem(
                iconSrc: ImageDataCollection.radioIcon,
                label: "रेडियो",
                tabIndex: 3,
                onTap: () =>
                    Provider.of<HomePageIndexProvider>(context, listen: false)
                        .changeTabIndex(3)),
            _bottomNavigationBarItem(
                iconSrc: ImageDataCollection.myCityICon,
                label: "मेरा शहर",
                tabIndex: 4,
                onTap: () =>
                    Provider.of<HomePageIndexProvider>(context, listen: false)
                        .changeTabIndex(4)),
            // _bottomNavigationBarItem(
            //     iconSrc: ImageDataCollection.worldNewsIcon,
            //     label: "न्यूज वर्ल्ड",
            //     tabIndex: 4,
            //     onTap: () =>
            //         Provider.of<HomePageIndexProvider>(context, listen: false)
            //             .changeTabIndex(4)),
          ],
        ),
      ),

      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[900],
          title: Consumer<HomePageIndexProvider>(
            builder: (context, value, child) {
              return heading(
                  text: value.tabIndex == 1
                      ? 'अन्य राज्य'
                      : value.tabIndex == 2
                          ? "लाइव न्यूज"
                          : value.tabIndex == 3
                              ? "रेडियो"
                              : value.tabIndex == 4
                                  ? "मेरा शहर"
                                  : "City News",
                  color: Colors.white);
            },
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.search,
                )),
            SizedBox(width: 10),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrendingScreen()));
                },
                child: Icon(Icons.local_fire_department_outlined)),
            SizedBox(width: 10),
            // GestureDetector(
            //     onTap: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => RadioScreen()));
            //     },
            //     child: Icon(Icons.radio)),
            // SizedBox(width: 10),
            GestureDetector(
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BookmarkPage()));
                },
                child: Icon(Icons.bookmark)),
            SizedBox(width: 10),
            // Icon(Icons.notifications),
          ],
          bottom: _tabIndex == 0 || _tabIndex == 1
              ? PreferredSize(
                  preferredSize: Size.fromHeight(35),
                  child: _tabIndex == 1
                      ? numberOfStates <= 0
                          ? Container()
                          : Container(
                              color: Colors.blue[900],
                              height: height * 0.05,
                              child: ListView.builder(
                                  controller: anyaRajyContoller,
                                  itemCount: numberOfStates,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        // setState(() {
                                        //   topBarIndex = index == 0 ? index : index - 1;
                                        // });
                                        changeAnayRajyPage(index);
                                      },
                                      child: Container(
                                        color: Colors.blue[900],
                                        height: height * 0.05,
                                        width: width * 0.17,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                                child: Center(
                                                    child: heading(
                                              text: ragyaName[index].toString(),
                                              color:
                                                  Provider.of<ApnaRagyaIndexProvider>(
                                                                  context)
                                                              .pageIndex ==
                                                          index
                                                      ? Colors.white
                                                      : Colors.grey,
                                            ))),
                                            // Provider.of<ApnaSheherIndexProvider>(
                                            //     context)
                                            //     .pageIndex == 0
                                            //     ? topBarIndex == index ? Colors.orange[900]! : !(currentTheme == themeMode.darkMode)
                                            //     ? Colors.blue[900]!
                                            //     : Colors.white
                                            //     : topBarIndex == index - 1
                                            //     ? Colors.orange[900]!
                                            //     : !(currentTheme == themeMode.darkMode)
                                            //     ? Colors.blue[900]!
                                            //     : Colors.white))),
                                            Container(
                                                height: 3,
                                                color:
                                                    Provider.of<ApnaRagyaIndexProvider>(
                                                                    context)
                                                                .pageIndex ==
                                                            index
                                                        ? Colors.orange
                                                        : Colors.blue[900]

                                                // Provider.of<ApnaSheherIndexProvider>(context)
                                                //     .pageIndex ==
                                                //     0
                                                //     ? topBarIndex == index
                                                //     ? Colors.blue
                                                //     : Colors.white
                                                //     : topBarIndex == (index - 1)
                                                //     ? Colors.blue
                                                //     : Colors.white
                                                ),
                                          ],
                                        ),
                                      ),
                                    );
                                    //
                                  }),
                            )
                      : _tabIndex == 4
                          ? Container(
                              color: Colors.blue[900],
                              height: height * 0.05,
                              child: ListView.builder(
                                itemCount: yy == 1 ? 4 : getallworld.length,
                                controller: wCoontroller,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, int index) {
                                  int ind = index == 0 ? 0 : index - 1;
                                  return InkWell(
                                    onTap: () {
                                      changePageWorld(index);
                                    },
                                    child: Container(
                                      color: Colors.blue[900],
                                      height: height * 0.05,
                                      width: width * 0.25,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: heading(
                                                  text: getallworld[index]
                                                          ["category"]["title"]
                                                      .toString(),
                                                  color: topWBarIndex == index
                                                      ? Colors.white
                                                      : Colors.grey),
                                            ),
                                          ),
                                          Container(
                                              height: 3,
                                              color: topWBarIndex == index
                                                  ? Colors.orange
                                                  : Colors.blue[900]),
                                        ],
                                      ),
                                    ),
                                  );
                                  //
                                },
                              ),
                            )
                          : Container(
                              color: Colors.blue[900],
                              height: height * 0.05,
                              child: ListView.builder(
                                itemCount: topBarData.length + 1,
                                controller: topbarCoontroller,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, int index) {
                                  int ind = index == 0 ? 0 : index - 1;
                                  return InkWell(
                                    onTap: () {
                                      changePage(index);
                                    },
                                    // printing sliding heading bar
                                    child: Container(
                                      color: Colors.blue[900],
                                      height: height * 0.05,
                                      width: width * 0.2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: heading(
                                                text: index > 0
                                                    ? topBarData[ind]["title"]
                                                    : "टॉप न्यूज़",
                                                color:
                                                    Provider.of<HomePageIndexProvider>(
                                                                    context)
                                                                .pageIndex ==
                                                            0
                                                        ? topBarIndex == index
                                                            ? Colors.white
                                                            : Colors.grey
                                                        : topBarIndex ==
                                                                index - 1
                                                            ? Colors.white
                                                            : Colors.grey,
                                              ),
                                            ),
                                          ),
                                          // highlighting the selected feature like top news
                                          Container(
                                            height: 2,
                                            color:
                                                Provider.of<HomePageIndexProvider>(
                                                                context)
                                                            .pageIndex ==
                                                        0
                                                    ? topBarIndex == index
                                                        ? Colors.orange
                                                        : Colors.blue[900]
                                                    : topBarIndex == (index - 1)
                                                        ? Colors.orange
                                                        : Colors.blue[900],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                  //
                                },
                              ),
                            ),
                )
              : PreferredSize(
                  preferredSize: Size.fromHeight(0), child: Container())),

      // ),
      drawer: SafeArea(
        child: Drawer(
          child: SingleChildScrollView(
            child: Container(
              color: !(currentTheme == themeMode.darkMode)
                  ? Colors.white
                  : Colors.black,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("images/icon-modified.png",
                            height: 100, width: 100),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              "NEWS",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 25),
                            ),
                            Text(
                              "BANK",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   "पल पल की खबर, हर पल",
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.red,
                  //       fontSize: 18),
                  // ),
                  // !(currentTheme == themeMode.darkMode)
                  //     ? Divider(
                  //         thickness: 1,
                  //       )
                  //     : Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //             height: 1.0,
                  //             width: MediaQuery.of(context).size.width * 1,
                  //             color: !(currentTheme == themeMode.darkMode)
                  //                 ? Colors.blue[900]!
                  //                 : Colors.white),
                  //       ),
                  // Divider(
                  //   thickness: 1,
                  // ),
                  // Theme(
                  //   data: Theme.of(context)
                  //       .copyWith(dividerColor: Colors.transparent),
                  //   child:
                  HorizontalDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ExpansionTile(
                      // backgroundColor: !(currentTheme == themeMode.darkMode)
                      //     ? Colors.blue.withOpacity(0.5)
                      //     : Color(0xff303238),
                      leading: Icon(
                        Icons.brightness_6_outlined,
                        color: !(currentTheme == themeMode.darkMode)
                            ? Colors.blue[900]
                            : Colors.white,
                      ),
                      title: Text(
                        "डार्क मोड",
                        style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        size: 22,
                        color: !(currentTheme == themeMode.darkMode)
                            ? Colors.black
                            : Colors.white,
                      ),
                      children: [
                        TextButton(
                          onPressed: () async {
                            final instance =
                                await SharedPreferences.getInstance();
                            await instance.setString(
                                ThemeKey, ThemeModeTypes().lightMode);

                            Provider.of<ThemeChanger>(context, listen: false)
                                .setTheme(ThemeModeTypes().lightMode);
                          },
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            leading: Icon(
                              !isAutomaticMode &&
                                      !(currentTheme == themeMode.darkMode)
                                  ? Icons.circle_rounded
                                  : Icons.circle_outlined,
                              color: !(currentTheme == themeMode.darkMode)
                                  ? Colors.black
                                  : Colors.white,
                              size: 18,
                            ),
                            contentPadding: EdgeInsets.only(left: 20),
                            title: Text(
                              'Off',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: !(currentTheme == themeMode.darkMode)
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final instance =
                                await SharedPreferences.getInstance();
                            await instance.setString(
                                ThemeKey, ThemeModeTypes().darkMode);

                            Provider.of<ThemeChanger>(context, listen: false)
                                .setTheme(ThemeModeTypes().darkMode);
                          },
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(
                              (!isAutomaticMode &&
                                      currentTheme == themeMode.darkMode)
                                  ? Icons.circle_rounded
                                  : Icons.circle_outlined,
                              color: !(currentTheme == themeMode.darkMode)
                                  ? Colors.black
                                  : Colors.white,
                              size: 18,
                            ),
                            title: Text(
                              'On',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: !(currentTheme == themeMode.darkMode)
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ),
                        ),
                        HorizontalDivider(),
                        TextButton(
                          onPressed: () async {
                            final instance =
                                await SharedPreferences.getInstance();
                            await instance.setString(
                                ThemeKey, ThemeModeTypes().autoMode);

                            Provider.of<ThemeChanger>(context, listen: false)
                                .setTheme(ThemeModeTypes().autoMode);
                          },
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(
                              (isAutomaticMode)
                                  ? Icons.circle_rounded
                                  : Icons.circle_outlined,
                              color: !(currentTheme == themeMode.darkMode)
                                  ? Colors.black
                                  : Colors.white,
                              size: 18,
                            ),
                            title: Text(
                              'Automatic at sunset',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: !(currentTheme == themeMode.darkMode)
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () {
                      Share.share(
                          '🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। लाईव  नोटिफिकेशन 🔔 सहित। देखें 📺 लाईव टीवी समाचार। सुनें 📻 रेडियो-एफएम, बॉलीवुड गाने 🎧, गजल, भजन। अभी डाउनलोड करें 👇🇮🇳 https://bit.ly/3EmX8nY');
                    },
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.share,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.blue[900]
                              : Colors.white),
                      title: Text(
                        "ऐप शेयर करें",
                        style: TextStyle(
                            fontSize: 18,
                            color: !(currentTheme == themeMode.darkMode)
                                ? Colors.blue[900]
                                : Colors.white),
                      ),
                    ),
                  ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () {},
                    child: ListTile(
                      onTap: () {
                        try {
                          launch("market://details?id=" + 'com.newsbank.app');
                        } on PlatformException catch (_) {
                          launch(
                              "https://play.google.com/store/apps/details?id=" +
                                  'com.newsbank.app');
                        } finally {
                          launch(
                              "https://play.google.com/store/apps/details?id=" +
                                  'com.newsbank.app');
                        }
                      },
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.download,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.blue[900]
                              : Colors.white),
                      title: Text(
                        "ऐप अपडेट करें",
                        style: TextStyle(
                            fontSize: 18,
                            color: !(currentTheme == themeMode.darkMode)
                                ? Colors.blue[900]
                                : Colors.white),
                      ),
                    ),
                  ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () {
                      try {
                        launch("market://details?id=" + 'com.newsbank.app');
                      } on PlatformException catch (_) {
                        launch(
                            "https://play.google.com/store/apps/details?id=" +
                                'com.newsbank.app');
                      } finally {
                        launch(
                            "https://play.google.com/store/apps/details?id=" +
                                'com.newsbank.app');
                      }
                      // _launchURL(
                      //     'https://play.google.com/store/apps/details?id=com.newsbank.app');
                    },
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.star,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.blue[900]
                              : Colors.white),
                      title: Text(
                        "रेटिंग दें",
                        style: TextStyle(
                            fontSize: 18,
                            color: !(currentTheme == themeMode.darkMode)
                                ? Colors.blue[900]
                                : Colors.white),
                      ),
                    ),
                  ),
                  // !(currentTheme == themeMode.darkMode)
                  //     ? Divider(
                  //         thickness: 1,
                  //       )
                  //     : Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //             height: 1.0,
                  //             width: MediaQuery.of(context).size.width * 1,
                  //             color: !(currentTheme == themeMode.darkMode)
                  //                 ? Colors.blue[900]!
                  //                 : Colors.white),
                  //       ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RadioScreen()));
                    },
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.radio,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.blue[900]
                              : Colors.white),
                      title: Text(
                        "रेडियो",
                        style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LiveTVScreen()));
                    },
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.tv,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.blue[900]
                              : Colors.white),
                      title: Text(
                        "लाइव टीवी",
                        style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                  // !(currentTheme == themeMode.darkMode)
                  //     ? Divider(
                  //         thickness: 1,
                  //       )
                  //     : Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //           height: 1.0,
                  //           width: MediaQuery.of(context).size.width * 1,
                  //           color: !(currentTheme == themeMode.darkMode)
                  //               ? Colors.black
                  //               : Colors.white,
                  //         ),
                  //       ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () async {
                      // getgallary().then((value) {
                      //   setState(() {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             News_Gallery(_scrollController)),
                      //   );
                      // });
                      // });

                      final result = await getgallary(context);

                      if (result) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                News_Gallery(_scrollController),
                          ),
                        );
                      } else {
                        Toast.show(
                          "आपका इंटरनेट बंद है |",
                        );
                      }
                    },
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.image_not_supported_outlined,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.blue[900]
                              : Colors.white),
                      title: Text(
                        "न्यूज गैलरी",
                        style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FormScreen()),
                      );
                    },
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.feedback_rounded,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.blue[900]
                              : Colors.white),
                      title: Text(
                        "अपना फीडबैक/सुझाव साझा करें",
                        style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                  // !(currentTheme == themeMode.darkMode)
                  //     ? Divider(
                  //         thickness: 1,
                  //       )
                  //     : Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //             height: 1.0,
                  //             width: MediaQuery.of(context).size.width * 1,
                  //             color: !(currentTheme == themeMode.darkMode)
                  //                 ? Colors.blue[900]!
                  //                 : Colors.white),
                  //       ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () async {
                      var body;
                      var response = await http.get(Uri.parse(
                          'http://5.161.78.72/api/get_basic_page?bid=1'));
                      if (response.statusCode == 200) {
                        var jsonData = jsonDecode(response.body);
                        body = jsonData['body'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NiyamShartein(text: body)),
                        );
                      }
                    },
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.rule_folder,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.blue[900]
                              : Colors.white),
                      title: Text(
                        "नियम और शर्तें",
                        style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () async {
                      var body;
                      var response = await http.get(Uri.parse(
                          'http://5.161.78.72/api/get_basic_page?bid=2'));
                      if (response.statusCode == 200) {
                        var jsonData = jsonDecode(response.body);
                        body = jsonData['body'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HumareBareMe(text: body)),
                        );
                      }
                    },
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.info,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.blue[900]
                              : Colors.white),
                      title: Text(
                        "हमारे बारे में",
                        style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                  // Theme(
                  // data: Theme.of(context)
                  //     .copyWith(dividerColor: Colors.transparent),
                  // child:
                  // HorizontalDivider(),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: ExpansionTile(
                  //     // collapsedBackgroundColor: Color(0xff67b7d1),

                  //     leading: Icon(
                  //       Icons.notification_important,
                  //       color: !(currentTheme == themeMode.darkMode)
                  //           ? Colors.blue[900]
                  //           : Colors.white,
                  //     ),
                  //     title: Text(
                  //       "नोटिफिकेशन सेटिंग्स",
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         color: Colors.blue[900],
                  //       ),
                  //     ),
                  //     trailing: Icon(
                  //       Icons.keyboard_arrow_down,
                  //       size: 22,
                  //       color: !(currentTheme == themeMode.darkMode)
                  //           ? Colors.black
                  //           : Colors.white,
                  //     ),
                  //     children: [
                  //       TextButton(
                  //         onPressed: () {},
                  //         child: ListTile(
                  //           visualDensity:
                  //               VisualDensity(horizontal: 0, vertical: -4),
                  //           dense: true,
                  //           leading: Icon(
                  //             !(currentTheme == themeMode.darkMode)
                  //                 ? Icons.circle_rounded
                  //                 : Icons.circle_outlined,
                  //             color: !(currentTheme == themeMode.darkMode)
                  //                 ? Colors.blue[900]
                  //                 : Colors.white,
                  //             size: 18,
                  //           ),
                  //           contentPadding: EdgeInsets.only(left: 20),
                  //           title: Text(
                  //             'Allow Notifications',
                  //             style: TextStyle(
                  //                 fontSize: 18,
                  //                 color: !(currentTheme == themeMode.darkMode)
                  //                     ? Colors.blue[900]
                  //                     : Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //       TextButton(
                  //         onPressed: () {},
                  //         child: ListTile(
                  //           visualDensity:
                  //               VisualDensity(horizontal: 0, vertical: -4),
                  //           dense: true,
                  //           contentPadding: EdgeInsets.only(left: 20),
                  //           leading: Icon(
                  //             !(currentTheme == themeMode.darkMode)
                  //                 ? Icons.circle_outlined
                  //                 : Icons.circle_rounded,
                  //             color: !(currentTheme == themeMode.darkMode)
                  //                 ? Colors.black
                  //                 : Colors.white,
                  //             size: 18,
                  //           ),
                  //           title: Text(
                  //             'Off Notifications 6 pm to 7 am',
                  //             style: TextStyle(
                  //                 fontSize: 15,
                  //                 color: !(currentTheme == themeMode.darkMode)
                  //                     ? Colors.black
                  //                     : Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //       TextButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             Navigator.pushAndRemoveUntil(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) => HomeScreen()),
                  //                 (route) => false);
                  //           });
                  //         },
                  //         child: ListTile(
                  //           visualDensity:
                  //               VisualDensity(horizontal: 0, vertical: -4),
                  //           dense: true,
                  //           contentPadding: EdgeInsets.only(left: 20),
                  //           leading: Icon(
                  //             Icons.circle_outlined,
                  //             color: !(currentTheme == themeMode.darkMode)
                  //                 ? Colors.black
                  //                 : Colors.white,
                  //             size: 18,
                  //           ),
                  //           title: Text(
                  //             'Sounds',
                  //             style: TextStyle(
                  //                 fontSize: 15,
                  //                 color: !(currentTheme == themeMode.darkMode)
                  //                     ? Colors.black
                  //                     : Colors.white),
                  //           ),
                  //           onTap: () {},
                  //         ),
                  //       ),
                  //       TextButton(
                  //         onPressed: () {
                  //           Navigator.pushAndRemoveUntil(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => HomeScreen()),
                  //               (route) => false);
                  //         },
                  //         child: ListTile(
                  //           visualDensity:
                  //               VisualDensity(horizontal: 0, vertical: -4),
                  //           dense: true,
                  //           contentPadding: EdgeInsets.only(left: 20),
                  //           leading: Icon(
                  //             Icons.circle_outlined,
                  //             color: !(currentTheme == themeMode.darkMode)
                  //                 ? Colors.black
                  //                 : Colors.white,
                  //             size: 18,
                  //           ),
                  //           title: Text(
                  //             'Vibration',
                  //             style: TextStyle(
                  //                 fontSize: 15,
                  //                 color: !(currentTheme == themeMode.darkMode)
                  //                     ? Colors.black
                  //                     : Colors.white),
                  //           ),
                  //           onTap: () {},
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // ),
                  // !(currentTheme == themeMode.darkMode)
                  //     ? Divider(
                  //         thickness: 1,
                  //       )
                  //     : Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //             height: 1.0,
                  //             width: MediaQuery.of(context).size.width * 1,
                  //             color: !(currentTheme == themeMode.darkMode)
                  //                 ? Colors.blue[900]!
                  //                 : Colors.white),
                  //       ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () {
                      getstate().then((value) {
                        setState(() {
                          if (s.length == 0) {
                            s.add("अपना राज्य चुनें");
                            for (int i = 0; i < c; i++) {
                              s.add(getallState[i]["title"].toString());
                            }
                          }
                          print(s.length);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StatesScreen(s)));
                          // MyApps(s)),(route) => false);
                        });
                      });
                    },
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.share,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.blue[900]
                              : Colors.white),
                      title: Text(
                        "अपना राज्य बदलें",
                        style: TextStyle(
                            fontSize: 18,
                            color: !(currentTheme == themeMode.darkMode)
                                ? Colors.blue[900]
                                : Colors.white),
                      ),
                    ),
                  ),
                  HorizontalDivider(),
                  TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 20),
                      leading: Icon(Icons.exit_to_app, color: Colors.blue[900]),
                      title: Text(
                        "न्यूज बैंक से बाहर निकलें",
                        style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                      ),
                    ),
                  ),
                  // ListTile(
                  //   visualDensity: VisualDensity(horizontal: 2, vertical: -4),
                  //   dense: true,
                  //   onTap: () {},
                  //   contentPadding: EdgeInsets.only(left: 100),
                  //   title: Text(
                  //     "Powered By:",
                  //     style: TextStyle(fontSize: 15, color: Colors.red),
                  //   ),
                  // ),
                  // ListTile(
                  //   visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  //   dense: true,
                  //   onTap: () {},
                  //   contentPadding: EdgeInsets.only(left: 50),
                  //   title: Text(
                  //     "Independent News Group",
                  //     style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          int _tabIndex =
              Provider.of<HomePageIndexProvider>(context, listen: false)
                  .tabIndex;
          if (_scaffoldKey.currentState != null &&
              _scaffoldKey.currentState?.isDrawerOpen == true) {
            _scaffoldKey.currentState!.closeDrawer();
          }
          if (_tabIndex == 0 &&
              _scaffoldKey.currentState?.isDrawerOpen == false) {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(AppTextDataCollection.appTitleText),
                  content: const Text(AppTextDataCollection.alertText,
                      style: TextStyle(fontSize: 20)),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    TextButton(
                      onPressed: () {
                        ratingAppFunctionality();
                        Navigator.pop(context, true);
                      },
                      child: const Text(AppTextDataCollection.appRatingText),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        AppTextDataCollection.alertNoText,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(AppTextDataCollection.alertYesText),
                    ),
                  ],
                );
              },
            );
            return shouldPop!;
          } else {
            Provider.of<HomePageIndexProvider>(context).changeTabIndex(0);
            return false;
          }
        },
        child: Consumer<HomePageIndexProvider>(
          builder: (context, provider, child) {
            return _pages[provider.tabIndex];
          },
        ),
      ),
    );
  }

  _bottomNavigationBarItem(
      {required String iconSrc,
      required String label,
      required int tabIndex,
      required Function() onTap}) {
    // final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    // final themeMode = ThemeModeTypes();
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5, top: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(iconSrc,
                scale: 23,
                color:
                    Provider.of<HomePageIndexProvider>(context, listen: false)
                                .tabIndex ==
                            tabIndex
                        ? Colors.blue[900]
                        : Colors.black),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                label,
                style: TextStyle(
                    fontWeight: Provider.of<HomePageIndexProvider>(context,
                                    listen: false)
                                .tabIndex ==
                            tabIndex
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: Provider.of<HomePageIndexProvider>(context,
                                    listen: false)
                                .tabIndex ==
                            tabIndex
                        ? Colors.blue[900]
                        : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getPageData({@required String? cpId}) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://5.161.78.72/api/home_top_bar_news_of_category?cp_id=$cpId&page=1'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      print(" from homescreen 2100");
      return data["data"];
    } else {
      print(response.reasonPhrase);
    }
  }

  getProperImage(img) {
    if (img == "") return AssetImage("images/icon.png");
    return CachedNetworkImageProvider(img);
  }

// _launchURL(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

  Widget HorizontalDivider() {
    return Divider(
      color: Colors.grey.withOpacity(0.5),
    );
  }
}
