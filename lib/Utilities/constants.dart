import 'package:shared_preferences/shared_preferences.dart';

const baseUrl = "https://dummyjson.com/";
const loginEndpoint = "auth/login";
const allPosts = "posts";


enum HttpMethods {
  put, get, post, patch
}

class Constant {



  Future<String?> getAppToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // var accessToken =
    return await prefs.getString('token');
  }


}