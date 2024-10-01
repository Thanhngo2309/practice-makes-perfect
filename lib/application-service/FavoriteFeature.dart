import '../application-service/SharedPrefs.dart';

class Favoritefeature {
  static const String FavoriteKey = "favorites";

  static Future<List<String>> getFavorites(String name) async {
    String? idsString = await SharedPrefs.getString("$FavoriteKey:$name");
    List<String> ids = idsString != null ? idsString.split(",") : [];
    return ids; 
  }

  static Future<bool> checkExamExist(String name, String id) async {
    String? idsString = await SharedPrefs.getString("$FavoriteKey:$name");
    List<String> ids = idsString != null ? idsString.split(",") : [];
    return ids.contains(id);
  }

  static Future<void> addOrRemoveExam(String name, String id) async {
      String? idsString = await SharedPrefs.getString("$FavoriteKey:$name");
      List<String> ids = idsString != null ? idsString.split(",") : [];
      bool existed = await checkExamExist(name, id);
      if (!existed) {
        ids.add(id);
      } else {
        ids.remove(id); 
      }
      await SharedPrefs.saveString("$FavoriteKey:$name", ids.join(","));
    }

  static Future<void> clear(String name) async {
    await SharedPrefs.saveString("$FavoriteKey:$name", "");
  }
}