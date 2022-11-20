import 'package:acture/common/const/colors.dart';
import 'package:acture/common/const/data.dart';
import 'package:acture/common/layout/default_layout.dart';
import 'package:acture/common/view/root_tab.dart';
import 'package:acture/user/view/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // 최초 실행
  void initState() {
    super.initState();
    checkToken();
  }

  void deleteToken() async {
    await storage.deleteAll();
  }

  void checkToken() async {
    final refreshToken = await storage.read(key: REFRESH_TONKE_KEY);
    final acceessToken = await storage.read(key: ACCESS_TOKEN);

    if (refreshToken == null || acceessToken == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const RootTab()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMART_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'asset/img/logo/logo.png',
            width: MediaQuery.of(context).size.width / 2,
          ),
          const SizedBox(height: 16.0),
          const CircularProgressIndicator(color: Colors.white)
        ]),
      ),
    );
  }
}
