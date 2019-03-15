import 'package:flutter/material.dart';

import '../util/date_format.dart';
import '../widget/circle_text.dart';
import '../model/order.dart';
import '../page/order_detail_page.dart';

class CompleteOrderItem extends _OrderItem {
  CompleteOrderItem({
    Order order,
  }) : super(
          order: order,
          children: <Widget>[
            _ContentText('接单时间：${dateAndTimeFormat(order.receiveDate)}'),
            _ContentText('预约时间：${dateAndTimeFormat(order.appointmentDate)}'),
            _ContentText('签到时间：${dateAndTimeFormat(order.signDate)}')
          ],
        );
}

class SignOrderItem extends _OrderItem {
  SignOrderItem({
    Order order,
  }) : super(
          order: order,
          children: <Widget>[
            _ContentText('接单时间：${dateAndTimeFormat(order.receiveDate)}'),
            _ContentText('预约时间：${dateAndTimeFormat(order.appointmentDate)}')
          ],
        );
}

class StatusOrderItem extends _OrderItem {
  StatusOrderItem({
    Order order,
  }) : super(
          order: order,
          children: <Widget>[
            _ContentText('工单状态：${order.orderStatus}'),
          ],
        );
}

class _OrderItem extends StatelessWidget {
  _OrderItem({
    this.order,
    this.children,
  });

  final Order order;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrderDetailPage(order),
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('安装单 *${order.containsCount}',
                            style: TextStyle(
                                color: const Color(0xfffe4648),
                                fontSize: 15.0)),
                        SizedBox(width: 6.0),
                        _RedCircleText(),
                        SizedBox(width: 4.0),
                        _GreenCircleText(),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _ContentText('订单单号：${order.orderNumber}'),
                        ),
                        order.dueDate == null
                            ? const SizedBox()
                            : order.dueDate.isAfter(DateTime.now())
                                ? Text(
                                    '请于${timeFormat(order.dueDate)}${orderStatusToString(order.orderType)}')
                                : Text('${orderStatusToString(order.orderType)}已超时',
                                    style: TextStyle(color: Color(0xffff001d))),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _ContentText('客户地址：${order.customAddress}'),
                      ],
                    )
                  ]..addAll(children),
                ),
              ),
              Image.asset('asset/icon/arrow_right.png',
                  width: 32.0, height: 32.0)
            ],
          ),
        ),
      );
}

class _ContentText extends Text {
  const _ContentText(String text)
      : super(text, style: const TextStyle(fontSize: 13.0));
}

class _RedCircleText extends CircleText {
  const _RedCircleText()
      : super(color: const Color(0xfffe4648), text: '催', size: 13.0);
}

class _GreenCircleText extends CircleText {
  const _GreenCircleText()
      : super(color: const Color(0xff4aaf77), text: '活', size: 13.0);
}
