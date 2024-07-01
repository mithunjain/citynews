
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/screens/news_details/html_news.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/type/types.dart';
import 'package:news/widgets/news_details_container.dart';
import 'package:provider/provider.dart';

import 'home_screen/ads/add_helper.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  bool l = false;

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

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

    Future<bool> loaded() async {
      await storage.ready;
      l = true;
      if (firstTime) {
        setState(() {
          firstTime = false;
        });
      }
      return l;
    }

    for (var i = 0; i < list.items.length; i++) {
      print(i);
      print(list.items[i].id);
    }

    var items = storage.getItem('favourite_news');
    if (items != null) {
      List<dynamic> DATA = [];
      List<String> ID = [];
      list.items = List<Favourite>.from(
        (items as List).map(
          (item) => Favourite(
            data: item['data'],
            id: item['id'],
          ),
        ),
      );
      ID = list.items.map((item) {
        return item.id;
      }).toList();
      DATA = list.items.map((item) {
        return item.data;
      }).toList();
      // print('these are the $fav');
      // print(list.items[0]);
      print(ID);
      print(DATA);
    }

    return Scaffold(
      backgroundColor:
          (currentTheme == themeMode.darkMode) ? Colors.black : Colors.white,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              await showDialog(
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
                        content: Text('सभी बुकमार्क डिलीट करें ?',
                            style: TextStyle(
                                color: !(currentTheme == themeMode.darkMode)
                                    ? Colors.black
                                    : Colors.white)),
                        actions: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 120,
                                ),
                                GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                        child: Text('नहीं',
                                            style: TextStyle(
                                                color: Colors.blue)))),
                                SizedBox(
                                  width: 30,
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      await storage.clear();
                                      list.items =
                                          storage.getItem('favourite_news') ??
                                              [];
                                      Navigator.pop(context);
                                      setState(() {});
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => HomeScreen()));
                                    },
                                    child: Container(
                                        child: Text('डिलीट करें',
                                            style: TextStyle(
                                                color: Colors.blue)))),
                              ],
                            ),
                          ),
                        ],
                      ));
            },
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: !(currentTheme == themeMode.darkMode)
            ? Colors.blue[900]
            : Colors.black,
        title: Text(
          'बुकमार्क',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: list.items.isEmpty && !firstTime
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  if (_isBannerAdReady)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: AdWidget(ad: _bannerAd),
                    ),
                  Container(
                    height: MediaQuery.of(context).size.height - 142,
                    child: AlertDialog(
                      elevation: 5,
                      title: Text('City News',
                          style: TextStyle(
                              color: !(currentTheme == themeMode.darkMode)
                                  ? Colors.black
                                  : Colors.white)),
                      backgroundColor: (currentTheme == themeMode.darkMode)
                          ? Color(0xFF4D555F)
                          : Color(0xFFEEEDEB),
                      content: Text('अभी आपने कोई बुकमार्क नहीं किया है।',
                          style: TextStyle(
                              color: !(currentTheme == themeMode.darkMode)
                                  ? Colors.black
                                  : Colors.white)),
                      actions: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, right: 20),
                          child: Row(
                            children: [
                              Spacer(),
                              GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                      child: Text('बंद करें',
                                          style:
                                              TextStyle(color: Colors.blue)))),
                              SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              color: !(currentTheme == themeMode.darkMode)
                  ? Colors.white
                  : Colors.black,
              child: Column(
                children: [
                  if (_isBannerAdReady)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: AdWidget(ad: _bannerAd),
                    ),
                  FutureBuilder(
                      future: loaded(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return LinearProgressIndicator(
                            color: Colors.blue,
                          );
                        }

                        // List<Widget> widgets=[];
                        // widgets = list.items.map((item) {
                        //   return Padding(
                        //     padding: EdgeInsets.all(10),
                        //     child: Container(
                        //       color: Colors.blue,
                        //       child: Column(
                        //         children: [
                        //           Text('Data is ${item.data['title']}'),
                        //           Text('id is ${item.id}')
                        //         ],
                        //       ),
                        //     ),
                        //   );
                        // }).toList();
                        var mq = MediaQuery.of(context).size;
                        var height = mq.height;
                        var width = mq.width;
                        return l
                            ? Expanded(
                                child: ListView.separated(
                                  itemCount: list.items.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 5,
                                            bottom: 2),
                                        child: GestureDetector(
                                            onTap: () {
                                              if (list.items[index].data[
                                                      "is_open_in_web_view"] ==
                                                  0) {
                                                final tempMap =
                                                    list.items[index].data;

                                                tempMap['main_image_cropped'] =
                                                    '';

                                                final dataNews = {
                                                  "newsTitle": list.items[index]
                                                      .data["title"],
                                                  "newsURL":
                                                      list.items[index].data[
                                                          "imported_news_url"],
                                                  "data": tempMap
                                                };
                                                Get.to(WebviewScreen(),
                                                    arguments: dataNews);
                                              }
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             WebviewScreen(
                                              //              ,
                                              //             )));
                                              else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HTMLNews(
                                                              newsUrl: list
                                                                      .items[index]
                                                                      .data[
                                                                  "imported_news_url"],
                                                              news_image: list
                                                                      .items[index]
                                                                      .data[
                                                                  "main_image"],
                                                              newsSource: list
                                                                      .items[index]
                                                                      .data[
                                                                  "source_website"],
                                                              newsTime: list
                                                                      .items[index]
                                                                      .data[
                                                                  "imported_date"],
                                                              newsTitle: list
                                                                  .items[index]
                                                                  .data["title"],
                                                              htmlData: list
                                                                  .items[index]
                                                                  .data["body"],
                                                            )));
                                              }
                                            },
                                            child: NewsDetailsContainer(
                                                newsData:
                                                    list.items[index].data)));

                                    // Container(
                                    //       height: 80,
                                    //       //height * 0.10,
                                    //       width: width,
                                    //       decoration: BoxDecoration(
                                    //           color: !(currentTheme ==
                                    //                   themeMode.darkMode)
                                    //               ? Colors.green[50]
                                    //               : Colors.white10,
                                    //           borderRadius:
                                    //               BorderRadius.circular(5),
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //                 offset: Offset(3, 3),
                                    //                 color: Colors.black12,
                                    //                 spreadRadius: 0.05)
                                    //           ]),
                                    //       child: Row(
                                    //         children: [
                                    //           list.items[index].data[
                                    //                       "main_image_thumb"] ==
                                    //                   null
                                    //               ? SizedBox()
                                    //               : Container(
                                    //                   height: height * 0.18,
                                    //                   width: width * 0.4,
                                    //                   decoration: BoxDecoration(
                                    //                       image: DecorationImage(
                                    //                           image: CachedNetworkImageProvider(list
                                    //                                   .items[index]
                                    //                                   .data[
                                    //                               "main_image_thumb"]),
                                    //                           fit: BoxFit
                                    //                               .cover)),
                                    //                 ),
                                    //           SizedBox(width: 2),
                                    //           Expanded(
                                    //             child: Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       top: 5),
                                    //               child: Column(
                                    //                 crossAxisAlignment:
                                    //                     CrossAxisAlignment
                                    //                         .start,
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment
                                    //                         .spaceBetween,
                                    //                 children: [
                                    //                   AutoSizeText(
                                    //                     list.items[index]
                                    //                         .data["title"],
                                    //                     style: TextStyle(
                                    //                       fontWeight:
                                    //                           FontWeight.bold,
                                    //                       color: !(currentTheme ==
                                    //                               themeMode
                                    //                                   .darkMode)
                                    //                           ? Colors.black
                                    //                           : Colors.white,
                                    //                     ),
                                    //                     textScaleFactor: 1.0,
                                    //                     maxLines: 3,
                                    //                     minFontSize: 15,
                                    //                     maxFontSize: 29,
                                    //                   ),
                                    //                   // heading(
                                    //                   //     text: homeNewsData[index]
                                    //                   //         ["news"][index2]["title"],
                                    //                   //     maxLines: 3,
                                    //                   //     scale: 1.25,
                                    //                   //     weight: FontWeight.w800,
                                    //                   //     align: TextAlign.left),

                                    //                   Flexible(
                                    //                     child: Row(
                                    //                       mainAxisAlignment:
                                    //                           MainAxisAlignment
                                    //                               .spaceBetween,
                                    //                       crossAxisAlignment:
                                    //                           CrossAxisAlignment
                                    //                               .center,
                                    //                       children: [
                                    //                         Expanded(
                                    //                           child: RichText(
                                    //                             textScaleFactor:
                                    //                                 1.0,
                                    //                             overflow:
                                    //                                 TextOverflow
                                    //                                     .ellipsis,
                                    //                             text: TextSpan(
                                    //                               text: list
                                    //                                       .items[
                                    //                                           index]
                                    //                                       .data[
                                    //                                   "source_website"],
                                    //                               style:
                                    //                                   TextStyle(
                                    //                                 fontSize:
                                    //                                     11,
                                    //                                 color: !(currentTheme ==
                                    //                                         themeMode
                                    //                                             .darkMode)
                                    //                                     ? Colors
                                    //                                         .black54
                                    //                                     : Colors
                                    //                                         .white,
                                    //                               ),
                                    //                               children: <TextSpan>[
                                    //                                 TextSpan(
                                    //                                     text:
                                    //                                         ' | ',
                                    //                                     style: TextStyle(
                                    //                                         color: !(currentTheme == themeMode.darkMode)
                                    //                                             ? Colors.black
                                    //                                             : Colors.white,
                                    //                                         fontWeight: FontWeight.bold)),
                                    //                                 TextSpan(
                                    // text: list
                                    //     .items[
                                    //         index]
                                    //     .data[
                                    //                                             "imported_date"]
                                    //                                         .toString(),
                                    //                                     style: TextStyle(
                                    //                                         color:
                                    //                                             Colors.blue))
                                    //                               ],
                                    //                             ),
                                    //                           ),
                                    //                         ),
                                    //                         GestureDetector(
                                    //                             onTap: () {
                                    //                               showModalBottomSheet(
                                    //                                   isScrollControlled:
                                    //                                       true,
                                    //                                   context:
                                    //                                       context,
                                    //                                   builder:
                                    //                                       (context) =>
                                    //                                           Padding(
                                    //                                             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    //                                             child: SingleChildScrollView(
                                    //                                               child: Container(
                                    //                                                 color: (currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                    //                                                 height: 200,
                                    //                                                 child: Column(
                                    //                                                   children: [
                                    //                                                     Padding(
                                    //                                                       padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    //                                                       child: Center(
                                    //                                                         child: Text(
                                    //                                                           list.items[index].data["title"],
                                    //                                                           style: TextStyle(color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white, fontSize: 19),
                                    //                                                         ),
                                    //                                                       ),
                                    //                                                     ),
                                    //                                                     Expanded(
                                    //                                                       child: TextButton(
                                    //                                                         onPressed: () async {
                                    //                                                           final tempMap = list.items[index].data;

                                    //                                                           tempMap['main_image_cropped'] = '';

                                    //                                                           final newsData = {
                                    //                                                             "newsTitle": list.items[index].data["title"],
                                    //                                                             "newsURL": list.items[index].data["imported_news_url"],
                                    //                                                             "data": tempMap
                                    //                                                           };
                                    //                                                           //! adding logic for dynamic url

                                    //                                                           String url = '';
                                    //                                                           await generateUrl(newsData).then((value) => {
                                    //                                                                 url = value,
                                    //                                                               });

                                    //                                                           print('it\'s shared');
                                    //                                                           FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳");
                                    //                                                           // FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳                                            " + list.items[index].data["title"], chooserTitle: "इस खबर को शेयर करो...");
                                    //                                                           Navigator.pop(context);
                                    //                                                         },
                                    //                                                         child: Row(
                                    //                                                           children: [
                                    //                                                             Padding(
                                    //                                                                 padding: EdgeInsets.symmetric(horizontal: 20),
                                    //                                                                 child: Icon(
                                    //                                                                   Icons.share,
                                    //                                                                   size: 25,
                                    //                                                                   color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                    //                                                                 )),
                                    //                                                             Text(
                                    //                                                               'शेयर करें',
                                    //                                                               style: TextStyle(color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white, fontSize: 18),
                                    //                                                             )
                                    //                                                           ],
                                    //                                                         ),
                                    //                                                       ),
                                    //                                                     ),
                                    //                                                     Expanded(
                                    //                                                       child: TextButton(
                                    //                                                         onPressed: () async {
                                    //                                                           list.items.removeAt(index);
                                    //                                                           await storage.setItem('favourite_news', list.toJSONEncodable());
                                    //                                                           print('it\'s bookmarked');
                                    //                                                           Navigator.pop(context);
                                    //                                                           ScaffoldMessenger.of(context).showSnackBar(
                                    //                                                             SnackBar(
                                    //                                                                 content: Text(
                                    //                                                                   'बुकमार्क डिलीट हो गय',
                                    //                                                                   style: TextStyle(
                                    //                                                                     fontSize: 17,
                                    //                                                                     color: Colors.white,
                                    //                                                                   ),
                                    //                                                                 ),
                                    //                                                                 action: SnackBarAction(
                                    //                                                                   onPressed: () {},
                                    //                                                                   label: 'Close',
                                    //                                                                   textColor: Colors.white,
                                    //                                                                 ),
                                    //                                                                 duration: Duration(seconds: 3)),
                                    //                                                           );
                                    //                                                           setState(() {});
                                    //                                                         },
                                    //                                                         child: Row(
                                    //                                                           children: [
                                    //                                                             Padding(
                                    //                                                                 padding: EdgeInsets.symmetric(horizontal: 20),
                                    //                                                                 child: Icon(
                                    //                                                                   Icons.delete,
                                    //                                                                   size: 25,
                                    //                                                                   color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                    //                                                                 )),
                                    //                                                             Text(
                                    //                                                               'डिलीट करें',
                                    //                                                               style: TextStyle(color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white, fontSize: 18),
                                    //                                                             )
                                    //                                                           ],
                                    //                                                         ),
                                    //                                                       ),
                                    //                                                     )
                                    //                                                     // Expanded(
                                    //                                                     //   child: TextButton(
                                    //                                                     //     onPressed: () {
                                    //                                                     //       print('1');
                                    //                                                     //       print(homeNewsData[index]["news"][index2]["post_id"]);
                                    //                                                     //       final item = Favourite(id: homeNewsData[index]["news"][index2]["post_id"].toString(), data: homeNewsData[index]["news"][index2]);
                                    //                                                     //       print('2');
                                    //                                                     //       list.items.add(item);
                                    //                                                     //       storage.setItem('favourite_news', list.toJSONEncodable());
                                    //                                                     //       favourites.add(P);
                                    //                                                     //       print('it\'s bookmarked');
                                    //                                                     //       Navigator.pop(context);
                                    //                                                     //       ScaffoldMessenger.of(context).showSnackBar(
                                    //                                                     //         SnackBar(
                                    //                                                     //             content: Text('बुकमार्क सुरक्षित हो गया',
                                    //                                                     //               style: TextStyle(
                                    //                                                     //                 fontSize:17,
                                    //                                                     //                 color:Colors.white,
                                    //                                                     //               ),
                                    //                                                     //             ),
                                    //                                                     //             action: SnackBarAction(onPressed: () {}, label: 'Close',
                                    //                                                     //               textColor: Colors.white,
                                    //                                                     //             ),
                                    //                                                     //             duration: Duration(seconds: 3)
                                    //                                                     //         ),
                                    //                                                     //       );
                                    //                                                     //     },
                                    //                                                     //     child: Row(
                                    //                                                     //       children: [
                                    //                                                     //         Padding(
                                    //                                                     //             padding: EdgeInsets.symmetric(horizontal: 20),
                                    //                                                     //             child: Icon(Icons.bookmark,size: 25,color:dark == 0 ? Color(0xFF4D555F) : Colors.white,)),
                                    //                                                     //         Text('बुकमार्क करेंं',style: TextStyle(
                                    //                                                     //             color:dark == 0 ? Color(0xFF4D555F) : Colors.white,
                                    //                                                     //             fontSize: 18
                                    //                                                     //         ),)
                                    //                                                     //       ],
                                    //                                                     //     ),
                                    //                                                     //   ),
                                    //                                                     // ),
                                    //                                                   ],
                                    //                                                 ),
                                    //                                               ),
                                    //                                             ),
                                    //                                           ));
                                    //                             },
                                    //                             child: Icon(
                                    //                               Icons.share,
                                    //                               size: 15,
                                    //                               color: !(currentTheme ==
                                    //                                       themeMode
                                    //                                           .darkMode)
                                    //                                   ? Colors
                                    //                                       .red
                                    //                                   : Colors
                                    //                                       .white,
                                    //                             )),
                                    //                         SizedBox(width: 10)
                                    //                         // Container(
                                    //                         //   width: 40,
                                    //                         //   child: DropdownButton<IconData>(
                                    //                         //     isExpanded: true,
                                    //                         //     underline: SizedBox(),
                                    //                         //     icon: Icon(Icons.share,size: 15,color: Colors.red),
                                    //                         //     items: <IconData>[Icons.share, Icons.bookmark].map((IconData value) {
                                    //                         //       return DropdownMenuItem<IconData>(
                                    //                         //         value: value,
                                    //                         //         child: value==Icons.share?
                                    //                         //         Row(
                                    //                         //           children: [
                                    //                         //             Icon(Icons.share),
                                    //                         //             SizedBox(width: 20,),
                                    //                         //             Text('शेयर करें'),
                                    //                         //           ],
                                    //                         //         ):
                                    //                         //         Row(
                                    //                         //           children: [
                                    //                         //             Icon(Icons.bookmark),
                                    //                         //             SizedBox(width: 20,),
                                    //                         //             Text('बुकमार्क करें'),
                                    //                         //           ],
                                    //                         //         ),
                                    //                         //       );
                                    //                         //     }).toList(),
                                    //                         //     onChanged: (newValue) {
                                    //                         //       if((newValue)==Icons.share)
                                    //                         //       {
                                    //                         //         print('it\'s shared');
                                    //                         //         FlutterShare.share(
                                    //                         //             title:
                                    //                         //             "Title",
                                    //                         //             text: homeNewsData[index]["news"][index2]["title"],
                                    //                         //             chooserTitle:
                                    //                         //             "इस खबर को शेयर करो...");
                                    //                         //       }
                                    //                         //       else
                                    //                         //         {
                                    //                         //           print('1');
                                    //                         //           print(homeNewsData[index]["news"][index2]["post_id"]);
                                    //                         //           final item = Favourite(api: 'http://5.161.78.72/api/home_latest_news?take=5&st_id=$hi', id: homeNewsData[index]["news"][index2]["post_id"].toString());
                                    //                         //           print('2');
                                    //                         //           list.items.add(item);
                                    //                         //           storage.setItem('favourite_news', list.toJSONEncodable());
                                    //                         //           favourites.add(P);
                                    //                         //           print('it\'s bookmarked');
                                    //                         //         }
                                    //                         //       ScaffoldMessenger.of(context).showSnackBar(
                                    //                         //         SnackBar(
                                    //                         //             content: Text('बुकमार्क सुरक्षित हो गया',
                                    //                         //               style: TextStyle(
                                    //                         //                   fontSize:17,
                                    //                         //                 color:Colors.white,
                                    //                         //               ),
                                    //                         //             ),
                                    //                         //             action: SnackBarAction(onPressed: () {}, label: 'Close',
                                    //                         //               textColor: Colors.white,
                                    //                         //             ),
                                    //                         //             duration: Duration(seconds: 3)
                                    //                         //         ),
                                    //                         //       );
                                    //                         //     },
                                    //                         //   ),
                                    //                         // )
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           )
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider(
                                      color: Colors.grey.withOpacity(0.7),
                                    );
                                  },
                                ),
                              )
                            : LinearProgressIndicator(
                                color: Colors.blue,
                              );
                      }),
                ],
              ),
            ),
    );
  }
}
