import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kin_music_player_app/components/custom_bottom_app_bar.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/login_signup/login_signup_body.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/connectivity_service.dart';
import 'package:kin_music_player_app/services/provider/album_provider.dart';
import 'package:kin_music_player_app/services/provider/artist_provider.dart';
import 'package:kin_music_player_app/services/provider/drop_down_provider.dart';
import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/genre_provider.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:kin_music_player_app/services/provider/profile_provider.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';
import 'services/provider/podcast_player.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xff333333),
    statusBarColor: Color(0xff333333),
    systemNavigationBarIconBrightness: Brightness.light,

  ));

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(MultiProvider(child: Kin(), providers: [
    ChangeNotifierProvider(create: (_) => MusicProvider()),
    ChangeNotifierProvider(create: (_) => AlbumProvider()),
    ChangeNotifierProvider(create: (_) => ArtistProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => MusicPlayer()),
    ChangeNotifierProvider(create: (_) => PodcastPlayer()),
    ChangeNotifierProvider(create: (_) => FavoriteMusicProvider()),
    ChangeNotifierProvider(create: (_) => PlayListProvider()),
    ChangeNotifierProvider(create: (_) => DropDownProvider()),
    ChangeNotifierProvider(create: (_) => PodCastProvider()),
    ChangeNotifierProvider(create: (_) => RadioProvider()),
    ChangeNotifierProvider(create: (_) => GenreProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    StreamProvider(
      create: (context) => ConnectivityService().connectionStatusController.stream,
      initialData: ConnectivityStatus.offline,
    ),
  ]));
}

class Kin extends StatefulWidget {
  @override
  State<Kin> createState() => _KinState();
}

class _KinState extends State<Kin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {}
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {});
    FirebaseMessaging.instance.subscribeToTopic('all');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kin Music',
      theme: theme(),
      initialRoute: LandingPage.routeName,
      routes: routes,
    );
  }
}

checkIfAuthenticated() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.getString('token') != null) {
    return true;
  }
  return false;
}

class LandingPage extends StatelessWidget {
  static String routeName = "/";

  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkIfAuthenticated().then((success) {
      if (success) {
        Navigator.pushReplacementNamed(context, CustomBottomAppBar.routeName);
      } else {
        Navigator.pushReplacementNamed(context, LoginSignupBody.routeName);
      }
    });

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
