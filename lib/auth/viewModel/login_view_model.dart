import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:network_app/Utilities/constants.dart';
import 'package:network_app/auth/model/user_response.dart';
import 'package:network_app/network/Network.dart';
import 'package:network_app/network/NetworkResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginViewModel extends ChangeNotifier {

  Network network;
  late NetworkResponse _networkResponse = NetworkResponse.initial("Initializing data");

  NetworkResponse get networkResponse {
    return _networkResponse;
  }

  LoginViewModel({required this.network});

  void fetchPosts() async {
    try {
      _networkResponse = NetworkResponse.loading("Fetching posts");
      notifyListeners();
      NetworkResponse? response = await network.apiCall(
          allPosts, null, null, HttpMethods.get);
      if(response?.data != null) {
        print("Response:- ${response!.data}");
        _networkResponse = NetworkResponse.success(response.data);
        notifyListeners();
      } else {
        _networkResponse = NetworkResponse.error("Data is null");
        notifyListeners();
      }

    } catch (error){
      _networkResponse = NetworkResponse.error(error.toString());
      notifyListeners();
    }

  }

  UserResponse _processResponse(Map<String, dynamic> json) {
    return UserResponse.fromJson(json);
  }


  void login(String email, String password) async {

    Map<String, Object> params = HashMap();
    params['username'] = email;
    params['password'] = password;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      _networkResponse = NetworkResponse.loading("Fetching posts");
      notifyListeners();
      NetworkResponse? response = await network.apiCall(
          loginEndpoint, null, params, HttpMethods.post);
      if(response?.data != null) {
         var item = _processResponse(response!.data);
         await prefs.setString('token', item.accessToken);
         await prefs.setString('refreshToken', item.refreshToken);
         await prefs.setString('firstName', item.firstName);
         await prefs.setString('lastName', item.lastName);
         await prefs.setString('userName', item.username);
         await prefs.setString('email', item.email);
         await prefs.setString('profileImage', item.image);
         await prefs.setString('gender', item.gender);
         await prefs.setInt('userId', item.id);
        _networkResponse = NetworkResponse.success(response.data);
        notifyListeners();
      } else {
        _networkResponse = NetworkResponse.error("Data is null");
        notifyListeners();
      }

    } catch (error){
      _networkResponse = NetworkResponse.error(error.toString());
      notifyListeners();
    }

  }

}