import 'package:flutter/material.dart' hide ExpansionTile;

import '../model/order.dart';
import '../widget/expension_tile.dart';
import '../widget/circle_button.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage(this.order);

  final Order order;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final titleTextStyle =
      TextStyle(color: Colors.grey[850], fontWeight: FontWeight.bold);

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          title: Text('${orderStatusToString(widget.order.orderType)}详情'),
          actions: <Widget>[
            InkResponse(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text('备注', style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    _buildOrderDetail(),
                    Divider(),
                    _buildProductDetail(),
                    Divider(),
                    _buildOperationHistory(),
                  ],
                ),
              ),
            ),
            widget.order.orderType == OrderStatus.receive
                ? SizedBox()
                : Card(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        widget.order.orderType == OrderStatus.complete
                            ? _buildWriteOffCode()
                            : SizedBox(),
                        _buildAction(),
                      ],
                    ),
                  ),
            Card(
              margin: const EdgeInsets.all(10.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: _buildBottomCard(),
            ),
          ],
        ),
      );

  Widget _buildOrderDetail() => Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.asset('asset/icon/order_detail.png',
                    width: 28.0, height: 28.0),
                SizedBox(height: 4.0),
                Text('订单信息', style: titleTextStyle)
              ],
            ),
            SizedBox(width: 24.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('安装单',
                    style: TextStyle(color: Color(0xffff001d), fontSize: 15.0)),
                Text('订单单号：${widget.order.orderNumber}')
              ],
            )
          ],
        ),
      );

  Widget _buildProductDetail() => Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: ExpansionTile(
          onExpansionChanged: (value) => setState(() => _isExpanded = value),
          leading: Image.asset('asset/icon/product_detail.png',
              width: 20.0, height: 20.0),
          title: RichText(
            text: TextSpan(
              style: titleTextStyle,
              text: '商品详情 *3',
              children: <TextSpan>[
                TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontSize: 14.0),
                  text: _isExpanded ? '  (点击收起)' : '  (点击展开)',
                ),
              ],
            ),
          ),
          children: <Widget>[
            _productDetail('asset/image/picture.png', '(苏宁)地漏', 3, 55.0,
                'Arrow', 'MNX505'),
            _productDetail('asset/image/picture.png', '(苏宁)地漏', 3, 55.0,
                'Arrow', 'MNX505'),
            _productDetail('asset/image/picture.png', '(苏宁)地漏', 3, 55.0,
                'Arrow', 'MNX505'),
          ],
        ),
      );

  Widget _buildOperationHistory() => Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset('asset/icon/history.png',
                    width: 20.0, height: 20.0),
                SizedBox(width: 8.0),
                Text('操作历史', style: titleTextStyle),
              ],
            ),
            SizedBox(
              height: 70.0,
              child: ListView.builder(
                itemCount: 6,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                itemBuilder: (context, index) => Text(
                      '接单时间：2018-05-05 14:00',
                    ),
              ),
            ),
          ],
        ),
      );

  Widget _buildWriteOffCode() => Padding(
        padding: const EdgeInsets.only(left: 14.0, top: 8.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 120.0,
              child: TextField(
                keyboardType: TextInputType.url,
                style: Theme.of(context).textTheme.body1,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.5),
                  hintText: '输入核销码',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            RaisedButton(
              onPressed: () {},
              textColor: Colors.white,
              color: const Color(0xff31a668),
              child: const Text('获取核销码'),
            ),
          ],
        ),
      );

  Widget _buildAction() {
    final textStyle = TextStyle(color: Theme.of(context).primaryColor);
    switch (widget.order.orderType) {
      case OrderStatus.sign:
      case OrderStatus.complete:
        return FlatButton(
          onPressed: () {},
          child: Text('遇到问题', style: textStyle),
        );
      case OrderStatus.booking:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              onPressed: () {},
              child: Text('下次再约', style: textStyle),
            ),
            FlatButton(
              onPressed: () {},
              child: Text('无需安装', style: textStyle),
            ),
            FlatButton(
              onPressed: () {},
              child: Text('无法胜任', style: textStyle),
            ),
          ],
        );
      default:
        return null;
    }
  }

  Widget _buildBottomCard() => Column(
        children: <Widget>[
          SizedBox(height: 4.0),
          ListTile(
            leading: Image.asset('asset/image/customer_avatar.png'),
            title: Text(
                '客户姓名：${_getName('李擎')}',
                style: TextStyle(fontSize: 15.0)),
            subtitle: Row(
              children: <Widget>[
                Text('客户地址：'),
                Expanded(child: Text('浙江省杭州市上城区凌烟街道')),
                widget.order.orderType == OrderStatus.receive
                    ? SizedBox()
                    : Image.asset('asset/image/location.png',
                        width: 28.0, height: 28.0),
              ],
            ),
          ),
          Divider(),
          _buildBottomButton(),
        ],
      );

  Widget _buildBottomButton() {
    final primaryColor = Theme.of(context).primaryColor;
    final greenColor = const Color(0xff31a668);
    final redColor = Color(0xffdf0000);
    final blueColor = const Color(0xff0175c2);
    final yellowColor = const Color(0xffffce46);
    final callButton = CircleButtonWithIcon(
      icon: 'asset/icon/call.png',
      color: greenColor,
    );

    final children = <Widget>[];
    switch (widget.order.orderType) {
      case OrderStatus.receive:
        children.addAll(<Widget>[
          CircleButtonWithText(
            text: '接单',
            color: greenColor,
          ),
          CircleButtonWithText(
            text: '拒绝',
            color: redColor,
          ),
        ]);
        break;
      case OrderStatus.booking:
        children.addAll(<Widget>[
          CircleButtonWithText(
            text: '预约时间',
            color: primaryColor,
          ),
          callButton,
        ]);
        break;
      case OrderStatus.sign:
        children.addAll(<Widget>[
          CircleButtonWithText(
            text: '签到',
            color: blueColor,
          ),
          CircleButtonWithText(
            text: '改约',
            color: primaryColor,
          ),
          callButton,
        ]);
        break;
      case OrderStatus.complete:
        children.addAll(<Widget>[
          CircleButtonWithText(
            text: '完工',
            color: primaryColor,
          ),
          CircleButtonWithText(
            text: '部分完工',
            color: yellowColor,
          ),
          CircleButtonWithText(
            text: '挂起',
            color: redColor,
          ),
          callButton,
        ]);
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }

  Widget _productDetail(String image, String name, int count, double price,
          String brand, String model) =>
      ListTile(
        leading: Image.asset(image),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text('$name *$count', style: TextStyle(fontSize: 14.0)),
            ),
            Text('¥ $price'),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                '品牌：${widget.order.orderType == OrderStatus.receive ? '****' : brand}',
                style: TextStyle(fontSize: 13.0)),
            Text(
                '型号：${widget.order.orderType == OrderStatus.receive ? '****' : model}',
                style: TextStyle(fontSize: 13.0)),
          ],
        ),
      );

  String _getName(String name) {
    if (widget.order.orderType == OrderStatus.receive) {
      var lastName = name.substring(0, 1);
      var firstName = ' ';
      for (var i = 1; i < name.length; i++) {
        firstName += '*';
      }
      return lastName + firstName;
    }
    return name;
  }
}
