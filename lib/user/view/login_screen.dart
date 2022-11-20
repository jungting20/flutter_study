import 'dart:convert';
import 'dart:io';

import 'package:acture/common/component/custom_text_form_field.dart';
import 'package:acture/common/const/colors.dart';
import 'package:acture/common/const/data.dart';
import 'package:acture/common/layout/default_layout.dart';
import 'package:acture/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    // localhost
    const emulatorUp = '10.0.2.2:3000';
    const simulatorIp = '127.0.0.1:3000';

    final ip = Platform.isIOS ? simulatorIp : emulatorUp;

    return DefaultLayout(
      //키보드 가 올라 왔을때는 뷰가 더 커지는거임 그러니가 스크롤을 줘버림
      child: SingleChildScrollView(
        //거의 내가보기엔 정석 적인 방법임
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Title(),
                  const _SubTitle(),
                  Image.asset('asset/img/misc/logo.png',
                      width: MediaQuery.of(context).size.width / 3 * 2),
                  CustomTextFormField(
                    hintText: '이메일을 입력해주세요',
                    onChanged: (String value) {
                      username = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextFormField(
                      hintText: '비밀번호를 입력해 주세요',
                      onChanged: (String value) {
                        password = value;
                      },
                      obscureText: true),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                      onPressed: () async {
                        final rawString = '$username:$password';

                        Codec<String, String> stringToBase64 =
                            utf8.fuse(base64);

                        String token = stringToBase64.encode(rawString);
                        final resp = await dio.post('http://$ip/auth/login',
                            options: Options(
                                headers: {'authorization': 'Basic $token'}));
                        final refrreshToken = resp.data['refrreshToken'];
                        final accessToken = resp.data['accessToken'];

                        await storage.write(
                            key: REFRESH_TONKE_KEY, value: refrreshToken);
                        await storage.write(
                            key: ACCESS_TOKEN, value: accessToken);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RootTab()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMART_COLOR),
                      child: const Text('로그인')),
                  TextButton(
                    onPressed: () async {
                      final rawString = '$username:$password';

                      Codec<String, String> stringToBase64 = utf8.fuse(base64);

                      String token = stringToBase64.encode(rawString);

                      final resp = await dio.post('http://$ip/auth/token',
                          options: Options(
                              headers: {'authorization': 'Basic $token'}));
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: const Text('회원가입'),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('이메일과 비밀번호를 입력해서 로그인 해주세요! \n 오늘도 성공적인 주문이 되길:)',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ));
  }
}
