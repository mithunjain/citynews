import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news/data/color_collection.dart';
import 'package:news/data/image_data_collection.dart';
import 'package:news/data/text_collection.dart';
import 'package:news/provider/radio_collection_provider.dart';
import 'package:news/provider/song_management_provider.dart';
import 'package:news/provider/theme_provider.dart';
import 'package:news/type/types.dart';
import 'package:provider/provider.dart';

class RadioDetailsScreen extends StatefulWidget {
  const RadioDetailsScreen({super.key});

  @override
  State<RadioDetailsScreen> createState() => _RadioDetailsScreenState();
}

class _RadioDetailsScreenState extends State<RadioDetailsScreen> {
  bool _isSongPlaying = false;
  int _currentlyPlayingIndex = -1; // -1 means no channel is playing

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();
    return Scaffold(
      backgroundColor: currentTheme == themeMode.lightMode
          ? ColorCollection.pureWhiteColor
          : Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        title: Text(
            Provider.of<RadioCollectionProvider>(context)
                .getCurrentRadioCategoryName()
                .toString(),
            style: TextStyle(color: Colors.white)),
      ),
      body: _radioChannelCollectionSection(),
    );
  }

  _radioChannelCollectionSection() {
    final List radioDetails = Provider.of<RadioCollectionProvider>(context)
        .getCurrentRadioCollectionUnderCurrentRadioCategory();
    log('Current Radio data==>$radioDetails');
    return ListView.builder(
        shrinkWrap: true,
        itemCount: radioDetails.length,
        itemBuilder: (context, int radioListIndex) {
          final _currentRadioChannel = radioDetails[radioListIndex];

          return _particularRadioChannel(_currentRadioChannel, radioListIndex);
        });
  }

  _particularRadioChannel(_currentRadioChannel, int index) {
    final currentTheme = Provider.of<ThemeChanger>(context).getTheme();
    final themeMode = ThemeModeTypes();
    bool isCurrentIndexPlaying = _currentlyPlayingIndex == index;

    return GestureDetector(
      onTap: () async {
        if (isCurrentIndexPlaying) {
          Provider.of<SongManagementProvider>(context, listen: false)
              .stopSong();
          _currentlyPlayingIndex = -1; // Reset playing index
        } else {
          Provider.of<SongManagementProvider>(context, listen: false)
              .audioPlaying(_currentRadioChannel["embed_url"]);
          _currentlyPlayingIndex = index;
        }
        setState(() {});
      },
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 8, left: 10, right: 10, top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isCurrentIndexPlaying
              ? currentTheme == themeMode.lightMode
                  ? Colors.black
                  : Colors.blueGrey
              : currentTheme == themeMode.lightMode
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
                child: isCurrentIndexPlaying
                    ? Lottie.asset(AppAnimations.playRedioIcon1)
                    : ClipRRect(
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
                          color: isCurrentIndexPlaying
                              ? Colors.white
                              : currentTheme == themeMode.lightMode
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
                          isCurrentIndexPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 25,
                          color: Colors.green,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            isCurrentIndexPlaying ? 'Pause' : 'Play',
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
                      // _gifImage(),
                      // _showChannelNameOnRadioPlay(currentRadioChannel["title"]),
                      // _closeButton(),
                      // _instruction(),
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
