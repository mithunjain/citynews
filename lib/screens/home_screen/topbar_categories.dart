// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/screens/home_screen/ads/add_helper.dart';
import 'package:news/screens/news_details/html_news.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/services/data_management.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/news_details_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import 'package:share/share.dart';
import 'package:toast/toast.dart';

class TopBarCategory extends StatefulWidget {
  int cpId;

  TopBarCategory( {required this.cpId});

  

  @override
  _TopBarCategoryState createState() => _TopBarCategoryState();
}

class _TopBarCategoryState extends State<TopBarCategory> {
  static int page = 1;
  ScrollController _scrollController = ScrollController();
  PageController _controller = PageController(
    initialPage: 0,
  );
  bool moreDataLoading = false;
  late NativeAd _ad;
  bool _isAdLoaded = false;

  //ScrollController _sc = new ScrollController();
  bool isLoading = false;
  int selectedIndex = 0;
  List catData = [];
  bool isscrollDown = false;

  int _newsCounter1 = 2;
  int _newsCounter2 = 11;

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

  Future<dynamic> getData(int index) async {
    if (!mounted) return;
    setState(() {
      index = 1;
      page = 1;
    });
    print("get data");
    String fileName = 'getTopBarCategoryData${widget.cpId.toString()}_13.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);
    if (!mounted) return;

    if (file.existsSync()) {
      print("reading from cache");

      final data = file.readAsStringSync();
      final res = jsonDecode(data);

      if (!mounted) return;

      setState(() {
        catData.clear();
        isLoading = false;
        catData.addAll(res);
      });
    }

    try {
      final result = await InternetAddress.lookup('www.google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("internet from topbar categories");
        if (!mounted) return;

        // if (!isLoading) {
        print(widget.cpId);
        var request = http.Request(
          'GET',
          Uri.parse(
            'http://5.161.78.72/api/home_top_bar_news_of_category?take=20&cp_id=${widget.cpId}&page=${page.toString()}',
          ),
        );

        http.StreamedResponse response = await request.send();
        print("status code " + response.statusCode.toString());
        if (response.statusCode == 200) {
          final body = await response.stream.bytesToString();
          final res = jsonDecode(body);
          DataManagement.storeData('topbarcategories', res);
          print("before setState");
          if (!mounted) return;

          setState(() {
            catData.clear();
            catData.addAll(res["data"]);
            print(index);
            print(catData);
            file.writeAsStringSync(jsonEncode(catData),
                flush: true, mode: FileMode.write);

            isLoading = false;
            page++;
          });
        } else {}
        // }
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        Toast.show(
          "आपका इंटरनेट बंद है |",
        );
      });
    } catch (e) {
      print(e);
    }
    print("after catch");
  }

  Future<void> getMoreData(int index) async {
    print("get more data");
    String fileName = 'getTopBarCategoryData${widget.cpId.toString()}_13.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    try {
      setState(() {
        moreDataLoading = true;
      });

      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!mounted) return;

        // if (!isLoading) {
        // setState(() {
        //   isLoading = true;
        // });
        print(index);
        var request = http.Request(
            'GET',
            Uri.parse(
                'http://5.161.78.72/api/home_top_bar_news_of_category?cp_id=${widget.cpId}&page=${page.toString()}'));

        http.StreamedResponse response = await request.send();

        // final body = await response.stream.bytesToString();
        // log('This is body $body');
        if (response.statusCode == 200) {
          final body = await response.stream.bytesToString();
          if (!mounted) return;

          final res = jsonDecode(body);
          if (!mounted) return;

          setState(() {
            catData.addAll(res["data"]);
            file.writeAsStringSync(jsonEncode(catData),
                flush: true, mode: FileMode.write);

            isLoading = false;
            moreDataLoading = false;
            page++;
          });
        } else {}
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        moreDataLoading = false;
        Toast.show(
          "आपका इंटरनेट बंद है |",
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 55.0, top: 10),
      child: Opacity(
        opacity: isLoading ? 1.0 : 00,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    isLoading = true;
    print("init state in topbar categories");
    print("cpid is " + widget.cpId.toString());
    // myScroll();
    super.initState();

    _ad = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: 'listTile',
      request: AdRequest(),
      nativeAdOptions:
          NativeAdOptions(mediaAspectRatio: MediaAspectRatio.landscape),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    // _ad.load();

    getData(page).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    _controller.addListener(() {
      setState(() {
        selectedIndex = _controller.page!.toInt();
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels.toInt() >=
              _scrollController.position.maxScrollExtent.toInt() - 400
          // /
          //         1.100000000000000001 &&
          // _scrollController.position.pixels <=
          //     _scrollController.position.maxScrollExtent
          ) {
        getMoreData(page);
      }
      if (_scrollController.position.pixels.toInt() >=
          _scrollController.position.maxScrollExtent.toInt()) {
        LinearProgressIndicator();
      }
    });

    // widget.scrollController.addListener(
    //   () {
    //     if (widget.scrollController.position.pixels >
    //             widget.scrollController.position.maxScrollExtent /
    //                 1.100000000000000001 &&
    //         widget.scrollController.position.pixels <=
    //             widget.scrollController.position.maxScrollExtent) {
    //       getMoreData(page);
    //     }
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;

    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          isLoading = true;
        });
        getData(page);
      },
      child: Column(
        children: [
          isLoading ? LinearProgressIndicator() : SizedBox(),
          moreDataLoading ? LinearProgressIndicator() : SizedBox(),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: catData.length,
              controller: _scrollController,
              itemBuilder: (context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                  child: GestureDetector(
                    onTap: () {
                      if (catData[index]["is_open_in_web_view"] == 0) {
                        final dataNews = {
                          "newsTitle": catData[index]["title"],
                          "newsURL": catData[index]["imported_news_url"],
                          "data": catData[index],
                        };
                        Get.to(WebviewScreen(), arguments: dataNews)!
                            .then((val) async {
                          final fileName = "readNews.json";
                          var dir = await getTemporaryDirectory();
                          File file = File(dir.path + "/" + fileName);
                          setState(() {
                            readNews.add(catData[index]["title"]);
                            file.writeAsStringSync(jsonEncode(readNews),
                                flush: true, mode: FileMode.write);
                          });
                        });
                      }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => WebviewScreen(
                      //       newsTitle: catData[index]["title"],
                      //       newsURL: catData[index]["imported_news_url"],
                      //       data: catData[index],
                      //     ),
                      //   ),
                      // ).then((val) async {
                      //   final fileName = "readNews.json";
                      //   var dir = await getTemporaryDirectory();
                      //   File file = File(dir.path + "/" + fileName);
                      //   setState(() {
                      //     readNews.add(catData[index]["title"]);
                      //     file.writeAsStringSync(jsonEncode(readNews),
                      //         flush: true, mode: FileMode.write);
                      //   });
                      // });
                      else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HTMLNews(
                              newsUrl: catData[index]["imported_news_url"],
                              news_image: catData[index]["main_image"],
                              newsSource: catData[index]["source_website"],
                              newsTime: catData[index]["imported_date"],
                              newsTitle: catData[index]["title"],
                              htmlData: catData[index]["body"],
                            ),
                          ),
                        ).then((c) async {
                          final fileName = "readNews.json";
                          var dir = await getTemporaryDirectory();
                          File file = File(dir.path + "/" + fileName);
                          setState(() {
                            readNews.add(catData[index]["title"]);
                            file.writeAsStringSync(jsonEncode(readNews),
                                flush: true, mode: FileMode.write);
                          });
                        });
                      }
                    },
                    child: SizedBox(
                      // height: _newsCounter1 == index ? 160 : 80, // for ads space
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          NewsDetailsContainer(
                            newsData: catData[index],
                          ),
                          if (_newsCounter1 == index && _isAdLoaded)
                            Container(
                              child: AdWidget(ad: _ad),
                              height: 80,
                              alignment: Alignment.center,
                            ),
                        ],
                      ),
                    ),
                  ),
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
