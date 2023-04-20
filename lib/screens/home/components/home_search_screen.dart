import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class HomeSearchScreen extends StatefulWidget {
  static String routeName = 'homeSearchScreen';

  const HomeSearchScreen({Key? key}) : super(key: key);

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      final provider = Provider.of<MusicProvider>(context, listen: false);
      if (searchController.text.isNotEmpty) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 100), () {
          provider.searchedMusic(searchController.text);
        });
      } else {
        provider.searchedMusics.clear();

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicProvider>(context);
    debugPrint(provider.searchedMusics.length.toString());
    List<Music> searchedMusicsList = [];
    if (provider.searchedMusics.isNotEmpty) {
      for (int i = 0; i < provider.searchedMusics.length; i++) {
        searchedMusicsList.add(provider.searchedMusics[i]);
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'assets/images/logo.png',
          ),
          fit: BoxFit.contain,
        )),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.85),
                      Colors.black.withOpacity(0.45),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        BackButton(
                          color: kSecondaryColor,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                            child: _buildSearchBar(
                                context, 'Search for music title',provider)),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: provider.searchedMusics.isEmpty
                        ? const Center(
                            child: Text(
                            'No Music',
                            style: TextStyle(color: kGrey),
                          ))
                        : ListView.builder(
                            itemCount: provider.searchedMusics.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return MusicListCard(
                                music: provider.searchedMusics[index],
                                musics: searchedMusicsList,
                                musicIndex: index,
                              );
                            }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, hint,MusicProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: searchController,
        style: const TextStyle(color: kGrey),

        cursorColor: kSecondaryColor,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(color: kGrey),
            prefixIcon: const Icon(
              Icons.search,
              color: kSecondaryColor,
            )),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
