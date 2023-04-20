import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/grid_card.dart';
import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/components/section_title.dart';
import 'package:kin_music_player_app/screens/artist/components/popular_tracks.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/size_config.dart';

import '../../../constants.dart';
import 'artist_album.dart';

class ArtistDetail extends StatelessWidget {
  static String routeName = '/artistBody';
  final Artist artist;

  const ArtistDetail({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Container(
          decoration:  BoxDecoration(

              image: DecorationImage(
                  image: CachedNetworkImageProvider('$apiUrl/${artist.cover}'),
                  fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(
              color: kPrimaryColor.withOpacity(0.6),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _buildHeader(),
                        SizedBox(height: getProportionateScreenHeight(15),),
                        _buildPopularAlbum(context),
                        SizedBox(
                          height: getProportionateScreenHeight(25),
                        ),
                        _buildTrackList(context),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: CircleAvatar(
                      backgroundColor: kPrimaryColor.withOpacity(0.5),
                      child: BackButton(
                        color: kSecondaryColor,

                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
        height: getProportionateScreenWidth(225),
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider('$apiUrl/${artist.cover}'),
                fit: BoxFit.cover)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(50),
                  ),
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider('$apiUrl/${artist.cover}'),
                    maxRadius: getProportionateScreenHeight(60),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Text(
                    artist.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${artist.albums!.length.toString()} albums",
                        style:  TextStyle(
                            color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: getProportionateScreenWidth(10)),
                      Text(
                        '${artist.musics.length.toString()} tracks',
                        style:  TextStyle(
                            color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildPopularAlbum(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: "Popular Albums",
              press: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ArtistAlbum(
                          albums: artist.albums!,
                      artistCover: artist.cover
                        )));
              }),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: SizedBox(
              height: getProportionateScreenHeight(225),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,

                  itemCount:
                      artist.albums!.length > 5 ? 5 : artist.albums!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding:  EdgeInsets.only(left: getProportionateScreenWidth(20)),
                        child: GridCard(album: artist.albums![index]));
                  }),
            ))
      ],
    );
  }

  Widget _buildTrackList(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: "Popular Tracks",
              press: () {

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PopularTracks(
                          artist: artist,

                        )));
              }),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        ListView.builder(

          itemCount: artist.musics.length > 6 ? 6 : artist.musics.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return MusicListCard(music: artist.musics[index],musics: artist.musics,musicIndex: index,);
          },
        )]);


  }
}
