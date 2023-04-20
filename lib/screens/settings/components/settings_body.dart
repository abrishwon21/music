import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/settings/components/user_accout_header.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/provider/profile_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

import '../../../components/kin_progress_indicator.dart';
import '../../../constants.dart';
import 'settings_card.dart';

class SettingsBody extends StatefulWidget {
  const SettingsBody({Key? key}) : super(key: key);

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kSecondaryColor,
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder(
          future: getCompanyProfile('/company/profile'),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      UserAccountHeader(logo: snapshot.data.companyLogo),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      SettingsCard(
                          title: 'Privacy Policy',
                          iconData: Icons.verified_user,
                          data: snapshot.data.companyPrivacy),
                      SettingsCard(
                          title: 'Terms of Service',
                          iconData: Icons.gavel,
                          data: snapshot.data.companyTerms),
                      SettingsCard(
                          title: 'Help and Support',
                          iconData: Icons.help,
                          data: snapshot.data.companyHelp),
                      const SettingsCard(
                        title: 'Logout',
                        iconData: Icons.logout,
                      ),

                    ],
                  ),
                );
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text(
                            "Pull to refresh",
                            style:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: KinProgressIndicator(),
                        ),
                      )
                    ],
                  ));
            } else if (!(snapshot.connectionState == ConnectionState.active)) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Text(
                          "No Internet, pull to refresh",
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: KinProgressIndicator(),
                      ),
                    )
                  ],
                ));
          }),
    );
  }
}
