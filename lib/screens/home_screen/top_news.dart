// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:news/dynamic_link.dart';
import 'package:news/provider/sheher_change_provider.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/news_details_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news/provider/string.dart';
import 'package:news/screens/news_details/html_news.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/widgets/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../services/data_management.dart';
import 'from_home_mera_sheher.dart';

// import 'package:api_cache_manager/api_cache_manager.dart';
var homeNewsData = [];

class TopNews extends StatefulWidget {
  TopNews();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _TopNewsState createState() => _TopNewsState();
}

class _TopNewsState extends State<TopNews>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late AnimationController _resizableController;
  // Map custom_Ad = {};
  // Map native_Ad = {};
  // bool adsAvailable = true;
// Future<dynamic> getAds() async {
//     var request = http.Request('GET', Uri.parse('http://5.161.78.72/api/get_custom_ad'));
//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       var responseString = await response.stream.bytesToString();

//       print(responseString);
//     var  decode = jsonDecode(responseString);
//     getallads=decode;
//       print(getallads.length.toString());
// print("state");
//     } else {

//       var responseString = await response.stream.bytesToString();

//       print(responseString);
//     }
//   }

  static Color colorVariation(int note) => Colors.blue.withOpacity(note / 10);

  AnimatedBuilder getContainer(height, currentTheme, themeMode) {
    print("Here" + _resizableController.value.toString());
    return AnimatedBuilder(
      builder: (BuildContext context, Widget? child) {
        return Container(
          //   margin: const EdgeInsets.all(8),
          //  padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: colorVariation((_resizableController.value * 10).round()),
              width: 5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              heading(
                  text: "अपना शहर बदले",
                  color: !(currentTheme == themeMode.darkMode)
                      ? Colors.black
                      : Colors.white,
                  scale: 1,
                  weight: FontWeight.w800),
              // Icon(Icons.edit,
              //     color: !(currentTheme == themeMode.darkMode)
              //         ? Colors.black
              //         : Colors.white,
              //     size: height * 0.02),
            ],
          ),
        );
      },
      animation: _resizableController,
    );
  }

  var getallads;
  Future<dynamic> getAds() async {
    //Get from cache
    // 1 first time load
    // 0 cache may exist
    print("HEEEEELLLLLLLLLLLLL!!!!!!!!!");
    if (topBarNewsData.isNotEmpty) {
      print('scrolling did is $scrollingDid');
      String fileName = 'getAdNews$scrollingDid.json';
      var dir = await getTemporaryDirectory();

      File file = File(dir.path + "/" + fileName);
      if (!mounted) return;
      try {
        if (file.existsSync()) {
          print("HElloooooooo");
          if (!mounted) return;
          var data = jsonDecode(file.readAsStringSync());
          if (data.length != 0) {
            if (!mounted) return;
            setState(() {
              getallads = data;
            });
          }
        }
      } catch (_) {
        // Toast.show("Some error Occured", context);
      }
      try {
        // url fetch
        print("url fetching  fdfsdf");
        final url =
            "http://5.161.78.72/api/get_ad_of_district?take=5&did=$scrollingDid";
        final req = await http.get(Uri.parse(url));
        final body = req.body;
        print("HELLLLLLLLOOOOOOO222222");
        if (!mounted) return;
        final res = jsonDecode(body);
        file.writeAsStringSync(body, flush: true, mode: FileMode.write);

        print("res " + res.toString());
        print('100');
        firstTimeLoadAds = 0;
        if (!mounted) return;
        setState(() {
          getallads = res;
        });
      } catch (_) {
        print("ERRRRRRRRRRRRRRRR");
        // file exist and data is present then read from file
        if (file.existsSync()) {
          var data = jsonDecode(file.readAsStringSync());
          if (data.length != 0) {
            if (!mounted) return;
            setState(() {
              getallads = data;
            });
          } else {
            Fluttertoast.showToast(
              msg: "आपका इंटरनेट बंद है |",
            );
            if (!mounted) return;
            setState(() {
              getallads = null;
            });
          }
        }
        // else data is null
        else {
          Fluttertoast.showToast(
            msg: "आपका इंटरनेट बंद है |",
          );
          if (!mounted) return;
          setState(() {
            getallads = null;
          });
        }
      }
    }
  }

  // 1 means not loaded yet
// 0 means loaded atleast 1 time and cache may be empty
  Future<dynamic> getHomeNews() async {
    log('home news call ===>222222222222');
    String fileName = 'getHomeNews.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    if (file.existsSync()) {
      print("reading from cache");

      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      if (!mounted) return;
      setState(() {
        homeNewsData = res;
      });
    }
    print("reading from internet");
    final url = "http://5.161.78.72/api/home_latest_news?take=5&st_id=$hi";
    final req = await http.get(Uri.parse(url));

    if (req.statusCode == 200) {
      final body = req.body;

      file.writeAsStringSync(body, flush: true, mode: FileMode.write);
      final res = jsonDecode(body);
      if (!mounted) return;
      setState(() {
        homeNewsData = res;
      });
    } else {
      if (!mounted) return;
      setState(() {
        homeNewsData = jsonDecode(req.body);
      });
    }

    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        String fileName = 'getHomeNews.json';
        var dir = await getTemporaryDirectory();

        File file = File(dir.path + "/" + fileName);
        print("reading from internet");
        final url = "http://5.161.78.72/api/home_latest_news?take=5&st_id=$hi";
        final req = await http.get(Uri.parse(url));

        if (req.statusCode == 200) {
          log('statussss is 200--');
          final body = req.body;
          if (!mounted) return;
          file.writeAsStringSync(body, flush: true, mode: FileMode.write);
          final res = jsonDecode(body);
          if (!mounted) return;
          setState(() {
            sliding = true;
            homeNewsData = res;
          });
        } else {
          if (!mounted) return;
          setState(() {
            sliding = true;
            homeNewsData = jsonDecode(req.body);
          });
        }
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    // Toast.show("Fetching latest news", context);

    // // print("Runnninggg news fetch");
    // // if (flag == true) stChange = 1;
    // // print("printing home news data ${homeNewsData.length}");
    // // //Get from cache
    // // var res = [];
    // try {
    //   print("Getting home news after first time");
    //   String fileName = 'getHomeNews.json';
    //   var dir = await getTemporaryDirectory();
    //   File file = File(dir.path + "/" + fileName);
    //   final url =
    //       "http://5.161.78.72/api/home_latest_news?take=5&st_id=$hi";
    //   final req = await http.get(Uri.parse(url));

    //   if (req.statusCode == 200) {
    //     print("in status 200 home news");
    //     final body = req.body;
    //     final res = jsonDecode(body);
    //     try {
    //       await file.writeAsString(body, flush: true, mode: FileMode.write);
    //       print("FILE CREATED AND WRITTEN");
    //     } on Exception catch (e) {
    //       print("$e");
    //     }
    //     homeNewsData = res;
    //     stChange = 0;
    //   }
    // } on SocketException catch (_) {
    //   snapshot.connectionState = ConnectionState.waiting;
    // }
    // setState(() {
    //   stChange = 1;
    // });
    // return homeNewsData;
  }

  // Future<String> generateLink(data) async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: 'https://citynews.page.link',
  //     link: Uri.parse(
  //         'https://<your-domain-name>.page.link/start/?data=$data'), // <- your paramaters
  //     dynamicLinkParametersOptions: DynamicLinkParametersOptions(
  //         shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
  //     androidParameters: AndroidParameters(
  //       packageName: 'com.example.news',
  //       minimumVersion: 0,
  //     ),
  //     socialMetaTagParameters: SocialMetaTagParameters(
  //       title: "click the link",
  //     ),
  //   );
  //   final Uri dynamicUrl = await parameters.buildUrl();
  //   final ShortDynamicLink shortenedLink =
  //       await DynamicLinkParameters.shortenUrl(
  //     dynamicUrl,
  //     DynamicLinkParametersOptions(
  //         shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
  //   );
  //   final Uri shortUrl = shortenedLink.shortUrl;
  //   return "https://citynews.page.link" + shortUrl.path;
  // }

  String hi = "";
  int done = 0;

  Future<void> getInfo() async {
    print("called get info ");
    DataManagement.getStoredData('topnews');
    log('printing top news cache........');
    getTopBarNewsData().then((value) => () {
          print('new scrolling did is $scrollingDid');
        });

    getData().then((String value) {
      if (hi != value) {
        // stChange = 1;
        if (!mounted) return;
        setState(() {
          hi = value;
          getHomeNews();
          getAds();
        });
        print("state id = $value");
      }
    });
    // getHomeNews();
  }

  var scrollingDid;
  var topBarNewsData = [];
  String districtName = '';
  // = firstDistrictName;

  Future<void> getTopBarNewsData() async {
    // print('saddsa');
    // String fileName = 'district_scroll.json';
    // var dir = await getTemporaryDirectory();
    // File file = File(dir.path + "/" + fileName);
    // if(file.existsSync()) {
    //   var data = file.readAsStringSync();
    //   topBarNewsData = jsonDecode(data);
    //   setState(() {
    //     toShow=true;
    //   });
    //   print('error 100');
    // }
    //
    // else
    //   {
    //     final url =
    //         "http://5.161.78.72/api/get_latest_news_by_district?page=1&did=8";
    //     // print("get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
    //     final req = await http.get(Uri.parse(url));
    //     final body = req.body;
    //     file.writeAsStringSync(jsonEncode(body));
    //     topBarNewsData = jsonDecode(body);
    //     print('error 1 is $topBarNewsData');
    //     setState(() {
    //       toShow=true;
    //     });
    //     print('error 101');
    //   }
    if (stChange == 1) {
      apnadistict = "";
    }
    String fileName = 'district_scroll.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);
    try {
      if (file.existsSync()) {
        print("reading from cache top bar news");

        final data = file.readAsStringSync();
        final res = jsonDecode(data);
        if (!mounted) return;
        setState(() {
          scrollingDid = res['district']['did'];
          topBarNewsData = res["news"]["data"];
          districtName = res["district"]["title"];
        });
        if (apnadistict.length == 0) {
          if (!mounted) return;
          setState(() {
            apnadistict = districtName;
          });
        }
        print(apnadistict + " " + districtName);
        print(districtName + "   changed district");
        Provider.of<SheherChangeProvider>(context, listen: false)
            .updateSheher(res["district"]["title"].toString());
        // setState(() {
        //   print("Sliding" + sliding.toString());
        //   sliding = true;
        // });
        // print('this is $topBarNewsData');
      } else {
        if (!mounted) return;
        setState(() {
          topBarNewsData = [];
        });
      }
    } catch (_) {
      // Toast.show("Some Error occured", context);
    }
    try {
      var did = scrollingDid;
      final url =
          "http://5.161.78.72/api/get_latest_news_by_district?page=1&did=$did";
      // print("get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
      final req = await http.get(Uri.parse(url));
      final body = req.body;

      final res = jsonDecode(body);
      DataManagement.storeData('topnews', res);
      dir = await getTemporaryDirectory();
      file = File(dir.path + "/" + fileName);
      if (!mounted) return;
      setState(() {
        scrollingDid = res['district']['did'];
        topBarNewsData = res["news"]["data"];
        districtName = res["district"]["title"];
        apnadistict = districtName;
        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        topBarNewsData = topBarNewsData;
      });
    }
  }

  Future<dynamic> transparentDialogScreen(
      final img, mq, currentTheme, themeMode) async {
    print("dialog Clicked");
    return await showDialog(
      useSafeArea: true,
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Center(
          // Aligns the container to center
          child: Container(
            // A simplified version of dialog.
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: mq.width * 0.2),
                Column(
                  children: [
                    Expanded(
                      child: RotatedBox(
                        child: Image.network(
                          img,
                          fit: BoxFit.fill,
                        ),
                        quarterTurns: 3,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        //   height: mq.height * 0.05,
                        ),
                    IconButton(
                        color: Colors.red[600],
                        onPressed: () => {Navigator.pop(context)},
                        icon: Icon(
                          Icons.cancel,
                          size: 40,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ScrollController _yellowBannerController = ScrollController();
  ScrollController sc1 = ScrollController();
  bool completed = false;
  PageStorageKey<dynamic> pageNo = new PageStorageKey("0");

  List<Widget> yellowBanner(context, mq, currentTheme, themeMode) {
    List<Widget> bannerData = [];
    int count = 0;
    for (var data in topBarNewsData) {
      count++;
      if (count > 10) break;
      Widget innerData = Container(
        padding: const EdgeInsets.only(left: 8),
        // margin: const EdgeInsets.only(left: 5),
        child: InkWell(
          onTap: () {
            print(_yellowBannerController.position.activity!.isScrolling);
            print("Ad CLickedddddd");

            if (data["is_open_in_web_view"] == 0) {
              final dataNews = {
                "newsTitle": data["title"],
                "newsURL": data["imported_news_url"],
                "data": data,
              };
              Get.to(WebviewScreen(), arguments: dataNews);
            }

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => WebviewScreen(
            //       newsTitle: data["title"],
            //       newsURL: data["imported_news_url"],
            //       data: data,
            //     ),
            //   ),
            // );
            else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HTMLNews(
                    newsUrl: data["imported_news_url"],
                    news_image: data["main_image"],
                    newsSource: data["source_website"],
                    newsTime: data["publish_date"],
                    newsTitle: data["title"],
                    htmlData: data["title"],
                  ),
                ),
              );
            }
          },
          child: Container(
            width: mq.width * 0.5,
            decoration: BoxDecoration(
              // color: Colors.teal,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  data['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 0.9,
                  minFontSize: 17,
                  style: TextStyle(
                    color: !(currentTheme == themeMode.darkMode)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                // heading(
                //     text: topBarNewsData[index]["title"],
                //     align: TextAlign.left,
                //     scale: 0.9),
                SizedBox(height: 3),
                Row(
                  children: [
                    heading(
                        text: data["source_website"],
                        scale: 0.8,
                        color: !(currentTheme == themeMode.darkMode)
                            ? Colors.black38
                            : Colors.white),
                    heading(
                        text: " | ",
                        scale: 0.8,
                        color: !(currentTheme == themeMode.darkMode)
                            ? Colors.black38
                            : Colors.white54),
                    heading(
                        text: data["imported_date"],
                        scale: 0.8,
                        color: !(currentTheme == themeMode.darkMode)
                            ? Colors.blue
                            : Colors.blue)
                  ],
                )
              ],
            ),
          ),
        ),
      );
      bannerData.add(innerData);
    }
    return bannerData;
  }

  // CarouselController buttonCarouselController = CarouselController();
  @override
  void initState() {
    // myScroll();

    super.initState();
    navigate();
    _resizableController = new AnimationController(
      duration: new Duration(
        milliseconds: 1000,
      ),
      vsync: this,
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();

    // WidgetsBinding.instance?.addObserver(this);

    sliding = false;

    getInfo();
    loading = false;
    // sc1 = new ScrollController();
  }

  @override
  dispose() {
    _resizableController.dispose(); // you need this
    super.dispose();
  }

  var contaierwidth;
  var yellowBarIndex;
  // Future<void> initDynamicLink() async {
  //   print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
  //   // await Future.delayed(Duration(seconds: 3));
  //   // final data = await FirebaseDynamicLinks.instance.getInitialLink();

  //   // final deepLink = data.link;

  //   // print("PaTHHHHH" + deepLink.path);
  //   // final queryParams = deepLink.queryParameters;
  //   // // printing query parameter if exist
  //   print("INSIDEEEEEEE");
  //   FirebaseDynamicLinks.instance.onLink(onSuccess: (linkData) async {
  //     var deepLink = linkData.link;
  //     print(deepLink.path);
  //     final data = deepLink.queryParameters['data'] as Map;
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => SearchScreen()));
  //     debugPrint('DYnamic Links onLink $deepLink');
  //   }, onError: (e) async {
  //     debugPrint('DYnamic Links error $e');
  //   });
  // }
  void navigate() async {
    await initDynamicLink();
    //.then((data) {
    // print(":data" + data);
    // data = data as Map;
    // print("dddddddddddddddddddddddddddd" + data.toString());
    // });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    //AppLife
    print("STATE CHANGEEEEDDD" + state.toString());

    if (state == AppLifecycleState.resumed) {
      navigate();
    }
  }

  @override
  void didChangeDependencies() {
    print("Inside**************");

    print("IN INIT STATE AFTERRRRRRRRRRRRRRRRRRRRRRR");
    _yellowBannerController = new ScrollController();
    Timer.periodic(
        Duration(seconds: 1),
        (v) => {
              if (_yellowBannerController.hasClients)
                if (_yellowBannerController.offset ==
                    _yellowBannerController.initialScrollOffset)
                  {
                    print("intiitalllll"),
                    _yellowBannerController.animateTo(
                        _yellowBannerController.position.maxScrollExtent,
                        duration: Duration(seconds: 30),
                        curve: Curves.linear)
                  },
              if (_yellowBannerController.hasClients)
                if (_yellowBannerController.offset ==
                    _yellowBannerController.position.maxScrollExtent)
                  {
                    _yellowBannerController.animateTo(
                        _yellowBannerController.position.minScrollExtent,
                        duration: Duration(seconds: 30),
                        curve: Curves.linear)
                  },
              if (_yellowBannerController.hasClients)
                {
                  // print("clients"),
                  if (_yellowBannerController
                          .position.isScrollingNotifier.value ==
                      false)
                    {
                      contaierwidth =
                          _yellowBannerController.position.maxScrollExtent / 11,
                      yellowBarIndex =
                          _yellowBannerController.position.pixels ~/
                              contaierwidth,
                      // print(_yellowBannerController.positions.toString()),
                      // print(" one indexxx " + contaierwidth.toString()),
                      // print("Positionnnnnn " +
                      //     _yellowBannerController.offset.toString()),
                      // print("index " + yellowBarIndex.toString()),
                    }
                  else
                    {
                      // print("moving"),
                    },
                  _yellowBannerController.position.addListener(() {
                    if (_yellowBannerController.position.userScrollDirection ==
                        ScrollDirection.forward) {
                      double min =
                          _yellowBannerController.position.minScrollExtent;
                      double max =
                          _yellowBannerController.position.maxScrollExtent;
                      double total = max - min;
                      double timer = 30 / total;
                      double distance =
                          -_yellowBannerController.position.minScrollExtent +
                              _yellowBannerController.offset;
                      double time = timer * distance;
                      _yellowBannerController.animateTo(
                          _yellowBannerController.position.minScrollExtent,
                          duration: Duration(seconds: time.toInt()),
                          curve: Curves.linear);
                    }
                    if (_yellowBannerController.position.userScrollDirection ==
                        ScrollDirection.reverse) {
                      double min =
                          _yellowBannerController.position.minScrollExtent;
                      double max =
                          _yellowBannerController.position.maxScrollExtent;
                      double total = max - min;
                      double timer = 30 / total;
                      double distance =
                          _yellowBannerController.position.maxScrollExtent -
                              _yellowBannerController.offset;
                      double time = timer * distance;
                      _yellowBannerController.animateTo(
                          _yellowBannerController.position.maxScrollExtent,
                          duration: Duration(seconds: time.toInt()),
                          curve: Curves.linear);
                    }
                    if (_yellowBannerController.offset ==
                        _yellowBannerController.position.minScrollExtent) {
                      _yellowBannerController.animateTo(
                          _yellowBannerController.position.maxScrollExtent,
                          duration: Duration(seconds: 30),
                          curve: Curves.linear);
                    }
                    if (_yellowBannerController.offset ==
                        _yellowBannerController.position.maxScrollExtent) {
                      _yellowBannerController.animateTo(
                        _yellowBannerController.position.minScrollExtent,
                        duration: Duration(seconds: 30),
                        curve: Curves.linear,
                      );
                    }
                    // print(sc.position.isScrollingNotifier.value.toString() + "   value");
                  }),
                  // flag == true
                  //     ? _yellowBannerController.animateTo(
                  //         _yellowBannerController.position.maxScrollExtent,
                  //         duration: Duration(seconds: 30),
                  //         curve: Curves.linear)
                  //     : _yellowBannerController.animateTo(
                  //         _yellowBannerController.position.minScrollExtent,
                  //         duration: Duration(seconds: 30),
                  //         curve: Curves.linear)
                }
            });

    print('DID CHANGE CLICKEEEEDD');
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Widget newsWidget(height, width, currentTheme, themeMode) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: homeNewsData.length,
        itemBuilder: (context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transform(
              //   transform: Matrix4.translationValues(0.0, 1, 0.0),
              //   child: Container(
              //       height: 5,
              //       width: width,
              //       color: !(currentTheme == themeMode.darkMode)
              //           ? hexColor(
              //               homeNewsData[index]["category"]["bg_color_code"]
              //                   .substring(1, 7),
              //             )
              //           : Colors.white),
              // ),
              // Container(
              //   height: 30,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           Container(
              //               child: Center(
              //                 child: Padding(
              //                   padding: const EdgeInsets.only(right: 90),
              //                   child: heading(
              //                       text: homeNewsData[index]["category"]
              //                           ["title"],
              //                       color: !(currentTheme == themeMode.darkMode)
              //                           ? hexColor(homeNewsData[index]
              //                                   ["category"]["text_color_code"]
              //                               .substring(1, 7))
              //                           : Colors.black,
              //                       weight: FontWeight.w800,
              //                       scale: 1.1),
              //                 ),
              //               ),
              //               width: width * 0.5,
              //               height: 30,
              //               color: !(currentTheme == themeMode.darkMode)
              //                   ? hexColor(homeNewsData[index]["category"]
              //                           ["bg_color_code"]
              //                       .substring(1, 7))
              //                   : Colors.white),
              //           Transform(
              //             transform: Matrix4.translationValues(-1, 0, 0.0),
              //             child: Diagonal(
              //               child: Container(
              //                 width: 50,
              //                 height: 32,
              //                 color: !(currentTheme == themeMode.darkMode)
              //                     ? hexColor(homeNewsData[index]["category"]
              //                             ["bg_color_code"]
              //                         .substring(1, 7))
              //                     : Colors.white,
              //               ),
              //               clipHeight: 40,
              //               position: DiagonalPosition.BOTTOM_LEFT,
              //             ),
              //           ),
              //         ],
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(right: 8.0),
              //         child: InkWell(
              //           onTap: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => Gallery(
              //                       widget.scrollController,
              //                       homeNewsData[index]["category"]["cp_id"],
              //                       homeNewsData[index]["category"]["title"]),
              //                 ));
              //             // changePage(index + 1);
              //           },
              //           child: heading(
              //               scale: 1,
              //               text: "और देखें",
              //               color: !(currentTheme == themeMode.darkMode)
              //                   ? Colors.blue[900]!
              //                   : Colors.white,
              //               weight: FontWeight.w600),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: homeNewsData[index]["news"].length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, int newsIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 2),
                    child: InkWell(
                        onTap: () {
                          if (homeNewsData[index]["news"][newsIndex]
                                  ["is_open_in_web_view"] ==
                              0) {
                            final dataNews = {
                              "newsTitle": homeNewsData[index]["news"]
                                  [newsIndex]["title"],
                              "newsURL": homeNewsData[index]["news"][newsIndex]
                                  ["imported_news_url"],
                              "data": homeNewsData[index]["news"][newsIndex],
                            };
                            Get.to(WebviewScreen(), arguments: dataNews)!
                                .then((value) async {
                              final fileName = "readNews.json";
                              var dir = await getTemporaryDirectory();
                              File file = File(dir.path + "/" + fileName);
                              setState(() {
                                readNews.add(homeNewsData[index]["news"]
                                        [newsIndex]["title"]
                                    .toString());
                                file.writeAsStringSync(jsonEncode(readNews),
                                    flush: true, mode: FileMode.write);
                              });
                            });

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => WebviewScreen(
                            //       newsTitle: homeNewsData[index]["news"][newsIndex]
                            //           ["title"],
                            //       newsURL: homeNewsData[index]["news"][newsIndex]
                            //           ["imported_news_url"],
                            //       data: homeNewsData[index]["news"][newsIndex],
                            //     ),
                            //   ),
                            // ).then((value) async {
                            //   final fileName = "readNews.json";
                            //   var dir = await getTemporaryDirectory();
                            //   File file = File(dir.path + "/" + fileName);
                            //   setState(() {
                            //     readNews.add(homeNewsData[index]["news"][newsIndex]
                            //             ["title"]
                            //         .toString());
                            //     file.writeAsStringSync(jsonEncode(readNews),
                            //         flush: true, mode: FileMode.write);
                            //   });
                            // });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HTMLNews(
                                  newsUrl: homeNewsData[index]["news"]
                                      [newsIndex]["imported_news_url"],
                                  news_image: homeNewsData[index]["news"]
                                      [newsIndex]["main_image"],
                                  newsSource: homeNewsData[index]["news"]
                                      [newsIndex]["source_website"],
                                  newsTime: homeNewsData[index]["news"]
                                      [newsIndex]["imported_date"],
                                  newsTitle: homeNewsData[index]["news"]
                                      [newsIndex]["title"],
                                  htmlData: homeNewsData[index]["news"]
                                      [newsIndex]["body"],
                                ),
                              ),
                            ).then((value) async {
                              final fileName = "readNews.json";
                              var dir = await getTemporaryDirectory();
                              File file = File(dir.path + "/" + fileName);

                              setState(() {
                                readNews.add(homeNewsData[index]["news"]
                                        [newsIndex]["title"]
                                    .toString());
                                file.writeAsStringSync(jsonEncode(readNews),
                                    flush: true, mode: FileMode.write);
                              });
                            });
                          }
                        },
                        child: NewsDetailsContainer(
                            newsData: homeNewsData[index]["news"][newsIndex])),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.grey.withOpacity(0.7),
                  );
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    contaierwidth = mq.width * .5;

    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    // if (_yellowBannerController.hasClients)
    //   _yellowBannerController.position.addListener(() {
    //     print(_yellowBannerController.position.isScrollingNotifier.value);
    //     if (_yellowBannerController.position.isScrollingNotifier.value ==
    //         false) {
    //       final val = _yellowBannerController.position.maxScrollExtent / 10;
    //       print(" one indexxx " + val.toString());

    //       print("Positionnnnnn" + _yellowBannerController.offset.toString());
    //     } else {
    //       print("moving");
    //     }
    //   });
    var height = mq.height;
    var width = mq.width;
    // sc.position.isScrollingNotifier.addListener(() {
    //   print("Printingggggg" + sc.position.isScrollingNotifier.value.toString());
    // });
    // WidgetsBinding.instance!.addPostFrameCallback((_) {

    // });

    return Scaffold(
      backgroundColor:
          currentTheme == themeMode.darkMode ? Colors.black : Colors.white,
      key: widget.scaffoldKey,
      body: RefreshIndicator(
        onRefresh: getInfo,
        child: ListView(
          controller: sc1,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            // Container(
            //   height: 30,
            //   color: !(currentTheme == themeMode.darkMode)
            //       ? Colors.white
            //       : Colors.black,
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           children: [
            //             Icon(
            //               Icons.location_pin,
            //               color: !(currentTheme == themeMode.darkMode)
            //                   ? Colors.black
            //                   : Colors.white,
            //               size: height * 0.02,
            //             ),
            //             heading(
            //                 text: apnadistict.length == 0
            //                     ? districtName
            //                     : apnadistict,
            //                 color: Colors.red,
            //                 scale: 1,
            //                 weight: FontWeight.w800)
            //           ],
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => FromHomeMeraSheher(),
            //               ),
            //             ).then((value) => {
            //                   setState(() {
            //                     getInfo();
            //                   })
            //                 });
            //           },
            //           child: apnadistict.length == 0 && districtName.length == 0
            //               ? getContainer(height, currentTheme, themeMode)
            //               : Row(
            //                   children: [
            //                     Padding(
            //                       padding: const EdgeInsets.only(top: 5.0),
            //                       child: heading(
            //                           text: "अपना शहर बदले",
            //                           color:
            //                               !(currentTheme == themeMode.darkMode)
            //                                   ? Colors.black
            //                                   : Colors.white,
            //                           scale: 1,
            //                           weight: FontWeight.w800),
            //                     ),
            //                     Icon(Icons.edit,
            //                         color: !(currentTheme == themeMode.darkMode)
            //                             ? Colors.black
            //                             : Colors.white,
            //                         size: height * 0.02),
            //                   ],
            //                 ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            topBarNewsData.length != 0
                ? Container(
                    height: height * 0.085,
                    color: !(currentTheme == themeMode.darkMode)
                        ? Colors.lime[100]
                        : Colors.black,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      controller: _yellowBannerController,
                      children:
                          yellowBanner(context, mq, currentTheme, themeMode),
                    ),
                  )
                : Container(),
            getallads == null || getallads['count'] == 0
                ? SizedBox()
                : Container(),
            // : Container(
            //     height: height * 0.10,
            //     child: CarouselSlider(
            //       items: List.generate(getallads['count'], (index) {
            //         return InkWell(
            //           onTap: () async {
            //             print("Cliccccccccccccccccccccccccked");
            //             try {
            //               var link = getallads['ads'][index]['ad_link'];
            //               // var stringLink = link.toString().length;
            //               //    print("leng" + stringLink.toString());
            //               print(link.toString() + "linkkkkkkkk");
            //               if (link ==
            //                   "https://play.google.com/store/apps/details?id=com.citynews.india") {
            //                 await launch(link);
            //               } else if (link != null) {
            //                 final dataNews = {
            //                   "newsTitle": "",
            //                   "newsURL": link,
            //                   "data": {},
            //                 };
            //                 Get.to(WebviewScreen(), arguments: dataNews);
            //                 // Navigator.push(
            //                 //     context,
            //                 //     MaterialPageRoute(
            //                 //         builder: (context) => WebviewScreen(
            //                 //             newsTitle: '',
            //                 //             newsURL: link,
            //                 //             data: '')));
            //               } else {
            //                 final img =
            //                     getallads['ads'][index]['ad_banner'];
            //                 await transparentDialogScreen(
            //                     img, mq, currentTheme, themeMode);
            //               }
            //             } catch (_) {
            //               final img = getallads['ads'][index]['ad_banner'];
            //               await transparentDialogScreen(
            //                   img, mq, currentTheme, themeMode);
            //             }
            //           },
            //           child: Container(
            //             height: height * 0.2,
            //             width: double.infinity,
            //             decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                     image: CachedNetworkImageProvider(
            //                         getallads['ads'][index]['ad_banner']),
            //                     fit: BoxFit.fill)),
            //           ),
            //         );
            //       }),

            //       // configuration of the add speed
            //       options: CarouselOptions(
            //         enlargeCenterPage: true,
            //         autoPlayCurve: Curves.linear,
            //         autoPlayInterval: Duration(milliseconds: 3000),
            //         autoPlay: true,
            //         aspectRatio: 1,
            //         enableInfiniteScroll: true,
            //         autoPlayAnimationDuration: Duration(milliseconds: 100),
            //         viewportFraction: 1,
            //       ),
            //     ),
            //   ),
            homeNewsData.length == 0
                ? Container()
                : newsWidget(height, width, currentTheme, themeMode),
          ],
        ),
      ),
    );

    // return RefreshIndicator(
    //   onRefresh: () async {
    //     setState(() {
    //       stChange = 1;
    //     });
    //   },
    //   child: FutureBuilder(
    //       future: getInfo(),
    //       builder: (context, AsyncSnapshot snapshot) {
    //         if (snapshot.connectionState == ConnectionState.done) {
    //           return ListView(
    //             controller: sc1,
    //             shrinkWrap: true,
    //             physics: BouncingScrollPhysics(),
    //             children: [
    //               Container(
    //                 height: 30,
    //                 color: dark == 0 ? Colors.lime[100] : Colors.black,
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 10, vertical: 0),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Row(
    //                         children: [
    //                           Icon(Icons.location_pin,
    //                               color:
    //                                   dark == 0 ? Colors.black : Colors.white,
    //                               size: height * 0.02),
    //                           heading(
    //                               text: topBarNewsData.isNotEmpty
    //                                   ? Provider.of<SheherChangeProvider>(
    //                                                   context)
    //                                               .getSheher()
    //                                               .length ==
    //                                           0
    //                                       ? districtName
    //                                       : Provider.of<SheherChangeProvider>(
    //                                               context)
    //                                           .getSheher()
    //                                   : '',
    //                               color: Colors.red,
    //                               scale: 1,
    //                               weight: FontWeight.w800)
    //                         ],
    //                       ),
    //                       GestureDetector(
    //                         onTap: () {
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       FromHomeMeraSheher()));
    //                         },
    //                         child: Row(
    //                           children: [
    //                             Padding(
    //                               padding: const EdgeInsets.only(top: 5.0),
    //                               child: heading(
    //                                   text: "अपना शहर बदले",
    //                                   color: dark == 0
    //                                       ? Colors.black
    //                                       : Colors.white,
    //                                   scale: 1,
    //                                   weight: FontWeight.w800),
    //                             ),
    //                             Icon(Icons.edit,
    //                                 color:
    //                                     dark == 0 ? Colors.black : Colors.white,
    //                                 size: height * 0.02),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               topBarNewsData.isNotEmpty
    //                   ? Container(
    //                       height: height * 0.10,
    //                       color: dark == 0 ? Colors.lime[100] : Colors.black,
    //                       child: CarouselSlider(
    //                         items: yellowBanner(context, mq),
    //                         //   //     List.generate(topBarNewsData.length, (index) {
    //                         //   //       // ignore: unnecessary_statements
    //                         //   //       onTap: () {
    //                         //   //       if (topBarNewsData[index]
    //                         //   //               ["is_open_in_web_view"] ==
    //                         //   //           0)
    //                         //   //         Navigator.push(
    //                         //   //             context,
    //                         //   //             MaterialPageRoute(
    //                         //   //                 builder: (context) => WebviewScreen(
    //                         //   //                       newsTitle:
    //                         //   //                           topBarNewsData[index]
    //                         //   //                               ["title"],
    //                         //   //                       newsURL: topBarNewsData[index]
    //                         //   //                           ["imported_news_url"],
    //                         //   //                       data: topBarNewsData[index],
    //                         //   //                     )));
    //                         //   //       else {
    //                         //   //         Navigator.push(
    //                         //   //             context,
    //                         //   //             MaterialPageRoute(
    //                         //   //                 builder: (context) => HTMLNews(
    //                         //   //                       newsUrl: topBarNewsData[index]
    //                         //   //                           ["imported_news_url"],
    //                         //   //                       news_image:
    //                         //   //                           topBarNewsData[index]
    //                         //   //                               ["main_image"],
    //                         //   //                       newsSource:
    //                         //   //                           topBarNewsData[index]
    //                         //   //                               ["source_website"],
    //                         //   //                       newsTime:
    //                         //   //                           topBarNewsData[index]
    //                         //   //                               ["publish_date"],
    //                         //   //                       newsTitle:
    //                         //   //                           topBarNewsData[index]
    //                         //   //                               ["title"],
    //                         //   //                       htmlData:
    //                         //   //                           topBarNewsData[index]
    //                         //   //                               ["title"],
    //                         //   //                     )));
    //                         //   //       }
    //                         //   //     },
    //                         //   //   return GestureDetector(
    //                         //   //     child: Container(
    //                         //   //       width: width * 0.5,
    //                         //   //       decoration: BoxDecoration(
    //                         //   //         // color: Colors.teal,
    //                         //   //         borderRadius: BorderRadius.circular(10),
    //                         //   //       ),
    //                         //   //       child: Column(
    //                         //   //           mainAxisAlignment:
    //                         //   //               MainAxisAlignment.center,
    //                         //   //           crossAxisAlignment:
    //                         //   //               CrossAxisAlignment.start,
    //                         //   //           children: [
    //                         //   //             AutoSizeText(
    //                         //   //               topBarNewsData[index]['title'],
    //                         //   //               maxLines: 2,
    //                         //   //               overflow: TextOverflow.ellipsis,
    //                         //   //               textScaleFactor: 0.9,
    //                         //   //               minFontSize: 17,
    //                         //   //               style: TextStyle(
    //                         //   //                 color: dark == 0
    //                         //   //                     ? Colors.black
    //                         //   //                     : Colors.white,
    //                         //   //               ),
    //                         //   //             ),
    //                         //   //             // heading(
    //                         //   //             //     text: topBarNewsData[index]["title"],
    //                         //   //             //     align: TextAlign.left,
    //                         //   //             //     scale: 0.9),
    //                         //   //             SizedBox(height: 3),
    //                         //   //             Row(
    //                         //   //               children: [
    //                         //   //                 heading(
    //                         //   //                     text: topBarNewsData[index]
    //                         //   //                         ["source_website"],
    //                         //   //                     scale: 0.8,
    //                         //   //                     color: dark == 0
    //                         //   //                         ? Colors.black38
    //                         //   //                         : Colors.white),
    //                         //   //                 heading(
    //                         //   //                     text: " | ",
    //                         //   //                     scale: 0.8,
    //                         //   //                     color: dark == 0
    //                         //   //                         ? Colors.black38
    //                         //   //                         : Colors.white54),
    //                         //   //                 heading(
    //                         //   //                     text: topBarNewsData[index]
    //                         //   //                         ["imported_date"],
    //                         //   //                     scale: 0.8,
    //                         //   //                     color: dark == 0
    //                         //   //                         ? Colors.blue
    //                         //   //                         : Colors.blue)
    //                         //   //               ],
    //                         //   //             )
    //                         //   //           ]),
    //                         //   //     ),
    //                         //   //   );
    //                         //   // }),
    //                         // carouselController: buttonCarouselController,
    //                         options: CarouselOptions(
    //                           // onPageChanged: (index, reason) {
    //                           //   // print(reason.CarouselPageChangedReason.timed),
    //                           //   print("Index" + index.toString());
    //                           //   print("length" +
    //                           //       topBarNewsData.length.toString());
    //                           //   if (index == topBarNewsData.length - 1) {
    //                           //     setState(() {
    //                           //       completed = !completed;
    //                           //     });
    //                           //   }
    //                           // },
    //                           initialPage: 0,
    //                           reverse: completed,
    //                           enlargeCenterPage: false,
    //                           autoPlayCurve: Curves.linear,
    //                           autoPlayInterval: Duration(seconds: 2),
    //                           autoPlay: true,
    //                           pageSnapping: false,
    //                           aspectRatio: 6,
    //                           pageViewKey: pageNo,
    //                           enableInfiniteScroll: true,
    //                           autoPlayAnimationDuration: Duration(seconds: 8),
    //                           viewportFraction: 0.55,
    //                         ),
    //                       )
    //                       // ListView.builder(
    //                       //     controller: sc,
    //                       //     scrollDirection: Axis.horizontal,
    //                       //     itemCount: topBarNewsData.length,
    //                       //     itemBuilder: (context, int index) {
    //                       //       return
    //                       //         Padding(
    //                       //         padding: const EdgeInsets.only(
    //                       //             left: 8, right: 8, bottom: 5),
    //                       //         child: Container(
    //                       //           width: width * 0.4,
    //                       //           decoration: BoxDecoration(
    //                       //             borderRadius: BorderRadius.circular(10),
    //                       //           ),
    //                       //           child: Padding(
    //                       //             padding: const EdgeInsets.all(3.0),
    //                       //             child: Column(
    //                       //                 mainAxisAlignment: MainAxisAlignment.center,
    //                       //                 crossAxisAlignment:
    //                       //                     CrossAxisAlignment.start,
    //                       //                 children: [
    //                       //                   AutoSizeText(
    //                       //                     topBarNewsData[index]["title"],
    //                       //                     maxLines: 2,
    //                       //                     overflow: TextOverflow.ellipsis,
    //                       //                     textScaleFactor: 0.9,
    //                       //                     minFontSize: 14,
    //                       //                     style: TextStyle(
    //                       //                       color: dark == 0
    //                       //                           ? Colors.black
    //                       //                           : Colors.white,
    //                       //                     ),
    //                       //                   ),
    //                       //                   // heading(
    //                       //                   //     text: topBarNewsData[index]["title"],
    //                       //                   //     align: TextAlign.left,
    //                       //                   //     scale: 0.9),
    //                       //                   SizedBox(height: 3),
    //                       //                   Row(
    //                       //                     children: [
    //                       //                       heading(
    //                       //                           text: topBarNewsData[index]
    //                       //                               ["source_website"],
    //                       //                           scale: 0.8,
    //                       //                           color: dark == 0
    //                       //                               ? Colors.black38
    //                       //                               : Colors.white54),
    //                       //                       heading(
    //                       //                           text: " | ",
    //                       //                           scale: 0.8,
    //                       //                           color: dark == 0
    //                       //                               ? Colors.black38
    //                       //                               : Colors.white54),
    //                       //                       heading(
    //                       //                           text: topBarNewsData[index]
    //                       //                               ["imported_date"],
    //                       //                           scale: 0.8,
    //                       //                           color: dark == 0
    //                       //                               ? Colors.blue
    //                       //                               : Colors.white70)
    //                       //                     ],
    //                       //                   )
    //                       //                 ]),
    //                       //           ),
    //                       //         ),
    //                       //       );
    //                       //       ///carousel slider
    //                       //       // ListView(
    //                       //       //   shrinkWrap: true,
    //                       //       //   scrollDirection:Axis.horizontal,
    //                       //       //   controller: new ScrollController(),
    //                       //       //   children: [
    //                       //       //     CarouselSlider(
    //                       //       //       items: List.generate(topBarNewsData.length,
    //                       //       //               (index){
    //                       //       //             return Padding(
    //                       //       //               padding: const EdgeInsets.only(
    //                       //       //                   left: 8, right: 8, bottom: 5),
    //                       //       //               child: Container(
    //                       //       //                 width: width * 0.4,
    //                       //       //                 decoration: BoxDecoration(
    //                       //       //                   borderRadius: BorderRadius.circular(10),
    //                       //       //                 ),
    //                       //       //                 child: Padding(
    //                       //       //                   padding: const EdgeInsets.all(3.0),
    //                       //       //                   child: Column(
    //                       //       //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       //       //                       crossAxisAlignment:
    //                       //       //                       CrossAxisAlignment.start,
    //                       //       //                       children: [
    //                       //       //                         AutoSizeText(
    //                       //       //                           topBarNewsData[index]["title"],
    //                       //       //                           maxLines: 2,
    //                       //       //                           overflow: TextOverflow.ellipsis,
    //                       //       //                           textScaleFactor: 0.9,
    //                       //       //                           minFontSize: 14,
    //                       //       //                           style: TextStyle(
    //                       //       //                             color: dark == 0
    //                       //       //                                 ? Colors.black
    //                       //       //                                 : Colors.white,
    //                       //       //                           ),
    //                       //       //                         ),
    //                       //       //                         // heading(
    //                       //       //                         //     text: topBarNewsData[index]["title"],
    //                       //       //                         //     align: TextAlign.left,
    //                       //       //                         //     scale: 0.9),
    //                       //       //                         SizedBox(height: 3),
    //                       //       //                         Row(
    //                       //       //                           children: [
    //                       //       //                             heading(
    //                       //       //                                 text: topBarNewsData[index]
    //                       //       //                                 ["source_website"],
    //                       //       //                                 scale: 0.8,
    //                       //       //                                 color: dark == 0
    //                       //       //                                     ? Colors.black38
    //                       //       //                                     : Colors.white54),
    //                       //       //                             heading(
    //                       //       //                                 text: " | ",
    //                       //       //                                 scale: 0.8,
    //                       //       //                                 color: dark == 0
    //                       //       //                                     ? Colors.black38
    //                       //       //                                     : Colors.white54),
    //                       //       //                             heading(
    //                       //       //                                 text: topBarNewsData[index]
    //                       //       //                                 ["imported_date"],
    //                       //       //                                 scale: 0.8,
    //                       //       //                                 color: dark == 0
    //                       //       //                                     ? Colors.blue
    //                       //       //                                     : Colors.white70)
    //                       //       //                           ],
    //                       //       //                         )
    //                       //       //                       ]),
    //                       //       //                 ),
    //                       //       //               ),
    //                       //       //             );
    //                       //       //           }),
    //                       //       //       options: CarouselOptions(
    //                       //       //         autoPlay: true,
    //                       //       //         aspectRatio: 16 / 9,
    //                       //       //         enableInfiniteScroll: true,
    //                       //       //         autoPlayAnimationDuration: Duration(milliseconds: 1200),
    //                       //       //         viewportFraction: 0.9,
    //                       //       //       ),
    //                       //       //     )
    //                       //       //   ],
    //                       //       // ),
    //                       //     }),
    //                       )
    //                   : SizedBox(),
    //               // adsAvailable
    //               //     ? Container(
    //               //         height: height * 0.1,
    //               //         width: width,
    //               //         child: custom_Ad["img"] == null
    //               //             ? Center(child: LinearProgressIndicator())
    //               //             : CachedNetworkImage(imageUrl: custom_Ad["img"] ?? ""),
    //               //       )
    //               //     : SizedBox(),
    //               //  child: getallads["ads"][0]["ad_banner"].toString().length==0
    //               //               ? Center(child: LinearProgressIndicator())
    //               //               : CachedNetworkImage(imageUrl:getallads["ads"][0]["ad_banner"]  ?? ""),
    //               //         )
    //               getallads == null || getallads['count'] == 0
    //                   ? SizedBox()
    //                   : Container(
    //                       height: height * 0.10,
    //                       child: CarouselSlider(
    //                         items: List.generate(getallads['count'], (index) {
    //                           return InkWell(
    //                             onTap: () async {
    //                               print("Cliccccccccccccccccccccccccked");
    //                               try {
    //                                 var link =
    //                                     getallads['ads'][index]['ad_link'];
    //                                 // var stringLink = link.toString().length;
    //                                 //    print("leng" + stringLink.toString());
    //                                 if (link != 'Www.Ingnewsbank.com') {
    //                                   Navigator.push(
    //                                       context,
    //                                       MaterialPageRoute(
    //                                           builder: (context) =>
    //                                               WebviewScreen(
    //                                                   newsTitle: '',
    //                                                   newsURL: link,
    //                                                   data: '')));
    //                                 } else {
    //                                   final img =
    //                                       getallads['ads'][index]['ad_banner'];
    //                                   await transparentDialogScreen(img, mq);
    //                                 }
    //                               } catch (_) {
    //                                 final img =
    //                                     getallads['ads'][index]['ad_banner'];
    //                                 await transparentDialogScreen(img, mq);
    //                               }
    //                             },
    //                             child: Container(
    //                               height: height * 0.2,
    //                               width: double.infinity,
    //                               decoration: BoxDecoration(
    //                                   image: DecorationImage(
    //                                       image: CachedNetworkImageProvider(
    //                                           getallads['ads'][index]
    //                                               ['ad_banner']),
    //                                       fit: BoxFit.fill)),
    //                             ),
    //                           );
    //                         }),
    //                         // configuration of the add speed
    //                         options: CarouselOptions(
    //                           enlargeCenterPage: true,
    //                           autoPlayCurve: Curves.linear,
    //                           autoPlayInterval: Duration(milliseconds: 3000),
    //                           autoPlay: true,
    //                           aspectRatio: 1,
    //                           enableInfiniteScroll: true,
    //                           autoPlayAnimationDuration:
    //                               Duration(milliseconds: 100),
    //                           viewportFraction: 1,
    //                         ),
    //                       ),
    //                     ),
    //               // : GestureDetector(
    //               //     onTap: () {
    //               //       if (getallads["ads"][0]
    //               //                   //  ["ad_banner"],
    //               //                   ["ad_link"]
    //               //               .toString() !=
    //               //           "null") {
    //               //         Navigator.push(
    //               //             context,
    //               //             MaterialPageRoute(
    //               //                 builder: (context) => WebviewScreen(
    //               //                       newsTitle: getallads["ads"][0]
    //               //                           ["title"],
    //               //                       newsURL: getallads["ads"][0]
    //               //                           //  ["ad_banner"],
    //               //                           ["ad_link"], data: null,
    //               //                     )));
    //               //         showDialog(
    //               //             context: context,
    //               //             builder: (context) => new AlertDialog(
    //               //                   insetPadding: EdgeInsets.all(0),
    //               //                   backgroundColor:
    //               //                       Colors.black.withOpacity(0.0),
    //               //                   content: Builder(
    //               //                     builder: (context) {
    //               //                       // Get available height and width of the build area of this widget. Make a choice depending on the size.
    //               //                       var height = MediaQuery.of(context)
    //               //                           .size
    //               //                           .height;
    //               //                       var width = MediaQuery.of(context)
    //               //                           .size
    //               //                           .width;
    //               //
    //               //                       return Stack(
    //               //                         children: [
    //               //                           Container(
    //               //                             color: Colors.transparent,
    //               //                             height: height,
    //               //                             width: width,
    //               //                             child: FittedBox(
    //               //                               fit: BoxFit.fitHeight,
    //               //                               child: RotatedBox(
    //               //                                 quarterTurns: 3,
    //               //                                 child: ClipPath(
    //               //                                     child: Image.network(
    //               //                                   getallads["ads"][0]
    //               //                                           ["ad_banner"]
    //               //                                       .toString(),
    //               //                                 )),
    //               //                               ),
    //               //                             ),
    //               //                           ),
    //               //                           Positioned(
    //               //                             top: 0,
    //               //                             right: 0,
    //               //                             child: GestureDetector(
    //               //                                 onTap: () =>
    //               //                                     Navigator.pop(
    //               //                                         context, true),
    //               //                                 child: Container(
    //               //                                   child: Icon(Icons.close,
    //               //                                       color: Colors.red),
    //               //                                 )),
    //               //                           )
    //               //                         ],
    //               //                       );
    //               //                     },
    //               //                   ),
    //               //                   // actions: <Widget>[
    //               //                   //   Expanded(
    //               //                   //     child: Container(
    //               //                   //       width: MediaQuery.of(context).size.width,
    //               //                   //       height:
    //               //                   //           MediaQuery.of(context).size.height,
    //               //                   //       child:
    //               //                   //       // child: Row(
    //               //                   //       //   mainAxisAlignment:
    //               //                   //       //       MainAxisAlignment.spaceBetween,
    //               //                   //       //   children: [
    //               //                   //       //     Center(
    //               //                   //       //       child: RotatedBox(
    //               //                   //       //         quarterTurns: 3,
    //               //                   //       //         child: ClipPath(
    //               //                   //       //             child: Image.network(
    //               //                   //       //           getallads["ads"][0]["ad_banner"]
    //               //                   //       //               .toString(),
    //               //                   //       //           fit: BoxFit.fill,
    //               //                   //       //         )),
    //               //                   //       //       ),
    //               //                   //       //     ),
    //               //                   //       //     GestureDetector(
    //               //                   //       //         onTap: () =>
    //               //                   //       //             Navigator.pop(context, true),
    //               //                   //       //         child: Container(
    //               //                   //       //           child: Icon(Icons.close,
    //               //                   //       //               color: Colors.red),
    //               //                   //       //         )),
    //               //                   //       //   ],
    //               //                   //       // ),
    //               //                   //     ),
    //               //                   //   ),
    //               //                   // ],
    //               //                 ));
    //               //
    //               //         //   Navigator.push(
    //               //         //       context,
    //               //         //       MaterialPageRoute(
    //               //         //           builder: (context) => HTMLNews(
    //               //         //                 newsUrl: homeNewsData[index]
    //               //         //                         ["news"][newsIndex]
    //               //         //                     ["imported_news_url"],
    //               //         //                 news_image:
    //               //         //                     homeNewsData[index]
    //               //         //                             ["news"][newsIndex]
    //               //         //                         ["main_image"],
    //               //         //                 newsSource:
    //               //         //                     homeNewsData[index]
    //               //         //                             ["news"][newsIndex]
    //               //         //                         ["source_website"],
    //               //         //                 newsTime: homeNewsData[index]
    //               //         //                         ["news"][newsIndex]
    //               //         //                     ["imported_date"],
    //               //         //                 newsTitle: homeNewsData[index]
    //               //         //                     ["news"][newsIndex]["title"],
    //               //         //                 htmlData: homeNewsData[index]
    //               //         //                     ["news"][newsIndex]["body"],
    //               //         //               )));
    //               //       }
    //               //     },
    //               //     child: getallads["ads"][0]["ad_banner"] == null
    //               //         ? SizedBox()
    //               //         : Container(
    //               //             height: height * 0.1,
    //               //             width: width,
    //               //             decoration: BoxDecoration(
    //               //                 image: DecorationImage(
    //               //                     image: CachedNetworkImageProvider(
    //               //                         getallads["ads"][0]["ad_banner"]),
    //               //                     fit: BoxFit.fill)),
    //               //           )),
    //               // if (snapshot.connectionState == ConnectionState.done &&
    //               //     homeNewsData != null)
    //               FutureBuilder(
    //                   future: getHomeNews(),
    //                   builder: (context, AsyncSnapshot snapshot) {
    //                     if (snapshot.connectionState ==
    //                         ConnectionState.waiting) {
    //                       print("Inside waiting");
    //                       return newsWidget(height, width);
    //                     } else if (snapshot.connectionState ==
    //                         ConnectionState.active) {
    //                       print("Inside active");
    //                       return newsWidget(height, width);
    //                     } else {
    //                       return Container(child: Text("No news available"));
    //                     }
    //                   })
    //             ],
    //           );
    //         } else
    //           return Center(child: Container());
    //       }),
    // );
  }

  bool isscrollDown = false;

  // double bottomBarHei = 60;

  // void myScroll() {
  // sc1.addListener(() {
  //   if (sc1.position.userScrollDirection == ScrollDirection.reverse) {
  //     if (!isscrollDown) {
  //       isscrollDown = true;
  //       HomeScreen().showAppBar(false);
  //       HomeScreen().hideBottomBar();
  //     }
  //   }
  //   if (sc1.position.userScrollDirection == ScrollDirection.forward) {
  //     if (isscrollDown) {
  //       isscrollDown = false;
  //       HomeScreen().showAppBar(true);
  //       HomeScreen().showBottomBar();
  //     }
  //   }
  // });
  // }
}
