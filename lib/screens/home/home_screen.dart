import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kin_music_player_app/screens/genre/genre.dart';
import 'package:kin_music_player_app/screens/home/components/favorite.dart';
import 'package:kin_music_player_app/screens/home/components/home_search_screen.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../screens/album/album.dart';
import '../../size_config.dart';
import '../../screens/artist/artist.dart';

import 'components/songs.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;

  Future<bool> checkIfAuthenticated() async {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    var isLoggedIn = await provider.isLoggedIn();
    if (isLoggedIn) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Image.asset('assets/images/logo.png',height: 30,width: 30,),
          elevation: 2,
          actions: [
            Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(8)),
                child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, HomeSearchScreen.routeName);
                    },
                    icon: const Hero(
                      tag: 'search',
                      child: Icon(
                        Icons.search,
                        size: 25,
                        color: kSecondaryColor,
                      ),
                    ))),
            Padding(
              padding: EdgeInsets.only(top: getProportionateScreenHeight(8),right: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Favorite.routeName);
                },
                child: SvgPicture.asset(
                  'assets/icons/favorite.svg',
                  height: getProportionateScreenHeight(25),
                  color: kSecondaryColor,
                ),
              ),
            ),

          ],
          bottom:  TabBar(
            tabs:const [
              Tab(
                text: 'Songs',
              ),
              Tab(
                text: 'Albums',
              ),
              Tab(
                text: 'Artists',
              ),
              Tab(
                text: 'Genres',
              ),
            ],
            indicatorColor:kGrey,
           labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          // unselectedLabelStyle: TextStyle(fontSize: 13),
           labelColor: kSecondaryColor,
            unselectedLabelColor: kGrey.withOpacity(0.75),
          ),
        ),
        body: TabBarView(children: [
          Songs(),
          const Albums(),
          const Artists(),
          const Genres(),
        ]),
      ),
    );
  }
}
