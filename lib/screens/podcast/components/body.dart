import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

import 'package:kin_music_player_app/screens/podcast/components/new_podcasts.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_card.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

import '../../../components/kin_progress_indicator.dart';
import '../../../components/section_title.dart';
import '../../../services/network/model/podcast.dart';
import '../../../services/network/model/podcast_category.dart';
import '../../../services/provider/podcast_provider.dart';
import 'all_category.dart';
import 'all_podcasts.dart';
import 'category_list_card.dart';
import 'detail.dart';


class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kSecondaryColor,
      onRefresh: () async {
        setState(() {});
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            _buildNewPodcast(),
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            _buildCategoryList(),
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            _buildPopularPodcast()
          ],
        ),
      ),
    );
  }

  Widget _buildNewPodcast() {
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
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: KinProgressIndicator(),
                        ),
                      )
                    ],
                  );
                } else if (provider.isLoading &&
                    !(snapshot.connectionState == ConnectionState.active)) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "No Internet",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  List<PodCast>? podcast = snapshot.data;
                  return ListView.builder(
                      // shrinkWrap: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: podcast!.length > 3 ? 3 : podcast.length,
                      itemBuilder: (context, index) {
                        return NewPodcastCard(
                            image: "$apiUrl/${podcast[index].cover}",
                            podcast: podcast[index].title,
                            numOfEpisodes: podcast[index].episodes.length,
                            press: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Detail(
                                        podCast: podcast[index],
                                      )));
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
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "No Data",
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
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
                      width: MediaQuery.of(context).size.width,
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

  Widget _buildCategoryList() {
    final provider = Provider.of<PodCastProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: 'Category',
            press: () {
              Navigator.pushNamed(context, AllCategory.routeName);
            },
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SizedBox(
          height: 100,
          child: FutureBuilder(
            future: provider.getPodCastCategory(),
            builder: (context, AsyncSnapshot<List<PodCastCategory>> snapshot) {
              if (provider.isLoading &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: KinProgressIndicator()),
                    )
                  ],
                );
              } else if (provider.isLoading &&
                  !(snapshot.connectionState == ConnectionState.active)) {
                return ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "No Internet",
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                var length =
                    snapshot.data!.length > 6 ? 6 : snapshot.data!.length;
                return Wrap(
                  spacing: 1,
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  children: [
                    for (var item = 0; item < length; item++)
                      CategoryListCard(category: snapshot.data![item])
                  ],
                );
              } else if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                return ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "No Data",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                        ))
                  ],
                );
              }
              return ListView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: KinProgressIndicator()),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularPodcast() {
    final provider = Provider.of<PodCastProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: "Popular PodCasts",
              press: () {
                Navigator.pushNamed(context, AllPodCastList.routeName);
              }),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        SizedBox(
          height: getProportionateScreenHeight(200),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder(
              future: provider.getPopularPodCast(),
              builder: (context, AsyncSnapshot<List<PodCast>> snapshot) {
                if (provider.isLoading &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: KinProgressIndicator()),
                        )
                      ],
                    ),
                  );
                } else if (provider.isLoading &&
                    !(snapshot.connectionState == ConnectionState.active)) {
                  return SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "No Internet",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  List<PodCast> podcasts = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data == null
                        ? 0
                        : (snapshot.data!.length > 5
                            ? 5
                            : snapshot.data!.length),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PodcastCard(
                          podcast: podcasts[index], podcasts: podcasts);
                    },
                  );
                } else if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.active) {
                  return SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "No Data",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: KinProgressIndicator()),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
