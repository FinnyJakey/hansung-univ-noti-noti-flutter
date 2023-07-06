import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_fcm.dart';
import '../services/firebase_functions.dart';

class SharedPrefModel {
  static bool darkMode = false;
  static List<String> favorites = [];
  static String id = '';
  static String pw = '';
  static String arriveServiceKey = '';
  static String locationServiceKey = '';

  static bool notifIsEnabled = false;
  static String token = "";
  static List<String> keywords = [];

  static late SharedPreferences prefs;

  static initialize() async {
    prefs = await SharedPreferences.getInstance();
    darkMode = prefs.getBool('darkMode') ?? false;
    favorites = prefs.getStringList('favorites') ?? [];
    id = prefs.getString('id') ?? '';
    pw = prefs.getString('pw') ?? '';
    arriveServiceKey = await getArriveServiceKey();
    locationServiceKey = await getLocationServiceKey();

    token = prefs.getString('deviceToken') ?? 'null';
    notifIsEnabled = prefs.getBool('notifIsEnabled') ?? false;
    keywords = prefs.getStringList('keywords') ?? [];
  }

  static setDarkMode(bool stat) {
    darkMode = stat;
    prefs.setBool('darkMode', stat);
  }

  static addFavorite(String number) {
    favorites = [...favorites, number];
    prefs.setStringList('favorites', favorites);
  }

  static removeFavorite(String number) {
    List<String> favoritesList = prefs.getStringList('favorites')!;
    favoritesList.remove(number);
    prefs.setStringList('favorites', favoritesList);
    favorites.remove(number);
  }

  static setAccount(String id, String pw) {
    SharedPrefModel.id = id;
    SharedPrefModel.pw = pw;
    prefs.setString('id', id);
    prefs.setString('pw', pw);
  }

  static clearAccount() {
    SharedPrefModel.id = '';
    SharedPrefModel.pw = '';
    prefs.setString('id', '');
    prefs.setString('pw', '');
  }

  static setNotifEnabled(bool tf) {
    prefs.setBool('notifIsEnabled', tf);
    notifIsEnabled = tf;
  }

  static setMyToken(String inputToken) {
    prefs.setString('deviceToken', inputToken);
    token = inputToken;
  }

  static addKeyword(String keyword) {
    List<String> keywordItems = [];
    List<String>? keywordsList = prefs.getStringList('keywords');
    if (keywordsList != null) {
      keywordItems.addAll(keywordsList);
    }
    keywordItems.add(keyword);
    prefs.setStringList('keywords', keywordItems);
    keywords.clear();
    keywords.addAll(keywordItems);
  }

  static removeKeyword(String keyword) {
    List<String> keywordsList = prefs.getStringList('keywords')!;
    keywordsList.remove(keyword);
    prefs.setStringList('keywords', keywordsList);
    keywords.remove(keyword);
  }
}
