import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/screens/podcast/components/detail.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class NewPodcasts extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodCastProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: const Text(
            'New Podcast',
            style: TextStyle(
              fontSize: 18,
              color: kSecondaryColor,
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SizedBox(
          height: 120,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder(
              future: provider.getPodCast(),
              builder: (context, AsyncSnapshot<List<PodCast>> snapshot) {
                if (provider.isLoading &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 90,
                        width:MediaQuery.of(context).size.width  ,
                        child: Center(
                          child: KinProgressIndicator(),
                        ) ,
                      )

                    ],
                  );
                }   else if (provider.isLoading &&
                    !(snapshot.connectionState == ConnectionState.active)) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 90,
                        width:MediaQuery.of(context).size.width  ,
                        child: Center(
                          child: Text(
                            "No Internet",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7)),
                          ),
                        ),
                      )
                    ],
                  );
                }else if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  List<PodCast>? podcast = snapshot.data;
                  return ListView.builder(
                    // shrinkWrap: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: podcast!.length>3?3:podcast.length,
                      itemBuilder: (context, index) {
                        return NewPodcastCard(
                            image: "$apiUrl/${podcast[index].cover}",
                            podcast: podcast[index].title,
                            numOfEpisodes: podcast[index].episodes.length,
                            press: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Detail(podCast: podcast[index],)));
                            });
                        // SizedBox(width: getProportionateScreenWidth(20))
                      });
                } else if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.active) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 90,
                        width:MediaQuery.of(context).size.width  ,
                        child: Text(
                          "No Data",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7)),
                        ),
                      )

                    ],
                  );
                }
                return ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      width:MediaQuery.of(context).size.width  ,
                      child: Center(
                        child: KinProgressIndicator(),
                      ),
                    )
                  ],
                );

              },
            ),
          ),
        ),
      ],
    );
  }
}

class NewPodcastCard extends StatelessWidget {
  const NewPodcastCard({
    Key? key,
    required this.podcast,
    required this.image,
    required this.numOfEpisodes,
    required this.press,
  }) : super(key: key);

  final String podcast, image ;
  final int numOfEpisodes;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: Hero(
        tag: numOfEpisodes,
        child: GestureDetector(
          onTap: press,
          child: SizedBox(
            width: getProportionateScreenWidth(242),
            height: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.cover,
                      width: double.infinity),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          kPrimaryColor.withOpacity(0.75),
                          const Color(0xFF343434).withOpacity(0.2),

                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15.0),
                      vertical: getProportionateScreenWidth(10),
                    ),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: "$podcast\n",
                            style: const TextStyle(
                              fontSize: 18,
                              color: kSecondaryColor,
                              fontWeight: FontWeight.w600,

                            ),
                          ),
                          TextSpan(text: "$numOfEpisodes episodes",style:  TextStyle(color: Colors.white.withOpacity(0.75)))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
