import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/api_collection/api_caller.dart';
import 'package:news/data/color_collection.dart';
import 'package:news/data/common_top_scroller.dart';
import 'package:news/data/image_data_collection.dart';
import 'package:news/data/text_collection.dart';
import 'package:news/provider/radio_collection_provider.dart';
import 'package:news/provider/song_management_provider.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/screens/radio/radio_details_screen.dart';
import 'package:news/screens/radio/sub_screen_scrollManagement.dart';
import 'package:news/type/types.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  _RadioScreenState createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final APIManager _apiManager = APIManager();

  ScrollController topbarCoontroller = ScrollController();

  @override
  void initState() {
    WakelockPlus.enable();
    Provider.of<SubScrollManagement>(context, listen: false).startListening();
    Provider.of<RadioCollectionProvider>(context, listen: false).initialize();
    super.initState();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();
    return WillPopScope(
      onWillPop: () async {
        Provider.of<RadioCollectionProvider>(context, listen: false)
            .makeItToInitial();

        return true;
      },
      child: Scaffold(
        backgroundColor: currentTheme == themeMode.lightMode
            ? ColorCollection.pureWhiteColor
            : Colors.black,
        // appBar: AppBar(
        //   iconTheme: IconThemeData(color: Colors.white),
        //   backgroundColor: ColorCollection.lightModeAppBarColor,
        //   elevation: 0,
        //   title: const Text(AppTextDataCollection.radioAppBarText,
        //       style: TextStyle(color: Colors.white)),
        // ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _radioCategorySection(),
        ),
      ),
    );
  }

//Listview as a tab  of all radio categories

  // _radioCategorySection() {
  //   _changeRadioCategoryOnTap(categoryIndex) {
  //     double itemWidth = MediaQuery.of(context).size.width * 0.2;

  //     // Calculate position to scroll to: center the selected tab
  //     double scrollToPosition = itemWidth * categoryIndex -
  //         (MediaQuery.of(context).size.width / 2) +
  //         (itemWidth / 2);

  //     // Ensure the calculated position does not scroll out of bounds
  //     scrollToPosition = scrollToPosition < 0 ? 0 : scrollToPosition;
  //     scrollToPosition =
  //         scrollToPosition > topbarCoontroller.position.maxScrollExtent
  //             ? topbarCoontroller.position.maxScrollExtent
  //             : scrollToPosition;

  //     // Animate the scroll view to the new position
  //     topbarCoontroller.animateTo(
  //       scrollToPosition,
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //     );

  //     Provider.of<RadioCollectionProvider>(context, listen: false)
  //         .setSelectedRadioCategory(categoryIndex);

  //     _pageController.animateToPage(categoryIndex,
  //         duration: const Duration(milliseconds: 500),
  //         curve: Curves.fastOutSlowIn);
  //   }

  //   final _radioCategoriesNameCollection =
  //       Provider.of<RadioCollectionProvider>(context).getAllRadioCategories();

  //   final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
  //   final themeMode = ThemeModeTypes();

  //   _itemBuilder(context, int categoryIndex) {
  //     final _currentRadioCategoryIndex =
  //         Provider.of<RadioCollectionProvider>(context)
  //             .getCurrentRadioCollectionIndex();

  //     return GestureDetector(
  //       onTap: () => _changeRadioCategoryOnTap(categoryIndex),
  //       child: Padding(
  //         padding: const EdgeInsets.only(left: 8, right: 8),
  //         child: Container(
  //           // width: MediaQuery.of(context).size.width * 0.25,
  //           color: ColorCollection.lightModeAppBarColor,

  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(bottom: 5),
  //                 child: Text(
  //                   "${_radioCategoriesNameCollection[categoryIndex]}",
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       color: _currentRadioCategoryIndex == categoryIndex
  //                           ? Colors.white
  //                           : Colors.grey),
  //                 ),
  //               ),
  //               if (_currentRadioCategoryIndex == categoryIndex)
  //                 Container(height: 2, width: 30, color: Colors.orange)
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5),
  //     child: SizedBox(
  //       height: MediaQuery.of(context).size.height * 0.04,
  //       child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         controller: topbarCoontroller,
  //         itemCount: Provider.of<RadioCollectionProvider>(context)
  //             .getTotalRadioCategoriesLength(),
  //         itemBuilder: (context, index) {
  //           return _itemBuilder(context, index);
  //         },
  //       ),
  //     ),
  //   );
  // }

//gridview of all radio categories
  _radioCategorySection() {
    final List _radioCategoriesNameCollection =
        Provider.of<RadioCollectionProvider>(context).getAllRadioCategories();
    final _radioCategoriesImageCollection =
        Provider.of<RadioCollectionProvider>(context, listen: false)
            .getAllRadioCategoriesImages();
    log('radio images==>$_radioCategoriesImageCollection');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.96, // Adjust based on content and layout
        ),
        itemCount: _radioCategoriesNameCollection.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Provider.of<RadioCollectionProvider>(context, listen: false)
                  .setSelectedRadioCategory(index);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return RadioDetailsScreen();
                },
              ));
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: CachedNetworkImage(
                          imageUrl:
                              _radioCategoriesImageCollection[index].toString(),
                          placeholder: (context, url) => ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: Image.asset(
                                ImageDataCollection.radio,
                                fit: BoxFit.fill,
                              )),
                          errorWidget: (context, url, error) => ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: Image.asset(
                                ImageDataCollection.radio,
                                fit: BoxFit.fill,
                              )),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 4),
                    child: Text(
                      "${_radioCategoriesNameCollection[index]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _radioChannelCollectionSection() {
    final ScrollController _mainScrollController =
        Provider.of<SubScrollManagement>(context).getScrollController();

    _onPageChanged(incomingPageIndex) {
      Provider.of<RadioCollectionProvider>(context, listen: false)
          .setSelectedRadioCategory(incomingPageIndex);
    }

    _pageViewItemBuilder(_context, int pageIndex) {
      return ListView.builder(
          shrinkWrap: true,
          controller: _mainScrollController,
          itemCount: Provider.of<RadioCollectionProvider>(_context)
              .getLengthOfTotalRadiosUnderCurrentRadioCategory(),
          itemBuilder: (context, int radioListIndex) {
            final _currentRadioChannel =
                Provider.of<RadioCollectionProvider>(context)
                        .getCurrentRadioCollectionUnderCurrentRadioCategory()[
                    radioListIndex];

            return _particularRadioChannel(_currentRadioChannel);
          });
    }

    return Container(
      height: MediaQuery.of(context).size.height - 132,
      margin: const EdgeInsets.only(top: 5),
      child: commonHorizontalPagination(
          pageController: _pageController,
          onPageChanged: _onPageChanged,
          pageViewItemCount: Provider.of<RadioCollectionProvider>(context)
              .getTotalRadioCategoriesLength(),
          pageViewItemBuilder: _pageViewItemBuilder),
    );
  }

  _particularRadioChannel(_currentRadioChannel) {
    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();

    return InkWell(
      onTap: () async {
        Provider.of<SongManagementProvider>(context, listen: false)
            .audioPlaying(_currentRadioChannel["embed_url"]);

        _showLiveRadio(_currentRadioChannel);
      },
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentTheme == themeMode.lightMode
              ? ColorCollection.pureWhiteColor
              : ColorCollection.radioTileColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Container(
                height: 60,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: _currentRadioChannel[
                              AppTextDataCollection.radioChannelLogo]
                          .toString(),
                      placeholder: (context, url) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            ImageDataCollection.radio,
                            fit: BoxFit.fill,
                          )),
                      errorWidget: (context, url, error) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            ImageDataCollection.radio,
                            fit: BoxFit.fill,
                          )),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              // This makes sure the remaining content takes all the available space
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _currentRadioChannel[
                            AppTextDataCollection.radioChannelTitle],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: currentTheme == themeMode.lightMode
                              ? ColorCollection.pureBlackColor
                              : ColorCollection.pureWhiteColor,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min, // Use only needed space
                      children: [
                        Icon(
                          Icons.play_circle_filled_outlined,
                          size: 25,
                          color: Colors.green,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            'PLAY',
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLiveRadio(currentRadioChannel) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white70,
        builder: (_) => WillPopScope(
              onWillPop: () async {
                final _isSongPlaying =
                    Provider.of<SongManagementProvider>(context, listen: false)
                        .isSongPlaying();

                if (_isSongPlaying) {
                  Provider.of<SongManagementProvider>(context, listen: false)
                      .stopSong();
                }

                return true;
              },
              child: Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Column(
                    children: [
                      _gifImage(),
                      _showChannelNameOnRadioPlay(currentRadioChannel["title"]),
                      _closeButton(),
                      _instruction(),
                    ],
                  )),
            ));
  }

  _gifImage() => Image.asset("images/radio-player.gif");

  _showChannelNameOnRadioPlay(channelName) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Text(
            channelName,
            style: TextStyle(
                color: ColorCollection.tabSelectedColor,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
      );

  _closeButton() => Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Center(
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8)),
            child: Text(
              "Close",
              style: TextStyle(
                  color: ColorCollection.tileLightModeColor, fontSize: 18),
            ),
            onPressed: () {
              Provider.of<SongManagementProvider>(context, listen: false)
                  .stopSong();

              Navigator.pop(context);
            },
          ),
        ),
      );

  _instruction() => const Center(
        child: Text(
            "Please wait around 20 sec if radio is not playing instantly",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center),
      );
}
// class RadioScreen extends StatefulWidget {
//   @override
//   _RadioScreenState createState() => _RadioScreenState();
// }

// class _RadioScreenState extends State<RadioScreen> {
//   int selectedIndex = 0;
//   int playingIndex = -1;
//   String currentChannel = "";
//   ScrollController topBarController = new ScrollController();
//   bool isLoading = false;

//   late BannerAd _bannerAd;
//   bool _isBannerAdReady = false;

//   PageController _controller = PageController(
//     initialPage: 0,
//   );

//   var radioData;

//   Future<dynamic> getRadioData() async {
//     isLoading = true;
//     String fileName = 'getRadioData.json';
//     var dir = await getTemporaryDirectory();

//     File file = File(dir.path + "/" + fileName);

//     if (file.existsSync()) {
//       print("reading from cache");

//       final data = file.readAsStringSync();
//       final res = jsonDecode(data);
//       setState(() {
//         radioData = res;
//         // isLoading = true;
//       });
//     } else {
//       isLoading = true;
//       print("reading from internet");
//       var request = http.Request(
//         'GET',
//         Uri.parse('http://5.161.78.72/api/get_category_radio'),
//       );

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         final body = await response.stream.bytesToString();

//         file.writeAsStringSync(body, flush: true, mode: FileMode.write);
//         final res = jsonDecode(body);
//         setState(() {
//           radioData = res;
//           isLoading = false;
//         });
//       } else {}
//     }
//     try {
//       isLoading = true;
//       final result = await InternetAddress.lookup('www.google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         print('connected');
//         String fileName = 'getRadioData.json';
//         var dir = await getTemporaryDirectory();
//         File file = File(dir.path + "/" + fileName);
//         print("reading from internet");
//         final url = "http://5.161.78.72/api/get_category_radio";
//         final req = await http.get(Uri.parse(url));

//         if (req.statusCode == 200) {
//           final body = req.body;

//           file.writeAsStringSync(body, flush: true, mode: FileMode.write);
//           final res = jsonDecode(body);
//           setState(() {
//             radioData = res;
//             isLoading = false;
//           });
//         } else {}
//       }
//     } on SocketException catch (_) {
//       print('not connected');
//     }

//     log(radioData.runtimeType.toString());
//   }

//   @override
//   void initState() {
//     super.initState();
//     Wakelock.enable();
//     getRadioData();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     Wakelock.disable();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
//     final themeMode = ThemeModeTypes();

//     _bannerAd = BannerAd(
//       // Change Banner Size According to Ur Need
//       size: AdSize(
//           width: MediaQuery.of(context).size.width.truncate(), height: 60),
//       adUnitId: AdHelper.bannerAdUnitId,
//       listener: BannerAdListener(onAdLoaded: (_) {
//         setState(() {
//           _isBannerAdReady = true;
//         });
//       }, onAdFailedToLoad: (ad, LoadAdError error) {
//         print("Failed to Load A Banner Ad${error.message}");
//         _isBannerAdReady = false;
//         ad.dispose();
//       }),
//       request: AdRequest(),
//     )..load();

//     var mq = MediaQuery.of(context).size;
//     var height = mq.height;
//     var width = mq.width;
//     return Scaffold(
//       backgroundColor: !(currentTheme == themeMode.darkMode)
//           ? Colors.white
//           : Color(0xFF262E39),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(40.0),
//         child: AppBar(
//           title: Text('Radio FM'),
//           backgroundColor: Colors.blue[900],
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) {
//                     return HomeScreen();
//                   }),
//                 );
//               },
//               icon: Icon(Icons.arrow_back)),
//         ),
//       ),
//       body: Column(
//         children: [
//           if (_isBannerAdReady)
//             Container(
//               height: 60,
//               width: MediaQuery.of(context).size.width,
//               child: AdWidget(ad: _bannerAd),
//             ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0, bottom: 10),
//             child: Container(
//               height: height * 0.03,
//               child: isLoading
//                   ? SizedBox()
//                   : ListView.builder(
//                       itemCount: radioData.length,
//                       controller: topBarController,
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, int index) {
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _controller.animateToPage(index,
//                                   duration: Duration(milliseconds: 500),
//                                   curve: Curves.easeIn);
//                             });
//                           },
//                           child: Container(
//                             width: width * 0.25,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                     child: heading(
//                                   color: currentTheme == themeMode.darkMode
//                                       ? Colors.white
//                                       : Colors.black,
//                                   text: radioData[index]["category"]["title"],
//                                 )),
//                                 Container(
//                                     height: 2,
//                                     color: selectedIndex == index
//                                         ? Colors.blue
//                                         : Colors.transparent)
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? SizedBox()
//                 : PageView.builder(
//                     controller: _controller,
//                     itemCount: radioData.length,
//                     onPageChanged: (value) {
//                       if (selectedIndex < value) {
//                         topBarController.animateTo(
//                             topBarController.offset + width * 0.15,
//                             duration: Duration(milliseconds: 100),
//                             curve: Curves.easeIn);
//                         setState(() {
//                           selectedIndex = value;
//                         });
//                       } else if (selectedIndex > value) {
//                         topBarController.animateTo(
//                           topBarController.offset - width * 0.15,
//                           duration: Duration(milliseconds: 100),
//                           curve: Curves.easeIn,
//                         );
//                         setState(() {
//                           selectedIndex = value;
//                         });
//                       }
//                     },
//                     itemBuilder: (context, int pageindex) {
//                       return isLoading
//                           ? SizedBox()
//                           : ListView.builder(
//                               itemCount: radioData[pageindex]["radios"].length,
//                               itemBuilder: (context, int radiolistindex) {
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 15, vertical: 10),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         currentChannel = radioData[pageindex]
//                                                 ["radios"][radiolistindex]
//                                             ["embed_url"];
//                                         playingIndex = radiolistindex;
//                                       });
//                                       _showModal(radioData[pageindex]["radios"]
//                                           [radiolistindex]["title"]);
//                                       // showModalBottomSheet(
//                                       //    context: context,
//                                       //    builder: (BuildContext context) =>
//                                       //        RadioPlayer(embedUrl: currentChannel));
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                           color: !(currentTheme ==
//                                                   themeMode.darkMode)
//                                               ? Colors.white
//                                               : Color(0xFF3E4651),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 offset: Offset(0, 2),
//                                                 color: Colors.black12,
//                                                 spreadRadius: 0.8,
//                                                 blurRadius: 1)
//                                           ]),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               CachedNetworkImage(
//                                                   imageUrl: radioData[pageindex]
//                                                           ["radios"]
//                                                       [radiolistindex]["logo"]),
//                                               SizedBox(width: width * 0.03),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 0,
//                                                         vertical: 15),
//                                                 child: heading(
//                                                     text: radioData[pageindex]
//                                                                 ["radios"]
//                                                             [radiolistindex]
//                                                         ["title"],
//                                                     scale: 1.3,
//                                                     weight: FontWeight.w600),
//                                               ),
//                                             ],
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 right: 10.0),
//                                             child: playingIndex ==
//                                                     radiolistindex
//                                                 ? Icon(
//                                                     Icons.pause_circle_filled,
//                                                     size: height * 0.04,
//                                                     color: Colors.blue,
//                                                   )
//                                                 : Icon(
//                                                     Icons
//                                                         .play_circle_filled_outlined,
//                                                     size: height * 0.04,
//                                                     color: Colors.green,
//                                                   ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               });
//                     }),
//           )
//         ],
//       ),
//     );
//   }

//   void _showModal(String name) {
//     Future<void> future = showModalBottomSheet<void>(
//         context: context,
//         builder: (BuildContext context) => RadioPlayer(
//               embedUrl: currentChannel,
//               channelName: name,
//             ));
//     future.then((void value) => _closeModal(value));
//   }

//   void _closeModal(void value) {
//     setState(() {
//       playingIndex = -1;
//     });
//   }
// }
