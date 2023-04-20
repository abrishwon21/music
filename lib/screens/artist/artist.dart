import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/artist_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/provider/artist_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../size_config.dart';

class Artists extends StatefulWidget {
  const Artists({Key? key}) : super(key: key);

  @override
  State<Artists> createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = Provider.of<ArtistProvider>(context, listen: false);
    return RefreshIndicator(
      color: kSecondaryColor,
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder(
        future: provider.getArtist(),
        builder: (context, AsyncSnapshot<List<Artist>> snapshot) {
          if (provider.isLoading &&
              snapshot.connectionState == ConnectionState.waiting) {
            return ListView(

              children: [
                               Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                  child: Center(
                    child: KinProgressIndicator(),
                  ) ,
                )

              ],
            );
          }   else if (provider.isLoading &&
              !(snapshot.connectionState == ConnectionState.active)) {
            return ListView(

              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
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
            List<Artist> artists = snapshot.data!;

            return GridView.builder(
              itemCount: artists.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: getProportionateScreenWidth(25),
                  mainAxisSpacing: getProportionateScreenWidth(25)),
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenHeight(25),
                  vertical: getProportionateScreenHeight(25)),
              itemBuilder: (context, index) {
                return ArtistCard(artist: artists[index]);
              },
            );
          } else if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            return ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
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
            children: [
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                child: Center(
                  child: KinProgressIndicator(),
                ),
              )
            ],
          );



        },
      ),
    );
  }
}
