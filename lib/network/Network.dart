import 'package:dio/dio.dart';
import 'package:network_app/network/NetworkResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utilities/constants.dart';


class Network {


  final String url = baseUrl;
  final dio = createDio();


  static Dio createDio() {

    var dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveTimeout: const Duration(seconds: 20000),
        connectTimeout: const Duration(seconds: 20000),
        sendTimeout: const Duration(seconds: 20000)
      )
    );

    dio.interceptors.addAll({
      Logging(dio),
    });

    dio.interceptors.addAll({
      AuthInterceptor(dio),
    });

    return dio;
  }


  Future<NetworkResponse?> apiCall(String url,  Map<String, dynamic>? queryParameters, Map<String, dynamic>? body, HttpMethods requestType) async {

    late Response results;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {

      switch(requestType) {

        case HttpMethods.put:
          Options options = Options(headers: header);
          results = await dio.put(baseUrl+url, queryParameters: queryParameters, options: options);
        case HttpMethods.get:
          print("QueryParams:- $queryParameters");
          results = await dio.get(baseUrl+url, queryParameters: queryParameters);
        case HttpMethods.post:
          var headers = header;
          headers['Authorization'] = token ?? "";
          Options options = Options(headers: headers);

          if (token !=  null) {

            results = await dio.post(baseUrl+url, queryParameters: queryParameters, options: options);
          } else {
            results = await dio.post(baseUrl+url, data: body);
          }

        case HttpMethods.patch:
          Options options = Options(headers: header);
          results = await dio.patch(baseUrl+url, queryParameters: queryParameters, options: options);
      }
      if(results != null) {
        return NetworkResponse.success(results.data);
      } else {
        return NetworkResponse.error("Data is null");
      }
    } on DioException catch (error) {
      return NetworkResponse.error(error.toString());
    }
    catch (error) {
      return NetworkResponse.error(error.toString());
    }

  }





}


class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = await prefs.getString('token');

    if (accessToken != null) {
      var expiration = 30; //await TokenRepository().getAccessTokenRemainingTime();

      /*
      if (expiration < 60) {
        // dio.interceptors.requestLock.lock();

        // Call the refresh endpoint to get a new token
        await UserService()
            .refresh()
            .then((response) async {
          await TokenRepository().persistAccessToken(response.accessToken);
          accessToken = response.accessToken;
        }).catchError((error, stackTrace) {
          handler.reject(error, true);
        }).whenComplete(() => dio.interceptors.requestLock.unlock());
      }
      */

      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }
}



class Logging extends Interceptor {
  final Dio dio;

  Logging(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method} => PATH: ${options.path} ] ');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode} => PATH: ${response.requestOptions.path}]');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    return super.onError(err, handler);
  }

}


final Map<String, String> header = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
  'platform': 'IOS',
  'Authorization': ""
};