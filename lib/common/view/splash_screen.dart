import 'package:acture/common/const/colors.dart';
import 'package:acture/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(backgroundColor:PRIMART_COLOR,child: SizedBox(width: MediaQuery.of(context).size.width,
      child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
  Image.asset('asset/img/logo/logo.png',
  width: MediaQuery.of(context).size.width / 2,
      ),
  const SizedBox(height: 16.0),
  CircularProgressIndicator(color: Colors.white)
      ]),
    ),);
  }
}
