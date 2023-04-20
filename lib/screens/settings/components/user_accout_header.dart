import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class UserAccountHeader extends StatelessWidget {
  final String? logo;

  const UserAccountHeader({Key? key, this.logo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Stack(
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              logo!.isEmpty?Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ):CachedNetworkImage(imageUrl: '$apiUrl/$logo',fit: BoxFit.contain,),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: FutureBuilder(
              future: provider.getUserInfo(),
              builder: (ctx, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return UserAccountsDrawerHeader(
                    accountEmail: Text(
                      snapshot.data['userName'],
                    ),
                    accountName: Text(snapshot.data["email"],
                        style: const TextStyle(fontSize: 20)),
                    decoration: const BoxDecoration(color: Colors.transparent),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ],
      ),
    );
  }
}
