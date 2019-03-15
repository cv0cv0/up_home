import 'dart:math';

import 'package:flutter/material.dart';

import '../model/order.dart';
import '../widget/order_items.dart';
import '../widget/rectangle_button.dart';

class OrderManagePage extends StatefulWidget {
  @override
  _OrderManagePageState createState() => _OrderManagePageState();
}

class _OrderManagePageState extends State<OrderManagePage> {
  OrderStatus _orderStatus;
  _OrderDate _orderDate;

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
          title: const Text('工单管理'),
          actions: <Widget>[
            InkResponse(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('asset/icon/aides.png'),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: const Text('筛选', style: TextStyle(color: Colors.white)),
            onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => _FilterBottomSheet(
                      orderStatus: _orderStatus, orderDate: _orderDate),
                ).then((result) {
                  if (result == null) return;
                  _orderStatus = result['order_status'];
                  _orderDate = result['order_date'];
                })),
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

class _FilterBottomSheet extends StatefulWidget {
  _FilterBottomSheet({this.orderStatus, this.orderDate});

  final OrderStatus orderStatus;
  final _OrderDate orderDate;

  @override
  State<StatefulWidget> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  OrderStatus _orderStatus;
  _OrderDate _orderDate;

  final _orderStatusList = List.of(orderStatusList)..add(null);

  @override
  void initState() {
    super.initState();
    _orderStatus = widget.orderStatus;
    _orderDate = widget.orderDate;
  }

  @override
  Widget build(BuildContext context) {
    final orderStatusChips = _orderStatusList
        .map((status) => ChoiceChip(
              label: Text(
                  status == null ? '全部' : '待${orderStatusToString(status)}'),
              selected: _orderStatus == status,
              onSelected: (value) => setState(() => _orderStatus = status),
            ))
        .toList();

    final orderDateChips = _orderDateLIst
        .map((date) => ChoiceChip(
              label: Text(date == null ? '全部' : _orderDateToString(date)),
              selected: _orderDate == date,
              onSelected: (value) => setState(() => _orderDate = date),
            ))
        .toList();

    final theme = Theme.of(context);
    return ChipTheme(
      data: theme.chipTheme.copyWith(
        secondaryLabelStyle: TextStyle(color: Colors.white),
        secondarySelectedColor: theme.primaryColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 6.0),
          _ChipsTile(label: '工单状态', children: orderStatusChips),
          _ChipsTile(label: '工单时间', children: orderDateChips),
          SizedBox(height: 8.0),
          Row(
            children: <Widget>[
              Expanded(
                child: RectangleButton(
                  text: '取消',
                  color: Colors.grey[300],
                ),
              ),
              Expanded(
                child: RectangleButton(
                  text: '确定',
                  color: theme.primaryColor,
                  textColor: Colors.white,
                  onTap: () => Navigator.of(context).pop({
                        'order_status': _orderStatus,
                        'order_date': _orderDate,
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipsTile extends StatelessWidget {
  const _ChipsTile({Key key, this.label, this.children}) : super(key: key);

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label,
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 12.0,
              children: children,
            ),
          ],
        ),
      );
}

const _orderDateLIst = <_OrderDate>[
  _OrderDate.today,
  _OrderDate.seven_day,
  _OrderDate.thirty_day,
  null,
];

String _orderDateToString(_OrderDate date) {
  switch (date) {
    case _OrderDate.today:
      return '今天';
    case _OrderDate.seven_day:
      return '7天内';
    case _OrderDate.thirty_day:
      return '30天内';
  }
}

enum _OrderDate {
  today,
  seven_day,
  thirty_day,
}
