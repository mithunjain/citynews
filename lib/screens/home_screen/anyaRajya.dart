import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news/provider/apna_ragya_provider.dart';
import 'package:news/provider/homePageIndex_provider.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/screens/home_screen/home_screen.dart';
import 'package:news/screens/news_details/html_news.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/news_details_container.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

int stChangeApnaRajya = 1;
var homeNewsDataApnaRajya = {};

class AnyaRajya extends StatefulWidget {
  void getInfoAboutRajya() {
    // _AnyaRajyaState().getInfo();
  }

  @override
  _AnyaRajyaState createState() => _AnyaRajyaState();
}

class _AnyaRajyaState extends State<AnyaRajya> with TickerProviderStateMixin {
  late TabController tabController;
  int stid = 0;
  List homeNewsDataList = [];
  bool isLoading = true;
  int skip = 0;
  List ragyaName = [];
  List ragyaId = [];
  // bool moreDataLoading = false;
  Widget buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 55.0, top: 10),
      child: new Opacity(
        opacity: isLoading ? 1.0 : 00,
        child: new CircularProgressIndicator(),
      ),
    );
  }

  // Future<Map> getHomeNews(String hi) async {
  //   //Get from cache
  //   String fileName = 'getHomeNews$hi.json';
  //   var dir = await getTemporaryDirectory();
  //   File file = File(dir.path + "/" + fileName);
  //
  //   if (file.existsSync() && stChangeApnaRajya==0) {
  //     //   if (!file.existsSync()) {
  //     if (homeNewsDataApnaRajya.length==0) {
  //       print('this was ran part 1');
  //       final url =
  //           "http://5.161.78.72/api/home_latest_news?take=25&st_id=$hi&page=1";
  //       print("get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
  //       final req = await http.get(Uri.parse(url));
  //       final body = req.body;
  //       file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //       final res = jsonDecode(body) as List;
  //       homeNewsDataApnaRajya = res[0] as Map;
  //     }
  //
  //     else
  //       {
  //         // final url =
  //         //     "http://5.161.78.72/api/home_latest_news?take=25&st_id=$hi&page=1";
  //         // print("get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
  //         // final req = await http.get(Uri.parse(url));
  //         // final body = req.body;
  //         // file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //         // final res = jsonDecode(body) as List;
  //         // homeNewsDataApnaRajya = res[0] as Map;
  //         final data = file.readAsStringSync();
  //         final res = jsonDecode(data).toList();
  //         // print('the number is $hi and data is $res');
  //         homeNewsDataApnaRajya = res[0] as Map;
  //       }
  //   }
  //   //
  //   else {
  //     print('this was ran');
  //     final url =
  //         "http://5.161.78.72/api/home_latest_news?take=25&st_id=$hi&skip=$skip";
  //     final req = await http.get(Uri.parse(url));
  //     final body = req.body;
  //     file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //     final res = jsonDecode(body) as List;
  //     homeNewsDataApnaRajya = res[0] as Map;
  //   }
  //
  //     // }
  //
  //     // else {
  //     //   final url =
  //     //       "http://5.161.78.72/api/home_latest_news?take=45&st_id=$hi&page=$page";
  //     //
  //     //   final req = await http.get(Uri.parse(url));
  //     //
  //     //   if (req.statusCode == 200) {
  //     //     final body = req.body;
  //     //     final res = jsonDecode(body) as List;
  //     //     homeNewsData = res[0] as Map;
  //     //   } else {
  //     //     print('error in recieving data anyarajya ');
  //     //   }
  //     // }
  //   // }
  //   return homeNewsDataApnaRajya;
  // }

  int page = 1;

  @override
  void initState() {
    // ragyaName.clear();
    // ragyaId.clear();
    getInfo();
    super.initState();
    stid = HomeScreen.stId;
    // tabController = new TabController(length: numberOfStates-1, vsync: this);
    // tabController.addListener(() {});
  }

  ScrollController topbarCoontrollerMs = new ScrollController();

  // Future<List> getMoreData(String hi, int page) async {
  //   print("get more data");
  //   String fileName = 'getHomeNews$hi.json';
  //   var dir = await getTemporaryDirectory();
  //   File file = File(dir.path + "/" + fileName);
  //   try {
  //     final result = await InternetAddress.lookup('www.google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       if (!isLoading) {
  //         setState(() {
  //           isLoading = true;
  //         });
  //         print("printing page $page");
  //         var request = http.Request(
  //             'GET',
  //             Uri.parse(
  //                 "http://5.161.78.72/api/home_latest_news?take=$page&st_id=$hi"));
  //
  //         http.StreamedResponse response = await request.send();
  //         if (response.statusCode == 200) {
  //           final body = await response.stream.bytesToString();
  //
  //           final res = jsonDecode(body);
  //
  //           homeNewsData.add(res[0] as Map);
  //           file.writeAsStringSync(jsonEncode(homeNewsData),
  //               flush: true, mode: FileMode.write);
  //           isLoading = false;
  //
  //           return homeNewsData;
  //         }
  //         return homeNewsData;
  //       }
  //     }
  //   } on SocketException catch (_) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return [];
  //   }
  //   return homeNewsData;
  // }

  int done = 0;
  Future<void> getInfo() async {
    isLoading = true;
    try {
      final url = "http://5.161.78.72/api/get_state";
      print(
          "get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
      final req = await http.get(Uri.parse(url));
      final body = req.body;

      List<dynamic> stateList = jsonDecode(body); // Decoding the JSON response

      // Clear old data to avoid duplication if this function is called multiple times
      ragyaName.clear();
      ragyaId.clear();

      // Extracting data and filling up the lists
      for (var state in stateList) {
        ragyaId.add(state['sid']);
        ragyaName.add(state['title']);
      }

      log('state id list ====>$ragyaId');
      log('state name list ====>$ragyaName');
    } on SocketException catch (_) {
      print("No internet connection.");
    } catch (e) {
      print("Error occurred: $e");
    } finally {
      isLoading = false;
      setState(() {}); // Notify listeners about the state change
    }
  }
//   Future<void> getInfo() async {
//     // printing all states except current

//     String fileName = 'getStateNames.json';
//     var dir = await getTemporaryDirectory();
//     File file = File(dir.path + "/" + fileName);
//     var stateList = [];
// // 1 changed
// // 0 state not changed
//     if (file.existsSync() && stChange == 0) {
//       final body = file.readAsStringSync();
//       final res = jsonDecode(body);
//       if (res.length != 0) {
//         setState(() {
//           stateList = res;
//         });
//       }
//     } else {
//       try {
//         if (stChangeApnaRajya == 1) {
//           final url = "http://5.161.78.72/api/get_state";
//           print(
//               "get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
//           final req = await http.get(Uri.parse(url));
//           final body = req.body;
//           file.writeAsStringSync(body, flush: true, mode: FileMode.write);
//           stateList = jsonDecode(body);
//           stChangeApnaRajya = 0;
//           // fetching from web
//         } else {
//           if (file.existsSync()) {
//             // is there or not
//             final body = file.readAsStringSync();
//             final res = jsonDecode(body);
//             if (res.length == 0) {
//               final url = "http://5.161.78.72/api/get_state";
//               print(
//                   "get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
//               final req = await http.get(Uri.parse(url));
//               final body = req.body;
//               file.writeAsStringSync(body, flush: true, mode: FileMode.write);
//               stateList = jsonDecode(body);
//               stChangeApnaRajya = 0;
//             } else {
//               stateList = res;
//             }
//           } else {
//             stateList = [];
//             // no data
//           }
//         }
//       } on SocketException catch (_) {
//         final body = file.readAsStringSync();
//         final res = jsonDecode(body);
//         if (res.length == 0)
//           stateList = [];
//         else
//           stateList = res;
//       }
//     }

//     // if (file.existsSync() && stChangeApnaRajya == 0) {
//     //   final body = file.readAsStringSync();
//     //   res = jsonDecode(body);
//     // } else {
//     //   final url = "http://5.161.78.72/api/get_state";
//     //   print(
//     //       "get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
//     //   final req = await http.get(Uri.parse(url));
//     //   final body = req.body;
//     //   file.writeAsStringSync(body, flush: true, mode: FileMode.write);
//     //   res = jsonDecode(body);
//     // }
//     log('state length==>$numberOfStates');
//     log('state list==>$stateList');
//     for (int i = 1; i <= numberOfStates; i++) {
//       if (stid != stateList[i]['sid']) {
//         ragyaName.add(stateList[i]['title']);
//       }

//       if (stid != stateList[i]['sid']) {
//         ragyaId.add(stateList[i]['sid']);
//       }

//       print('all ragya id are $ragyaId');
//     }

//     setState(() {});

//     // if (homeNewsDataList.length<=8) {
//     //   for (int i = 1; i <= numberOfStates; i++) {
//     //     // print('values of i are $i');
//     //     if (i!= stid) {
//     //       String statesId = i.toString();
//     //       await getHomeNews(statesId).then((value){
//     //         homeNewsDataList.add(value);
//     //         // print('number is $i and data is \n $value');
//     //       });
//     //       // if (page == 1) {
//     //       // }
//     //       // else {
//     //       //   // String statesId = i.toString();
//     //       //   // getHomeNews(statesId).then((value) {
//     //       //   //   for (var item in value['news'])
//     //       //   //     homeNewsDataList[j]['news'].add(item);
//     //       //   // });
//     //       //   // j++;
//     //       //   // return homeNewsDataList;
//     //       // }
//     //     }
//     //   }
//     // }
//     // stChangeApnaRajya=0;
//     // print('elements are $homeNewsDataList');
//     // page++;
//     // setState(() {});
//   }

  @override
  void dispose() {
    topbarCoontrollerMs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("State ID from anya rajya $stid");
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;

    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    return WillPopScope(
      onWillPop: () async {
        // Provider.of<HomePageIndexProvider>(context, listen: false)
        //     .changeTabIndex(0);
        // return true;
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
      },
      child: Container(
          color: !(currentTheme == themeMode.darkMode)
              ? Colors.white
              : Colors.black,
          child: ragyaId.length == 0
              ? Container()
              : ListView(
                  children: [
                    // TabBar(
                    //   onTap: (index)
                    //   {
                    //     setState(() {
                    //       pageController.animateToPage(index,duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
                    //     });
                    //   },
                    //   unselectedLabelColor: Colors.blue[900]!,
                    //   labelColor: Colors.orange[900]!,
                    //   controller: tabController,
                    //   isScrollable: true,
                    //   automaticIndicatorColorAdjustment: true,
                    //   tabs: [
                    //     for (int i = 0; i < numberOfStates-1; i++)
                    //       Tab(
                    //         text: homeNewsDataList[i]['category']["title"],
                    //       ),
                    //   ],
                    // ),
                    ///pageview
                    Container(
                        width: width,
                        height: height,
                        child: ragyaId.length == 0
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(bottom: 125),
                                child: PageView.builder(
                                  itemCount: ragyaId.length,
                                  controller:
                                      Provider.of<ApnaRagyaIndexProvider>(
                                              context)
                                          .pagecontroller,
                                  onPageChanged: (value) {
                                    if (Provider.of<ApnaRagyaIndexProvider>(
                                                context,
                                                listen: false)
                                            .pageIndex <
                                        value) {
                                      if (topbarCoontrollerMs.hasClients) {
                                        topbarCoontrollerMs.animateTo(
                                            topbarCoontrollerMs.offset +
                                                width * 0.2,
                                            duration: Duration(seconds: 1),
                                            curve: Curves.linear);
                                      }
                                    } else if (Provider.of<
                                                    ApnaRagyaIndexProvider>(
                                                context,
                                                listen: false)
                                            .pageIndex >
                                        value) {
                                      if (topbarCoontrollerMs.hasClients) {
                                        topbarCoontrollerMs.animateTo(
                                            topbarCoontrollerMs.offset +
                                                width * 0.2,
                                            duration: Duration(seconds: 1),
                                            curve: Curves.linear);
                                      }
                                    }

                                    Provider.of<ApnaRagyaIndexProvider>(context,
                                            listen: false)
                                        .onlychangeIndex(value);
                                  },
                                  itemBuilder: (context, pageIndex) {
                                    log('pageIndex=>$pageIndex');
                                    return Ragya(id: ragyaId[pageIndex]);
                                  },
                                ),
                              )),
                  ],
                )),
    );
  }
}

class Ragya extends StatefulWidget {
  final int id;

  Ragya({required this.id});

  @override
  _RagyaState createState() => _RagyaState();
}

class _RagyaState extends State<Ragya> {
  var homeNewsDataList = [];
  bool isLoading = false;
  ScrollController _scrollControllerRajya = ScrollController();
  late int page;
  bool moreDataLoading = false;
  bool isscrollDown = false;

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

  // void showBottombar() {
  //   showNavBarValue.value = true;
  // }

  // void hideBottombar() {
  //   showNavBarValue.value = false;
  // }

  // Future<void> getInfo() async {
  //   log('State id==>${widget.id}');
  //   setState(() {
  //     page = 1;
  //   });
  //   String fileName = 'getHomeNews${widget.id}.json';
  //   var dir = await getTemporaryDirectory();
  //   File file = File(dir.path + "/" + fileName);

  //   if (file.existsSync()) {
  //     print("reading from cache");
  //     DataManagement.getStoredData('anyarajya');
  //     log("anya rajya cache.....");
  //     final data = file.readAsStringSync();
  //     final res = jsonDecode(data);
  //     setState(() {
  //       homeNewsDataList = res;
  //       //   // catData.addAll(res);
  //     });
  //     // print('this is homedata $homeNewsDataList');
  //     // print(res);
  //   }

  //   try {
  //     final result = await InternetAddress.lookup('www.google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print("interet");
  //       if (!isLoading) {
  //         setState(() {
  //           isLoading = true;
  //         });
  //         // print(index);
  //         var request = http.Request(
  //             'GET',
  //             Uri.parse(
  //                 'http://5.161.78.72/api/home_latest_news?take=20&st_id=${widget.id}&page=1'));

  //         http.StreamedResponse response = await request.send();
  //         if (response.statusCode == 200) {
  //           final body = await response.stream.bytesToString();
  //           log('new details respone==>$body');
  //           final res = jsonDecode(body);
  //           DataManagement.storeData('anyarajya', res);
  //           homeNewsDataList = res[0]['news'];
  //           // print(index);
  //           file.writeAsStringSync(jsonEncode(homeNewsDataList),
  //               flush: true, mode: FileMode.write);
  //           setState(() {
  //             // homeNewsDataList.clear();

  //             isLoading = false;
  //             page++;
  //           });
  //         } else {}
  //       }
  //     } else
  //       setState(() {});
  //   } on SocketException catch (_) {
  //     setState(() {
  //       isLoading = false;
  //       Toast.show(
  //         "आपका इंटरनेट बंद है |",
  //       );
  //     });
  //   }
  // }

  Future<void> getInfo() async {
    isLoading = true;
    if (mounted) setState(() {});

    try {
      var response = await http.get(Uri.parse(
          'http://5.161.78.72/api/home_latest_news?take=20&st_id=${widget.id}&page=1'));
      if (response.statusCode == 200) {
        var body = await response.body;
        log('new details response==>$body');
        final res = jsonDecode(body);
        if (mounted) {
          setState(() {
            homeNewsDataList = res[0]['news'];
            isLoading = false;
            page++;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Future<void> getMoreData() async {
  //   String fileName = 'getHomeNews${widget.id}.json';
  //   var dir = await getTemporaryDirectory();
  //   File file = File(dir.path + "/" + fileName);

  //   try {
  //     setState(() {
  //       moreDataLoading = true;
  //     });

  //     final result = await InternetAddress.lookup('www.google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       if (!isLoading) {
  //         setState(() {
  //           isLoading = true;
  //         });
  //         // print(index);
  //         var request = http.Request(
  //             'GET',
  //             Uri.parse(
  //                 'http://5.161.78.72/api/home_latest_news?take=20&st_id=${widget.id}&skip=$page'));
  //         http.StreamedResponse response = await request.send();
  //         if (response.statusCode == 200) {
  //           final body = await response.stream.bytesToString();
  //           final res = jsonDecode(body);
  //           DataManagement.storeData('anyarajya', res);
  //           setState(() {
  //             homeNewsDataList.addAll(res[0]['news']);
  //             file.writeAsStringSync(jsonEncode(homeNewsDataList),
  //                 flush: true, mode: FileMode.write);
  //             isLoading = false;
  //             moreDataLoading = false;
  //             page++;
  //           });
  //         } else {}
  //       }
  //     }
  //   } on SocketException catch (_) {
  //     setState(() {
  //       isLoading = false;
  //       moreDataLoading = false;
  //       Toast.show(
  //         "आपका इंटरनेट बंद है |",
  //       );
  //     });
  //   }
  // }
  Future<void> getMoreData() async {
    isLoading = true;
    moreDataLoading = true;
    if (mounted) setState(() {});

    try {
      var response = await http.get(Uri.parse(
          'http://5.161.78.72/api/home_latest_news?take=20&st_id=${widget.id}&skip=$page'));
      if (response.statusCode == 200) {
        var body = await response.body;
        final res = jsonDecode(body);
        if (mounted) {
          setState(() {
            homeNewsDataList.addAll(res[0]['news']);
            isLoading = false;
            moreDataLoading = false;
            page++;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            moreDataLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          moreDataLoading = false;
        });
      }
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 55.0, top: 10),
      child: new Opacity(
        opacity: isLoading ? 1.0 : 00,
        child: new LinearProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    // myScroll();
    page = 1;
    _scrollControllerRajya.addListener(_scrollListener);
    getInfo();
    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerRajya.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_scrollControllerRajya.hasClients)
      return; // Ensure the controller is attached
    final maxScroll = _scrollControllerRajya.position.maxScrollExtent;
    final currentScroll = _scrollControllerRajya.position.pixels;
    if (currentScroll >= maxScroll) {
      getMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;

    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    return homeNewsDataList == null
        ? Center(
            child: Container(),
          )
        : RefreshIndicator(
            onRefresh: () async {
              await getInfo();
              setState(() {});
            },
            child: Column(
              children: [
                isLoading ? LinearProgressIndicator() : SizedBox(),
                isLoading
                    ? SizedBox.shrink()
                    : moreDataLoading
                        ? LinearProgressIndicator()
                        : SizedBox(),
                Expanded(
                  child: ListView.separated(
                    controller: _scrollControllerRajya,
                    itemCount: homeNewsDataList.length,
                    itemBuilder: (context, int index) {
                      return index == homeNewsDataList.length
                          ? _buildProgressIndicator()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: GestureDetector(
                                  onTap: () {
                                    if (homeNewsDataList[index]
                                            ["is_open_in_web_view"] ==
                                        0) {
                                      final dataNews = {
                                        "newsTitle": homeNewsDataList[index]
                                            ["title"],
                                        "newsURL": homeNewsDataList[index]
                                            ["imported_news_url"],
                                        "data": homeNewsDataList[index],
                                      };
                                      Get.to(WebviewScreen(),
                                              arguments: dataNews)!
                                          .then(
                                        (val) async {
                                          final fileName = "readNews.json";
                                          var dir =
                                              await getTemporaryDirectory();
                                          File file =
                                              File(dir.path + "/" + fileName);
                                          setState(
                                            () {
                                              readNews.add(
                                                  homeNewsDataList[index]
                                                      ["title"]);
                                              file.writeAsStringSync(
                                                  jsonEncode(readNews),
                                                  flush: true,
                                                  mode: FileMode.write);
                                            },
                                          );
                                        },
                                      );
                                    }
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => WebviewScreen(
                                    //               newsTitle: homeNewsDataList[index]
                                    //                   ["title"],
                                    //               newsURL: homeNewsDataList[index]
                                    //                   ["imported_news_url"],
                                    //               data: homeNewsDataList[index],
                                    //             ))).then((val) async {
                                    //   final fileName = "readNews.json";
                                    //   var dir = await getTemporaryDirectory();
                                    //   File file = File(dir.path + "/" + fileName);
                                    //   setState(() {
                                    //     readNews
                                    //         .add(homeNewsDataList[index]["title"]);
                                    //     file.writeAsStringSync(jsonEncode(readNews),
                                    //         flush: true, mode: FileMode.write);
                                    //   });
                                    // });
                                    else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HTMLNews(
                                                    newsUrl: homeNewsDataList[
                                                            index]
                                                        ["imported_news_url"],
                                                    news_image:
                                                        homeNewsDataList[index]
                                                            ["main_image"],
                                                    newsSource:
                                                        homeNewsDataList[index]
                                                            ["source_website"],
                                                    newsTime:
                                                        homeNewsDataList[index]
                                                            ["publish_date"],
                                                    newsTitle:
                                                        homeNewsDataList[index]
                                                            ["title"],
                                                    htmlData:
                                                        homeNewsDataList[index]
                                                            ["title"],
                                                  ))).then((val) async {
                                        final fileName = "readNews.json";
                                        var dir = await getTemporaryDirectory();
                                        File file =
                                            File(dir.path + "/" + fileName);
                                        setState(() {
                                          readNews.add(
                                              homeNewsDataList[index]["title"]);
                                          file.writeAsStringSync(
                                              jsonEncode(readNews),
                                              flush: true,
                                              mode: FileMode.write);
                                        });
                                      });
                                    }
                                  },
                                  child: NewsDetailsContainer(
                                    newsData: homeNewsDataList[index],
                                  )),
                            );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Colors.grey.withOpacity(0.7),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
