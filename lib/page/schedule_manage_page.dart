import 'dart:math';

import 'package:flutter/material.dart';

import '../model/order.dart';
import '../widget/order_items.dart';

class ScheduleManagePage extends StatefulWidget {
  @override
  _ScheduleManagePageState createState() => _ScheduleManagePageState();
}

class _ScheduleManagePageState extends State<ScheduleManagePage> {
  final appBarBottomTextStyle = TextStyle(color: Colors.white, fontSize: 15.0);

  final orders = List.generate(
      15,
      (i) => Order(
          orderStatusList[Random().nextInt(4)],
          'TM1233012330012',
          1,
          i == 1 ? DateTime.now() : DateTime.now().add(Duration(hours: 2)),
          '浙江省杭州市上城区',
          '已接单',
          DateTime.now(),
          DateTime.now(),
          DateTime.now()));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('日程管理'),
          actions: <Widget>[
            InkResponse(
              onTap: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2017, 1, 1),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('asset/icon/calendar.png'),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 32.0),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.arrow_back_ios, color: Colors.white),
                        Text('前一天', style: appBarBottomTextStyle),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text('2018-08-20', style: appBarBottomTextStyle),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('后一天', style: appBarBottomTextStyle),
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          itemCount: orders.length * 2,
          itemBuilder: (context, index) {
            if (index.isOdd) return Divider();

            final order = orders[index ~/ 2];
            switch (order.orderType) {
              case OrderStatus.receive:
              case OrderStatus.booking:
                return StatusOrderItem(order: order);
              case OrderStatus.sign:
                return SignOrderItem(order: order);
              case OrderStatus.complete:
                return CompleteOrderItem(order: order);
            }
          },
        ),
      );
}
