import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news/data/image_data_collection.dart';
import 'package:news/dynamic_link.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/type/types.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class NewsDetailsContainer extends StatelessWidget {
  final dynamic newsData;
  final bool isFromSearch;

  const NewsDetailsContainer(
      {super.key, this.newsData, this.isFromSearch = false});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();
    var height = mq.height;
    var width = mq.width;
    return Container(
      height: 115,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: !(currentTheme == themeMode.darkMode)
            ? Colors.white
            : Colors.white10,
        borderRadius: BorderRadius.circular(5),
        // boxShadow: [
        //   BoxShadow(
        //       offset: Offset(3, 3),
        //       color: Colors.black12,
        //       spreadRadius: 0.05)
        // ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 2),
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      readNews.contains(newsData["title"].toString())
                          ? AutoSizeText(
                              newsData["title"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !(currentTheme == themeMode.darkMode)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              textScaleFactor: 1.0,
                              maxLines: 3,
                              minFontSize: 16,
                              overflow: TextOverflow.ellipsis,
                            )
                          : AutoSizeText(
                              newsData["title"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !(currentTheme == themeMode.darkMode)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              textScaleFactor: 1.0,

                              maxLines: 3,
                              minFontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              // maxFontSize: 29,
                            ),

                      // heading(
                      //     text: homeNewsData[index]
                      //         ["news"][newsIndex]["title"],
                      //     maxLines: 3,
                      //     scale: 1.25,
                      //     weight: FontWeight.w800,
                      //     align: TextAlign.left),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 70,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: newsData["main_image_thumb"].toString(),
                          placeholder: (context, url) =>
                              Image.asset(ImageDataCollection.appIcon),
                          errorWidget: (context, url, error) =>
                              Image.asset(ImageDataCollection.appIcon),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  textScaleFactor: 1.0,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text:isFromSearch?newsData['source']: newsData["source_website"],
                    style: TextStyle(
                      fontSize: 11,
                      color: !(currentTheme == themeMode.darkMode)
                          ? Colors.black54
                          : Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' | ',
                          style: TextStyle(
                              color: !(currentTheme == themeMode.darkMode)
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:isFromSearch?newsData['time'].toString():  newsData["imported_date"].toString(),
                          style: TextStyle(color: Colors.blue))
                    ],
                  ),
                ),
                // Container(
                //   width: 40,
                //   child: DropdownButton<IconData>(
                //     isExpanded: true,
                //     underline: SizedBox(),
                //     icon: Icon(Icons.share,
                //         size: 15, color: Colors.red),
                //     items: <IconData>[
                //       Icons.share,
                //       Icons.bookmark
                //     ].map((IconData value) {
                //       return DropdownMenuItem<IconData>(
                //         value: value,
                //         child: value == Icons.share
                //             ? Row(
                //                 children: [
                //                   Icon(Icons.share),
                //                   SizedBox(
                //                     width: 20,
                //                   ),
                //                   Text('शेयर करें'),
                //                 ],
                //               )
                //             : Row(
                //                 children: [
                //                   Icon(Icons.bookmark),
                //                   SizedBox(
                //                     width: 20,
                //                   ),
                //                   Text('बुकमार्क करें'),
                //                 ],
                //               ),
                //       );
                //     }).toList(),
                //     onChanged: (newValue) {
                //       if ((newValue) == Icons.share) {
                //         print('it\'s shared');
                //         FlutterShare.share(
                //             title: "Title",
                //             text: homeNewsData[index]["news"]
                //                 [newsIndex]["title"],
                //             chooserTitle:
                //                 "इस खबर को शेयर करो...");
                //       } else {
                //         print('1');
                //         print(homeNewsData[index]["news"]
                //             [newsIndex]["post_id"]);
                //         final item = Favourite(
                //             // api:
                //             //     'http://5.161.78.72/api/home_latest_news?take=5&st_id=$hi',
                //             id: homeNewsData[index]["news"]
                //                     [newsIndex]["post_id"]
                //                 .toString(), data: homeNewsData[index]["news"]
                //                     [newsIndex]);
                //         print('2');
                //         list.items.add(item);
                //         storage.setItem('favourite_news',
                //             list.toJSONEncodable());
                //         // favourites.add(P);
                //         print('it\'s bookmarked');
                //       }
                //       ScaffoldMessenger.of(context)
                //           .showSnackBar(
                //         SnackBar(
                //             content: Text(
                //               'बुकमार्क सुरक्षित हो गया',
                //               style: TextStyle(
                //                 fontSize: 17,
                //                 color: Colors.white,
                //               ),
                //             ),
                //             action: SnackBarAction(
                //               onPressed: () {},
                //               label: 'Close',
                //               textColor: Colors.white,
                //             ),
                //             duration: Duration(seconds: 3)),
                //       );
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Row(
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.bookmark_border,
                          size: 20,
                          color: !(currentTheme == themeMode.darkMode)
                              ? Colors.black54
                              : Colors.white,
                        ),
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        color:
                                            (currentTheme == themeMode.darkMode)
                                                ? Color(0xFF4D555F)
                                                : Colors.white,
                                        height: 200,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 20, 10, 10),
                                              child: Center(
                                                child: Text(
                                                  newsData["title"],
                                                  style: TextStyle(
                                                      color: !(currentTheme ==
                                                              themeMode
                                                                  .darkMode)
                                                          ? Color(0xFF4D555F)
                                                          : Colors.white,
                                                      fontSize: 19),
                                                ),
                                              ),
                                            ),
                                            // Expanded(
                                            //   child:
                                            //       TextButton(
                                            //     onPressed:
                                            //         () async {
                                            //       final tempMap =
                                            //           homeNewsData[index]["news"]
                                            //               [
                                            //               newsIndex];

                                            //       tempMap['main_image_cropped'] =
                                            //           '';

                                            //       final newsData =
                                            //           {
                                            //         "newsTitle":
                                            //             homeNewsData[index]["news"][newsIndex]
                                            //                 [
                                            //                 "title"],
                                            //         "newsURL":
                                            //             homeNewsData[index]["news"][newsIndex]
                                            //                 [
                                            //                 "imported_news_url"],
                                            //         "data":
                                            //             tempMap
                                            //       };
                                            //       //! adding logic for dynamic url

                                            //       String url =
                                            //           '';
                                            //       await generateUrl(
                                            //               newsData)
                                            //           .then((value) =>
                                            //               {
                                            //                 url = value,
                                            //               });

                                            //       print(
                                            //           "Url is:${url} ");

                                            //       final title =
                                            //           "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" +
                                            //               Uri.parse(url).toString();
                                            //       Share.share(
                                            //           title);
                                            //       print(
                                            //           'it\'s shared');
                                            //       //FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳");
                                            //       //FlutterShare.share(title: "hellllloooo", text: "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳              " + homeNewsData[index]["news"][newsIndex]["title"], linkUrl: url, chooserTitle: "इस खबर को शेयर करो...");
                                            //       Navigator.pop(
                                            //           context);
                                            //       // print('it\'s shared');
                                            //       // FlutterShare.share(title: "Title", text: homeNewsData[index]["news"][newsIndex]["title"], chooserTitle: "इस खबर को शेयर करो...");
                                            //       // Navigator.pop(context);
                                            //     },
                                            //     child: Row(
                                            //       children: [
                                            //         Padding(
                                            //             padding: EdgeInsets.symmetric(
                                            //                 horizontal:
                                            //                     20),
                                            //             child:
                                            //                 Icon(
                                            //               Icons.share,
                                            //               size:
                                            //                   25,
                                            //               color: !(currentTheme == themeMode.darkMode)
                                            //                   ? Color(0xFF4D555F)
                                            //                   : Colors.white,
                                            //             )),
                                            //         Text(
                                            //           'शेयर करें',
                                            //           style: TextStyle(
                                            //               color: !(currentTheme == themeMode.darkMode)
                                            //                   ? Color(0xFF4D555F)
                                            //                   : Colors.white,
                                            //               fontSize: 18),
                                            //         )
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () {
                                                  bool alreadyThere = false;
                                                  for (var i = 0;
                                                      i < list.items.length;
                                                      i++) {
                                                    if (newsData["post_id"]
                                                            .toString() ==
                                                        list.items[i].id) {
                                                      alreadyThere = true;
                                                    }
                                                  }
                                                  if (alreadyThere == false) {
                                                    print(newsData["post_id"]);
                                                    final item = Favourite(
                                                        id: newsData["post_id"]
                                                            .toString(),
                                                        data: newsData);
                                                    list.items.add(item);
                                                    storage.setItem(
                                                        'favourite_news',
                                                        list.toJSONEncodable());
                                                  }

                                                  print('it\'s bookmarked');
                                                  Navigator.of(context).pop();

                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'बुकमार्क सुरक्षित हो गया');
                                                  // ScaffoldMessenger.of((widget
                                                  //         .scaffoldKey
                                                  //         .currentState
                                                  //         ?.context)!)
                                                  //     .showSnackBar(
                                                  //   SnackBar(
                                                  //       content:
                                                  //           Text(
                                                  //         'बुकमार्क सुरक्षित हो गया',
                                                  //         style:
                                                  //             TextStyle(
                                                  //           fontSize: 17,
                                                  //           color: Colors.white,
                                                  //         ),
                                                  //       ),
                                                  //       action:
                                                  //           SnackBarAction(
                                                  //         onPressed:
                                                  //             () {},
                                                  //         label:
                                                  //             'Close',
                                                  //         textColor:
                                                  //             Colors.white,
                                                  //       ),
                                                  //       duration:
                                                  //           Duration(seconds: 3)),
                                                  // );
                                                },
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        child: Icon(
                                                          Icons.bookmark,
                                                          size: 25,
                                                          color: !(currentTheme ==
                                                                  themeMode
                                                                      .darkMode)
                                                              ? Color(
                                                                  0xFF4D555F)
                                                              : Colors.white,
                                                        )),
                                                    Text(
                                                      'बुकमार्क करेंं',
                                                      style: TextStyle(
                                                          color: !(currentTheme ==
                                                                  themeMode
                                                                      .darkMode)
                                                              ? Color(
                                                                  0xFF4D555F)
                                                              : Colors.white,
                                                          fontSize: 18),
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
                      ),
                      SizedBox(width: 10),
                      InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          color: (currentTheme ==
                                                  themeMode.darkMode)
                                              ? Color(0xFF4D555F)
                                              : Colors.white,
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 20, 10, 10),
                                                child: Center(
                                                  child: Text(
                                                    newsData["title"],
                                                    style: TextStyle(
                                                        color: !(currentTheme ==
                                                                themeMode
                                                                    .darkMode)
                                                            ? Color(0xFF4D555F)
                                                            : Colors.white,
                                                        fontSize: 19),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () async {
                                                    final tempMap = newsData;

                                                    tempMap['main_image_cropped'] =
                                                        '';

                                                    final shareNewsData = {
                                                      "newsTitle":
                                                          newsData["title"],
                                                      "newsURL": newsData[
                                                          "imported_news_url"],
                                                      "data": tempMap
                                                    };
                                                    //! adding logic for dynamic url

                                                    String url = '';
                                                    await generateUrl(
                                                            shareNewsData)
                                                        .then((value) => {
                                                              url = value,
                                                            });

                                                    print("Url is:${url} ");

                                                    final title =
                                                        "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" +
                                                            Uri.parse(url)
                                                                .toString();
                                                    Share.share(title);
                                                    print('it\'s shared');
                                                    //FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳");
                                                    //FlutterShare.share(title: "hellllloooo", text: "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳              " + homeNewsData[index]["news"][newsIndex]["title"], linkUrl: url, chooserTitle: "इस खबर को शेयर करो...");
                                                    Navigator.pop(context);
                                                    // print('it\'s shared');
                                                    // FlutterShare.share(title: "Title", text: homeNewsData[index]["news"][newsIndex]["title"], chooserTitle: "इस खबर को शेयर करो...");
                                                    // Navigator.pop(context);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Icon(
                                                            Icons.share,
                                                            size: 25,
                                                            color: !(currentTheme ==
                                                                    themeMode
                                                                        .darkMode)
                                                                ? Color(
                                                                    0xFF4D555F)
                                                                : Colors.white,
                                                          )),
                                                      Text(
                                                        'शेयर करें',
                                                        style: TextStyle(
                                                            color: !(currentTheme ==
                                                                    themeMode
                                                                        .darkMode)
                                                                ? Color(
                                                                    0xFF4D555F)
                                                                : Colors.white,
                                                            fontSize: 18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Expanded(
                                              //   child:
                                              //       TextButton(
                                              //     onPressed:
                                              //         () {
                                              //       bool
                                              //           alreadyThere =
                                              //           false;
                                              //       for (var i =
                                              //               0;
                                              //           i < list.items.length;
                                              //           i++) {
                                              //         if (homeNewsData[index]["news"][newsIndex]["post_id"].toString() ==
                                              //             list.items[i].id) {
                                              //           alreadyThere =
                                              //               true;
                                              //         }
                                              //       }
                                              //       if (alreadyThere ==
                                              //           false) {
                                              //         print(homeNewsData[index]["news"][newsIndex]
                                              //             [
                                              //             "post_id"]);
                                              //         final item = Favourite(
                                              //             id: homeNewsData[index]["news"][newsIndex]["post_id"]
                                              //                 .toString(),
                                              //             data:
                                              //                 homeNewsData[index]["news"][newsIndex]);
                                              //         list.items
                                              //             .add(item);
                                              //         storage.setItem(
                                              //             'favourite_news',
                                              //             list.toJSONEncodable());
                                              //       }

                                              //       print(
                                              //           'it\'s bookmarked');
                                              //       Navigator.pop(
                                              //           context);
                                              //       ScaffoldMessenger.of((widget
                                              //               .scaffoldKey
                                              //               .currentState
                                              //               ?.context)!)
                                              //           .showSnackBar(
                                              //         SnackBar(
                                              //             content:
                                              //                 Text(
                                              //               'बुकमार्क सुरक्षित हो गया',
                                              //               style: TextStyle(
                                              //                 fontSize: 17,
                                              //                 color: Colors.white,
                                              //               ),
                                              //             ),
                                              //             action:
                                              //                 SnackBarAction(
                                              //               onPressed: () {},
                                              //               label: 'Close',
                                              //               textColor: Colors.white,
                                              //             ),
                                              //             duration:
                                              //                 Duration(seconds: 3)),
                                              //       );
                                              //     },
                                              //     child: Row(
                                              //       children: [
                                              //         Padding(
                                              //             padding:
                                              //                 EdgeInsets.symmetric(horizontal: 20),
                                              //             child: Icon(
                                              //               Icons.bookmark,
                                              //               size: 25,
                                              //               color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                              //             )),
                                              //         Text(
                                              //           'बुकमार्क करेंं',
                                              //           style: TextStyle(
                                              //               color: !(currentTheme == themeMode.darkMode) ? Color(0xFF4D555F) : Colors.white,
                                              //               fontSize: 18),
                                              //         )
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                          child: Icon(
                            Icons.share,
                            size: 20,
                            color: !(currentTheme == themeMode.darkMode)
                                ? Colors.black54
                                : Colors.white,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
