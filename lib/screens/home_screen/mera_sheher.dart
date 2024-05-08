import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:news/dynamic_link.dart';
import 'package:news/provider/apna_sheher_provider.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/screens/home_screen/apna_sheher.dart';
import 'package:http/http.dart' as http;
import 'package:news/screens/home_screen/home_screen.dart';
import 'package:news/screens/news_details/html_news.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/services/data_management.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/bottombar_index_changing_provider.dart';

class MeraSheher extends StatefulWidget {

  MeraSheher();

  @override
  _MeraSheherState createState() => _MeraSheherState();
}

class _MeraSheherState extends State<MeraSheher> with TickerProviderStateMixin {
  Future<void> getDistrictData() async {
    String fileName = 'district_added.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);

    List<dynamic> res;
    if (file.existsSync() == true && stateChangeForMeraSheher == 0) {
      print('it has some data');
      final data = file.readAsStringSync();
      res = jsonDecode(data);
      addedDistrict = res;
      print(res);
    } else {}
    setState(() {
      print('this is $addedDistrict');
    });
  }

  var topbarCoontrollerMs = new ScrollController();
  int topBarIndex = 0;
  ScrollController _scrollController = ScrollController();

  changePage(int newPageIndex) {
    Provider.of<ApnaSheherIndexProvider>(context, listen: false)
        .changePage(newPageIndex);
  }

  @override
  void initState() {
    getDistrictData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;

    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        return true;
        // return await showDialog(
        //   context: context,
        //   builder: (context) => new AlertDialog(
        //     title: Text('News Bank',
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
        //                     launch("market://details?id=" + 'com.newsbank.app');
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
      child: Container(
        color:
            !(currentTheme == themeMode.darkMode) ? Colors.white : Colors.black,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    height: height * 0.05,
                    child: ListView.builder(
                        itemCount: addedDistrict.length,
                        controller: topbarCoontrollerMs,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: () {
                              changePage(index);
                            },
                            child: Container(
                              color: !(currentTheme == themeMode.darkMode)
                                  ? Colors.white
                                  : Colors.black,
                              height: height * 0.05,
                              width: width * 0.17,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: heading(
                                    text: addedDistrict[index]['title']
                                        .toString(),
                                    color: Provider.of<ApnaSheherIndexProvider>(
                                                    context)
                                                .pageIndex ==
                                            index
                                        ? Colors.orange
                                        : Colors.blue,
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
                                    color: Provider.of<ApnaSheherIndexProvider>(
                                                    context)
                                                .pageIndex ==
                                            index
                                        ? Colors.blue
                                        : Colors.white,

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
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                          //
                        }),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0,
                    child: GestureDetector(
                      onTap: () async {
                        //
                        tempDistrict.clear();
                        for (final item in addedDistrict) {
                          tempDistrict.add(item);
                        }
                        final info = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApnaSheher()));
                        updateinfo() {}
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                              )
                            ],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'शहर ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                'जोड़ें',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            addedDistrict.length == 0
                ? Container()
                : Expanded(
                    child: PageView.builder(
                        onPageChanged: (value) {
                          if (Provider.of<ApnaSheherIndexProvider>(context,
                                      listen: false)
                                  .pageIndex <
                              value) {
                            topbarCoontrollerMs.animateTo(
                                topbarCoontrollerMs.offset + width * 0.2,
                                duration: Duration(seconds: 1),
                                curve: Curves.linear);
                          } else if (Provider.of<ApnaSheherIndexProvider>(
                                      context,
                                      listen: false)
                                  .pageIndex >
                              value) {
                            topbarCoontrollerMs.animateTo(
                                topbarCoontrollerMs.offset - width * 0.2,
                                duration: Duration(seconds: 1),
                                curve: Curves.linear);
                          }

                          Provider.of<ApnaSheherIndexProvider>(context,
                                  listen: false)
                              .onlychangeIndex(value);
                          // setState(() {
                          //   topBarIndex = value == 0 ? value : value - 1;
                          // });
                        },
                        controller:
                            Provider.of<ApnaSheherIndexProvider>(context)
                                .pagecontroller,
                        itemCount: addedDistrict.length,
                        itemBuilder: (context, pageIndex) {
                          return TopBarMeraSheher(
                            did: addedDistrict[pageIndex]['did'].toString(),
                          );
                        }),
                  )
          ],
        ),
      ),
    );
  }
}

class TopBarMeraSheher extends StatefulWidget {
  final String did;

  TopBarMeraSheher({required this.did});

  @override
  _TopBarMeraSheherState createState() => _TopBarMeraSheherState();
}

class _TopBarMeraSheherState extends State<TopBarMeraSheher> {
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

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 55.0, top: 10),
      child: new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }

  var meraSheherData = [];
  late int page;

  // PageController pageController=PageController();
  var did;
  bool isLoading = false;
  bool moreDataLoading = false;
  ScrollController _scrollController = ScrollController();

  Future<void> getMoreData() async {
    print("get more data");
    String fileName = 'districtData${widget.did.toString()}.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    try {
      setState(() {
        moreDataLoading = true;
      });
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          // print(index);
          var request = http.Request(
              'GET',
              Uri.parse(
                  'http://5.161.78.72/api/get_latest_news_by_district?page=$page&did=$did'));
          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            final body = await response.stream.bytesToString();
            final res = jsonDecode(body);
            DataManagement.storeData('merashehar', res);
            if (mounted) {
              setState(() {
                //print("Get more info data: ${res['news']['data']}");
                meraSheherData.addAll(res['news']['data']);
                file.writeAsStringSync(jsonEncode(meraSheherData),
                    flush: true, mode: FileMode.write);
                moreDataLoading = false;
                isLoading = false;
                page++;
              });
            }
          } else {}
        }
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        moreDataLoading = false;
        Toast.show(
          "आपका इंटरनेट बंद है |",
        );
      });
    }
  }

  Future<void> getInfo() async {
    if (mounted) {
      setState(() {
        page = 1;
      });
    }

    print("get data");
    did = widget.did;
    String fileName = 'districtData${widget.did.toString()}.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    if (file.existsSync()) {
      DataManagement.getStoredData('merashehar');
      print("reading from cache");

      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      setState(() {
        meraSheherData = res;
        // catData.addAll(res);
      });
    }

    try {
      final result = await InternetAddress.lookup('www.google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("interet");
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          // print(index);
          var request = http.Request(
              'GET',
              Uri.parse(
                  'http://5.161.78.72/api/get_latest_news_by_district?page=$page&did=$did'));

          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            final body = await response.stream.bytesToString();
            final res = jsonDecode(body);

            //print("previous data: ${meraSheherData}");
            DataManagement.storeData('merashehar', res);
            meraSheherData.clear();
            meraSheherData = res['news']['data'];

            //print("new data: ${res['news']['data']}");
            file.writeAsStringSync(jsonEncode(meraSheherData),
                flush: true, mode: FileMode.write);

            if (mounted) {
              setState(() {
                isLoading = false;
                page++;
              });
            }
          } else {}
        }
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        Toast.show(
          "आपका इंटरनेट बंद है |",
        );
      });
    }

    //   print('this is $did');
    //   final url =
    //       "http://5.161.78.72/api/get_latest_news_by_district?page=1&did=$did";
    //   print("mera sheher news running");
    //   final req = await http.get(Uri.parse(url));
    //   final body = req.body;
    //   final res = jsonDecode(body);
    //   meraSheherData=res['news']['data'];
    // print(meraSheherData);
    // return meraSheherData;
  }

  @override
  void initState() {
    // myScroll();
    getInfo().then((value) => () {
          setState(() {});
        });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels.toInt() >=
              _scrollController.position.maxScrollExtent.toInt() - 400
          // /
          //         1.100000000000000001 &&
          // _scrollController.position.pixels <=
          //     _scrollController.position.maxScrollExtent
          ) {
        getMoreData();
      }
      if (_scrollController.position.pixels.toInt() >=
          _scrollController.position.maxScrollExtent.toInt()) {
        LinearProgressIndicator();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;

    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    return meraSheherData == null
        ? LinearProgressIndicator()
        : RefreshIndicator(
            onRefresh: () async {
              await getInfo();
              await getMoreData();
            },
            child: Column(
              children: [
                moreDataLoading ? LinearProgressIndicator() : SizedBox(),
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: meraSheherData.length,
                      itemBuilder: (context, index) {
                        return index == meraSheherData.length
                            ? _buildProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    if (meraSheherData[index]
                                            ["is_open_in_web_view"] ==
                                        0) {
                                      final dataNews = {
                                        "newsTitle": meraSheherData[index]
                                            ["title"],
                                        "newsURL": meraSheherData[index]
                                            ["imported_news_url"],
                                        "data": meraSheherData[index],
                                      };
                                      Get.to(WebviewScreen(),
                                              arguments: dataNews)!
                                          .then((val) async {
                                        final fileName = "readNews.json";
                                        var dir = await getTemporaryDirectory();
                                        File file =
                                            File(dir.path + "/" + fileName);
                                        setState(() {
                                          readNews.add(
                                              meraSheherData[index]["title"]);
                                          file.writeAsStringSync(
                                              jsonEncode(readNews),
                                              flush: true,
                                              mode: FileMode.write);
                                        });
                                      });
                                      ;
                                    }

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => WebviewScreen(
                                    //               newsTitle: meraSheherData[index]
                                    //                   ["title"],
                                    //               newsURL: meraSheherData[index]
                                    //                   ["imported_news_url"],
                                    //               data: meraSheherData[index],
                                    //             ))).then((val) async {
                                    //   final fileName = "readNews.json";
                                    //   var dir = await getTemporaryDirectory();
                                    //   File file = File(dir.path + "/" + fileName);
                                    //   setState(() {
                                    //     readNews.add(meraSheherData[index]["title"]);
                                    //     file.writeAsStringSync(jsonEncode(readNews),
                                    //         flush: true, mode: FileMode.write);
                                    //   });
                                    // });
                                    else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HTMLNews(
                                            newsUrl: meraSheherData[index]
                                                ["imported_news_url"],
                                            news_image: meraSheherData[index]
                                                ["main_image"],
                                            newsSource: meraSheherData[index]
                                                ["source_website"],
                                            newsTime: meraSheherData[index]
                                                ["publish_date"],
                                            newsTitle: meraSheherData[index]
                                                ["title"],
                                            htmlData: meraSheherData[index]
                                                ["title"],
                                          ),
                                        ),
                                      ).then((val) async {
                                        final fileName = "readNews.json";
                                        var dir = await getTemporaryDirectory();
                                        File file =
                                            File(dir.path + "/" + fileName);
                                        setState(() {
                                          readNews.add(
                                              meraSheherData[index]["title"]);
                                          file.writeAsStringSync(
                                              jsonEncode(readNews),
                                              flush: true,
                                              mode: FileMode.write);
                                        });
                                      });
                                    }
                                  },
                                  child: index == 0
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: !(currentTheme ==
                                                      themeMode.darkMode)
                                                  ? Colors.green[50]
                                                  : Colors.white10,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(3, 3),
                                                    color: Colors.black12,
                                                    spreadRadius: 0.05)
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              children: [
                                                meraSheherData[index][
                                                            "main_image_thumb"] ==
                                                        null
                                                    ? SizedBox()
                                                    : Container(
                                                        height: height * 0.25,
                                                        width: width,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                                  image:
                                                                      CachedNetworkImageProvider(
                                                                    meraSheherData[
                                                                            index]
                                                                        [
                                                                        "main_image_thumb"],
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                      ),
                                                // : Container(
                                                //     height: height * 0.25,
                                                //     width: width,
                                                //     decoration: BoxDecoration(
                                                //         image: DecorationImage(
                                                //             image: NetworkImage(
                                                //                 meraSheherData[index][
                                                //                         "main_image_thumb"] ??
                                                //                     "https://i.stack.imgur.com/y9DpT.jpg"),
                                                //             fit: BoxFit.cover)),
                                                //   ),
                                                SizedBox(width: 10),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      readNews.contains(
                                                              meraSheherData[
                                                                      index]
                                                                  ["title"])
                                                          ? AutoSizeText(
                                                              meraSheherData[
                                                                      index]
                                                                  ["title"],
                                                              // widget.cpId.toString(),
                                                              textScaleFactor:
                                                                  1.0,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: !(currentTheme ==
                                                                        themeMode
                                                                            .darkMode)
                                                                    ? Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .5)
                                                                    : Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            .5),
                                                              ),
                                                              maxLines: 2,
                                                              minFontSize: 16,
                                                              maxFontSize: 30,
                                                            )
                                                          : AutoSizeText(
                                                              meraSheherData[
                                                                      index]
                                                                  ["title"],
                                                              // widget.cpId.toString(),
                                                              textScaleFactor:
                                                                  1.0,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: !(currentTheme ==
                                                                        themeMode
                                                                            .darkMode)
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                              ),
                                                              maxLines: 2,
                                                              minFontSize: 16,
                                                              maxFontSize: 30,
                                                            ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              heading(
                                                                  text: meraSheherData[
                                                                          index]
                                                                      [
                                                                      "source_website"],
                                                                  scale: 0.9,
                                                                  color: !(currentTheme ==
                                                                          themeMode
                                                                              .darkMode)
                                                                      ? Colors
                                                                          .black54
                                                                      : Colors
                                                                          .white,
                                                                  weight:
                                                                      FontWeight
                                                                          .w300),
                                                              heading(
                                                                text: " | ",
                                                                color: !(currentTheme ==
                                                                        themeMode
                                                                            .darkMode)
                                                                    ? Colors
                                                                        .black54
                                                                    : Colors
                                                                        .white,
                                                              ),
                                                              heading(
                                                                  text: meraSheherData[
                                                                          index]
                                                                      [
                                                                      "imported_date"],
                                                                  color: Colors
                                                                      .blue,
                                                                  scale: 0.9)
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          GestureDetector(
                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            Padding(
                                                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                              child: SingleChildScrollView(
                                                                                child: Container(
                                                                                  color: (currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                                                                  height: 200,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            meraSheherData[index]["title"],
                                                                                            style: TextStyle(color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white, fontSize: 19),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: TextButton(
                                                                                          onPressed: () async {
                                                                                            final dataNews = {
                                                                                              "newsTitle": meraSheherData[index]["title"],
                                                                                              "newsURL": meraSheherData[index]["imported_news_url"],
                                                                                              "data": meraSheherData[index]
                                                                                            };
                                                                                            String url = '';
                                                                                            await generateUrl(dataNews).then((value) => {
                                                                                                  url = value,
                                                                                                });
                                                                                            print('it\'s shared');
                                                                                            final title = "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" + Uri.parse(url).toString();
                                                                                            FlutterShare.share(title: "Title", text: title);
                                                                                            //        FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳");
                                                                                            // FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳                                            " + meraSheherData[index]["title"], chooserTitle: "इस खबर को शेयर करो...");
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Padding(
                                                                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                                  child: Icon(
                                                                                                    Icons.share,
                                                                                                    size: 25,
                                                                                                    color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                                                                                  )),
                                                                                              Text(
                                                                                                'शेयर करें',
                                                                                                style: TextStyle(color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white, fontSize: 18),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: TextButton(
                                                                                          onPressed: () {
                                                                                            bool alreadyThere = false;
                                                                                            for (var k = 0; k < list.items.length; k++) {
                                                                                              if (meraSheherData[index]["post_id"].toString() == list.items[k].id) {
                                                                                                alreadyThere = true;
                                                                                              }
                                                                                            }
                                                                                            print(meraSheherData[index]["post_id"]);
                                                                                            if (alreadyThere == false) {
                                                                                              final item = Favourite(id: meraSheherData[index]["post_id"].toString(), data: meraSheherData[index]);
                                                                                              print('2');
                                                                                              list.items.add(item);
                                                                                              storage.setItem('favourite_news', list.toJSONEncodable());
                                                                                            }
                                                                                            print('it\'s bookmarked');
                                                                                            Navigator.pop(context);
                                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                                              SnackBar(
                                                                                                  content: Text(
                                                                                                    'बुकमार्क सुरक्षित हो गया',
                                                                                                    style: TextStyle(
                                                                                                      fontSize: 17,
                                                                                                      color: Colors.white,
                                                                                                    ),
                                                                                                  ),
                                                                                                  action: SnackBarAction(
                                                                                                    onPressed: () {},
                                                                                                    label: 'Close',
                                                                                                    textColor: Colors.white,
                                                                                                  ),
                                                                                                  duration: Duration(seconds: 3)),
                                                                                            );
                                                                                          },
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Padding(
                                                                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                                  child: Icon(
                                                                                                    Icons.bookmark,
                                                                                                    size: 25,
                                                                                                    color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                                                                                  )),
                                                                                              Text(
                                                                                                'बुकमार्क करेंं',
                                                                                                style: TextStyle(color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white, fontSize: 18),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ));
                                                              },
                                                              child: Icon(
                                                                Icons.share,
                                                                size: 15,
                                                                color: !(currentTheme ==
                                                                        themeMode
                                                                            .darkMode)
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .white,
                                                              )),
                                                          SizedBox(width: 10)
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              color: !(currentTheme ==
                                                      themeMode.darkMode)
                                                  ? Colors.green[50]
                                                  : Colors.white10,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(3, 3),
                                                    color: Colors.black12,
                                                    spreadRadius: 0.05)
                                              ]),
                                          child: Row(
                                            children: [
                                              meraSheherData[index][
                                                          "main_image_thumb"] ==
                                                      null
                                                  ? SizedBox()
                                                  : Container(
                                                      height: height * 0.18,
                                                      width: width * 0.4,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: CachedNetworkImageProvider(
                                                                  meraSheherData[
                                                                          index]
                                                                      [
                                                                      "main_image_thumb"]),
                                                              fit: BoxFit
                                                                  .cover)),
                                                      // DecorationImage(
                                                      //     image: NetworkImage(meraSheherData
                                                      //     [
                                                      //     index]
                                                      //     [
                                                      //     "main_image_thumb"] ??
                                                      //         "https://i.stack.imgur.com/y9DpT.jpg"),
                                                      //     fit: BoxFit
                                                      //         .cover)),
                                                    ),
                                              SizedBox(width: 2),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      readNews.contains(
                                                              meraSheherData[
                                                                      index]
                                                                  ['title'])
                                                          ? AutoSizeText(
                                                              meraSheherData[
                                                                      index]
                                                                  ["title"],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: !(currentTheme ==
                                                                        themeMode
                                                                            .darkMode)
                                                                    ? Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .5)
                                                                    : Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            .5),
                                                              ),
                                                              textScaleFactor:
                                                                  1.0,
                                                              maxLines: 3,
                                                              minFontSize: 15,
                                                              maxFontSize: 29,
                                                            )
                                                          : AutoSizeText(
                                                              meraSheherData[
                                                                      index]
                                                                  ["title"],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: !(currentTheme ==
                                                                        themeMode
                                                                            .darkMode)
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                              ),
                                                              textScaleFactor:
                                                                  1.0,
                                                              maxLines: 3,
                                                              minFontSize: 15,
                                                              maxFontSize: 29,
                                                            ),
                                                      Flexible(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  new Container(
                                                                      padding: new EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              13.0),
                                                                      child:
                                                                          RichText(
                                                                        textScaleFactor:
                                                                            1.0,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        text:
                                                                            TextSpan(
                                                                          text: meraSheherData[index]
                                                                              [
                                                                              "source_website"],
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color: !(currentTheme == themeMode.darkMode)
                                                                                ? Colors.black54
                                                                                : Colors.white,
                                                                          ),
                                                                          children: <TextSpan>[
                                                                            TextSpan(
                                                                                text: ' | ',
                                                                                style: TextStyle(color: !(currentTheme == themeMode.darkMode) ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                                                                            TextSpan(
                                                                                text: meraSheherData[index]["imported_date"].toString(),
                                                                                style: TextStyle(color: Colors.blue))
                                                                          ],
                                                                        ),
                                                                      )),
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              Padding(
                                                                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                                child: SingleChildScrollView(
                                                                                  child: Container(
                                                                                    color: (currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                                                                    height: 200,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              meraSheherData[index]["title"],
                                                                                              style: TextStyle(color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white, fontSize: 19),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: TextButton(
                                                                                            onPressed: () async {
                                                                                              final tempMap = meraSheherData[index];

                                                                                              tempMap['main_image_cropped'] = '';

                                                                                              final dataNews = {
                                                                                                "newsTitle": meraSheherData[index]["title"],
                                                                                                "newsURL": meraSheherData[index]["imported_news_url"],
                                                                                                "data": tempMap
                                                                                              };
                                                                                              String url = '';
                                                                                              await generateUrl(dataNews).then((value) => {
                                                                                                    url = value,
                                                                                                  });
                                                                                              print('it\'s shared');
                                                                                              final title = "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" + Uri.parse(url).toString();
                                                                                              FlutterShare.share(title: "Title", text: title);
                                                                                              //       FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳");
                                                                                              // FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳                                            " + meraSheherData[index]["title"], chooserTitle: "इस खबर को शेयर करो...");
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Padding(
                                                                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                                    child: Icon(
                                                                                                      Icons.share,
                                                                                                      size: 25,
                                                                                                      color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                                                                                    )),
                                                                                                Text(
                                                                                                  'शेयर करें',
                                                                                                  style: TextStyle(color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white, fontSize: 18),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: TextButton(
                                                                                            onPressed: () {
                                                                                              bool alreadyThere = false;
                                                                                              for (var k = 0; k < list.items.length; k++) {
                                                                                                if (meraSheherData[index]["post_id"].toString() == list.items[k].id) {
                                                                                                  alreadyThere = true;
                                                                                                }
                                                                                              }
                                                                                              print(meraSheherData[index]["post_id"]);
                                                                                              if (alreadyThere == false) {
                                                                                                final item = Favourite(id: meraSheherData[index]["post_id"].toString(), data: meraSheherData[index]);
                                                                                                print('2');
                                                                                                list.items.add(item);
                                                                                                storage.setItem('favourite_news', list.toJSONEncodable());
                                                                                              }
                                                                                              print('it\'s bookmarked');
                                                                                              Navigator.pop(context);
                                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                                SnackBar(
                                                                                                    content: Text(
                                                                                                      'बुकमार्क सुरक्षित हो गया',
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 17,
                                                                                                        color: Colors.white,
                                                                                                      ),
                                                                                                    ),
                                                                                                    action: SnackBarAction(
                                                                                                      onPressed: () {},
                                                                                                      label: 'Close',
                                                                                                      textColor: Colors.white,
                                                                                                    ),
                                                                                                    duration: Duration(seconds: 3)),
                                                                                              );
                                                                                            },
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Padding(
                                                                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                                    child: Icon(
                                                                                                      Icons.bookmark,
                                                                                                      size: 25,
                                                                                                      color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                                                                                    )),
                                                                                                Text(
                                                                                                  'बुकमार्क करेंं',
                                                                                                  style: TextStyle(color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white, fontSize: 18),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ));
                                                                },
                                                                child: Icon(
                                                                  Icons.share,
                                                                  size: 15,
                                                                  color: !(currentTheme ==
                                                                          themeMode
                                                                              .darkMode)
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                                )),
                                                            SizedBox(width: 10)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                ),
                              );
                      }),
                ),
              ],
            ),
          );
  }
}
