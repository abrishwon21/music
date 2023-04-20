import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class GenreAppBar extends StatelessWidget {
  final Genre genre;
  const GenreAppBar({Key? key,required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return               SliverAppBar(
      expandedHeight: 175,
      pinned: true,
      backgroundColor: kPrimaryColor,
      elevation: 2,
      leading: BackButton(color: kSecondaryColor,onPressed: (){
        Navigator.pop(context);
      },),
      title: const Text('Musics',style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.w700),),
      bottom:   PreferredSize(preferredSize: const Size(double.infinity,75),child:Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        color: kPrimaryColor.withOpacity(0.3),
        height: getProportionateScreenHeight(75),
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        child: Text(
          genre.title,
          style: const TextStyle(
            color: kSecondaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),),
      flexibleSpace: FlexibleSpaceBar(


        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: "$apiUrl/${genre.cover}",
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF343434).withOpacity(0.4),
                    const Color(0xFF343434).withOpacity(0.7),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
