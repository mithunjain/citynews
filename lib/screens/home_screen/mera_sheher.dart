import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news/provider/apna_sheher_provider.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/screens/home_screen/apna_sheher.dart';
import 'package:http/http.dart' as http;
import 'package:news/screens/home_screen/home_screen.dart';
import 'package:news/services/data_management.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/news_details_container.dart';
import 'package:news/widgets/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:toast/toast.dart';

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
  void dispose() {
    topbarCoontrollerMs.dispose();
    super.dispose();
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
            Container(
              color: Colors.blue[900],
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: height * 0.05,
                      color: Colors.blue[900],
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
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                        child: heading(
                                      text: addedDistrict[index]['title']
                                          .toString(),
                                      color:
                                          Provider.of<ApnaSheherIndexProvider>(
                                                          context)
                                                      .pageIndex ==
                                                  index
                                              ? Colors.white
                                              : Colors.grey,
                                    )),
                                    Container(
                                      height: 2,
                                      width: 30,
                                      color:
                                          Provider.of<ApnaSheherIndexProvider>(
                                                          context)
                                                      .pageIndex ==
                                                  index
                                              ? Colors.orange
                                              : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            );
                            //
                          }),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        //
                        tempDistrict.clear();
                        for (final item in addedDistrict) {
                          tempDistrict.add(item);
                        }
                         bool updateNeeded = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApnaSheher()));
                        if (updateNeeded) {
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
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
                ],
              ),
            ),
            addedDistrict.length == 0
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'कृपिया करके अपना शहर सेलेक्ट करे',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )
                : Expanded(child:  PageView.builder(
                          onPageChanged: (value) {
                            if (Provider.of<ApnaSheherIndexProvider>(context,
                                        listen: false)
                                    .pageIndex <
                                value) {
                              topbarCoontrollerMs!.animateTo(
                                  topbarCoontrollerMs!.offset + width * 0.2,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.linear);
                            } else if (Provider.of<ApnaSheherIndexProvider>(
                                        context,
                                        listen: false)
                                    .pageIndex >
                                value) {
                              topbarCoontrollerMs!.animateTo(
                                  topbarCoontrollerMs!.offset - width * 0.2,
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
                          controller:Provider.of<ApnaSheherIndexProvider>(context).pagecontroller,
                          itemCount: addedDistrict.length,
                          itemBuilder: (context, pageIndex) {
                            return TopBarMeraSheher(
                              did: addedDistrict[pageIndex]['did'].toString(),
                            );
                          })
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: meraSheherData.length,
                    itemBuilder: (context, index) {
                      return index == meraSheherData.length
                          ? _buildProgressIndicator()
                          : NewsDetailsContainer(
                              newsData: meraSheherData[index]);
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
