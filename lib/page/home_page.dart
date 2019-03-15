import 'dart:async';

import 'package:flutter/material.dart';

import '../page/order_manage_page.dart';
import '../page/schedule_manage_page.dart';
import '../page/today_task_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final banners = List.generate(
      3, (i) => Image.asset('asset/image/banner$i.jpg', fit: BoxFit.cover));

  TabController tabController;
  Timer timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: banners.length, vsync: this)
      ..addListener(() => _index = tabController.index);

    timer = Timer.periodic(Duration(seconds: 5), (t) {
      if (++_index >= banners.length) _index = 0;
      if (!tabController.indexIsChanging) tabController.animateTo(_index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Material(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.only(top: statusBarHeight, bottom: 50.0),
                child: Column(
                  children: <Widget>[
                    _buildTopInfo(),
                    _buildPersonInfo(),
                  ],
                ),
              ),
              _buildSlide(statusBarHeight)
            ],
          ),
          Container(
            height: 6.0,
            color: Color(0xffe4e4e4),
            margin: const EdgeInsets.only(top: 12.0, bottom: 8.0),
          ),
          _buildBottomGrid()
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    tabController.dispose();
    super.dispose();
  }

  Widget _buildTopInfo() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Stack(
          children: <Widget>[
            Image.asset('asset/icon/notice.png', width: 24.0, height: 24.0),
            Align(
              alignment: Alignment.centerRight,
              child: Image.asset('asset/icon/aides.png',
                  width: 24.0, height: 24.0),
            )
          ],
        ),
      );

  Widget _buildPersonInfo() {
    final textStyle = TextStyle(color: Colors.white);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('asset/image/person.jpg'),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('王技师',
                    style: TextStyle(color: Colors.white, fontSize: 16.0)),
                Text('累计接单：66单', style: textStyle),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('客户满意度：80分', style: textStyle),
                Text('总收入：1500元', style: textStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(double statusBarHeight) => Padding(
        padding: EdgeInsets.only(top: statusBarHeight + 96.0),
        child: Container(
          height: 120.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: <Widget>[
              TabBarView(
                controller: tabController,
                children: banners,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: TabPageSelector(
                      controller: tabController, indicatorSize: 8.0),
                ),
              )
            ],
          ),
        ),
      );

  Widget _buildBottomGrid() => Expanded(
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.7,
          children: <Widget>[
            CircleIconButton(
              text: '今日任务',
              icon: Image.asset('asset/icon/task.png'),
              color: Color(0xffff813a),
              onTap: () => toPage(context, TodayTaskPage()),
            ),
            CircleIconButton(
              text: '工单管理',
              icon: Image.asset('asset/icon/order.png'),
              color: Color(0xfffe4648),
              onTap: () => toPage(context, OrderManagePage()),
            ),
            CircleIconButton(
              text: '日程管理',
              icon: Image.asset('asset/icon/schedule.png'),
              color: Color(0xff00c4af),
              onTap: () => toPage(context, ScheduleManagePage()),
            ),
            CircleIconButton(
              text: '异常工单',
              icon: Image.asset('asset/icon/exception.png'),
              color: Color(0xffffbd3e),
            ),
            CircleIconButton(
              text: '钱包',
              icon: Image.asset('asset/icon/wallet.png'),
              color: Color(0xff0175c2),
            ),
            CircleIconButton(
              text: '上家大学',
              icon: Image.asset('asset/icon/university.png'),
              color: Color(0xffff992d),
            ),
          ],
        ),
      );
}

void toPage(BuildContext context, Widget builder) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => builder,
      ),
    );

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    this.text,
    this.icon,
    this.color,
    this.onTap,
  });

  final String text;
  final Image icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: icon,
            ),
            Text(text, style: TextStyle(fontSize: 16.0))
          ],
        ),
      );
}
