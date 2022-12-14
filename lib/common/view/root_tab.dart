import 'package:acture/common/const/colors.dart';
import 'package:acture/common/layout/default_layout.dart';
import 'package:acture/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코퐥 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: PRIMART_COLOR,
          unselectedItemColor: BODY_TEXT_COLOR,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed, // 아이콘 탭시 효과
          onTap: (int index) {
            controller.animateTo(index);
          },
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood_outlined), label: '음식'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_rounded), label: '주문'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_rounded), label: '프로필')
          ]),
      child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            Center(child: RestaurantScreen()),
            Center(child: Container(child: const Text('음식'))),
            Center(child: Container(child: const Text('주문'))),
            Center(child: Container(child: const Text('프로필'))),
          ]),
      //child: Center(child: Text('Root Tab')),
    );
  }
}
