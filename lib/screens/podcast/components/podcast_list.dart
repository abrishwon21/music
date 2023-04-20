import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_card.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PodcastList extends StatelessWidget {
  List<PodCast> podcasts;

  PodcastList({Key? key, required this.podcasts}) : super(key: key);
  static String routeName = 'podcastName';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          leading: BackButton(color: kSecondaryColor,onPressed: (){Navigator.pop(context);},),
          title: const Text('Podcast',style: TextStyle(color: kSecondaryColor),),
          backgroundColor: Colors.transparent,
        ),
        body: GridView.builder(
            itemCount: podcasts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: getProportionateScreenWidth(10)),
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(35),
                vertical: getProportionateScreenHeight(25)),
            itemBuilder: (context, index) {
              return PodcastCard(podcast: podcasts[index], podcasts: podcasts);
            }));
  }
}
