import 'package:acture/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  @override
    void onResponse(Response response, ResponseInterceptorHandler handler) {
      // TODO: implement onResponse
      return super.onResponse(response, handler);
    }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // 401 error 이고 이 요청이 로그인 요청이 아닐 경우 즉 토큰 만료 겠지?
    // 이경우 리프레쉬 토큰 재발급 받고 토큰 넣어서 다시 재요청
    // 리프레시 토큰 요청 중 또 에러가 나면 여기서는 방법 없음 바로 에러 띄우거나 로그인 화면으로 가야함
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        //리프레시 토큰 재발급은 이전 리플레시 토큰으로 재밝브 발을 수 있다 
        final resp = await dio.post('http://$ip/auth/token',
            options:
                Options(headers: {'authorization': 'Bearer $refreshToken'}));
        final accessToken = resp.data['accessToken'];
        
        final options = err.requestOptions;

        options.headers.addAll({
          'authorization': 'Bearer $accessToken'
        });


        await storage.write(key: ACCESS_TOKEN, value: accessToken);
        final response = await dio.fetch(options);
        return handler.resolve(response);


      } on DioError catch (e) {
        return handler.reject(err);
      }
    }

    return handler.reject(err);
  }
}
