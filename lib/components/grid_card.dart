import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/album/components/album_body.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';

import '../constants.dart';
import '../size_config.dart';

class GridCard extends StatelessWidget {
  const GridCard({
    Key? key,
    this.width = 140,
    this.aspectRatio = 1.02,
    required this.album,
  }) : super(key: key);

  final double width, aspectRatio;
  final Album album;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kGrey.withOpacity(0.075),
          borderRadius: BorderRadius.circular(10)),
      width: getProportionateScreenWidth(width),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
        vertical: getProportionateScreenHeight(10),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AlbumBody(
                album: album,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Hero(
                tag: album.id.toString(),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          'https://kinmusic.gamdsolutions.com/${album.cover}',
                    )),
              ),
            ),

            SizedBox(height: getProportionateScreenHeight(5)),
            Text(
              album.title,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: const TextStyle(color: kSecondaryColor, fontSize: 16,fontWeight: FontWeight.w600),
            ),
            SizedBox(height: getProportionateScreenHeight(2)),
            Text(
              album.artist,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: const TextStyle(color: kGrey),
            ),
          ],
        ),
      ),
    );
  }
}
