
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/grid_card.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';

import '../../size_config.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> with AutomaticKeepAliveClientMixin{
  static const _pageSize = 6;
  final PagingController<int, Album> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey)  {
      fetchMoreAlbums(pageKey);
    });
    super.initState();
  }
  Future fetchMoreAlbums(pageKey) async{
    List<Album> albums=[];
    try {
      var page = (pageKey / 6).toInt()+1;
      albums = await fetchMoreAlbum(page);
      final isLastPage = albums.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(albums);
      } else {
        final nextPageKey = pageKey + albums.length;
        pagingController.appendPage(albums, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
  @override
  void dispose() {

    pagingController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: kSecondaryColor,
      child: PagedGridView<int, Album>(
        pagingController: pagingController,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: getProportionateScreenWidth(25),
            mainAxisSpacing: 15),
        builderDelegate: PagedChildBuilderDelegate<Album>(
          itemBuilder: (context, album, index) => GridCard(album: album),
          firstPageErrorIndicatorBuilder: (context) => Padding(
            padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            child: const Center(
              child: Text(
                "Pull To Reload",
                style: TextStyle(color: kGrey),

              ),
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => const Center(
              child: Text(
            'None',
            style: TextStyle(color: Colors.white),
          )),
        ),
        padding: const EdgeInsets.all(16),
      ),
      onRefresh: () => Future.sync(
        () => pagingController.refresh(),
      ),
    );

  }
}

