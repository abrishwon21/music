import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';

class ProfileProvider extends ChangeNotifier {
  bool isLoading = false;

  Future getCompanyInfo() async {
    const String apiEndPoint = '/company/profile';
    isLoading = true;

   await getCompanyProfile(apiEndPoint);

    isLoading = false;
    notifyListeners();

  }
}