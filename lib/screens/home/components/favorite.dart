import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/home/components/favorite_list.dart';
import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);
  static String routeName = 'favorite';

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void initState() {
    Provider.of<FavoriteMusicProvider>(context, listen: false).getFavMusic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: const Text('Favorite',style: TextStyle(color: kSecondaryColor),),
          leading: BackButton(color: kSecondaryColor,onPressed: (){Navigator.pop(context);},),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Consumer<FavoriteMusicProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  SizedBox(height: getProportionateScreenWidth(15)),
                  (provider.isLoading)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : provider.favoriteMusics.isEmpty
                          ? const Center(
                              child: Text(
                              'No Music Added To Favorite',
                              style: TextStyle(color: Colors.white),
                            ))
                          : ListView.builder(
                              itemCount: provider.favoriteMusics.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return FavoriteList(
                                    id: provider.favoriteMusics[index].id,
                                    music: provider.favoriteMusics[index].music,
                                musicIndex: index,
                                favoriteMusics: provider.favoriteMusics);

                              })
                ],
              );
            },
          ),
        ));
  }
}
