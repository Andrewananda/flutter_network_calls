
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:network_app/home/model/PostResponse.dart';
import '../../Utilities/constants.dart';
import '../../network/Network.dart';
import '../../network/NetworkResponse.dart';

class HomeViewModel extends ChangeNotifier {

  Network network;
  late NetworkResponse _networkResponse = NetworkResponse.initial("Initializing data");
  late List<Post> _postsList = List.empty();

  List<Post> get postList {
    return _postsList;
  }

  NetworkResponse get networkResponse {
    return _networkResponse;
  }


  HomeViewModel({required this.network});


  PostsResponse _getPostResponse(Map<String, dynamic> json) {
    return PostsResponse.fromJson(json);
  }


  void fetchPosts(String userId) async {

    print("UserId:- $userId");
    try {
      Map<String, Object> params = HashMap();
      params['userid'] = userId;

      _networkResponse = NetworkResponse.loading("Fetching posts");
      notifyListeners();
      NetworkResponse? response = await network.apiCall(
          "$allPosts/user/$userId", null, null, HttpMethods.get);
      if(response?.data != null) {
        var res = _getPostResponse(response!.data);
        _postsList = res.posts;
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