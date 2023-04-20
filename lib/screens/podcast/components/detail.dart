import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_detail.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';

import '../../../constants.dart';
import 'episodes_list.dart';

class Detail extends StatelessWidget {
  final PodCast podCast;



  const Detail({Key? key, required this.podCast,}) : super(key: key);
  static String routeName = 'detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool isInnerBoxScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: kPrimaryColor,
                  elevation: 2,
                  leading: BackButton(color: kSecondaryColor,onPressed: (){Navigator.pop(context);},),
                  title: Text(podCast.title,style: const TextStyle(color: kSecondaryColor),),
                  bottom:  PreferredSize(
                    preferredSize: const  Size(double.infinity, 75),
                    child: TabBar(
                      indicatorColor: Colors.white.withOpacity(0.65),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                      // unselectedLabelStyle: TextStyle(fontSize: 13),
                      labelColor: kSecondaryColor,
                      unselectedLabelColor: Colors.white.withOpacity(0.65),
                      tabs: const [
                        Tab(
                          text: 'Detail',
                        ),
                        Tab(text: 'Episodes'),
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                            imageUrl: '$apiUrl/${podCast.cover}',fit: BoxFit.cover,),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                kPrimaryColor.withOpacity(0.75),
                                kPrimaryColor.withOpacity(0.75),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
            body:
                 TabBarView(children: [PodcastDetail(podCast:podCast), EpisodesList(podCast:podCast)])),
      ),
    );
  }
}
