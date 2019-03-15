class Order {
  Order(
      this.orderType,
      this.orderNumber,
      this.containsCount,
      this.dueDate,
      this.customAddress,
      this.orderStatus,
      this.receiveDate,
      this.appointmentDate,
      this.signDate);

  String get tabTypeString => orderStatusToString(orderType);

  final OrderStatus orderType;
  final String orderNumber;
  final int containsCount;
  final DateTime dueDate;
  final String customAddress;
  final String orderStatus;
  final DateTime receiveDate;
  final DateTime appointmentDate;
  final DateTime signDate;
}

String orderStatusToString(OrderStatus type) {
  switch (type) {
    case OrderStatus.receive:
      return '接单';
    case OrderStatus.booking:
      return '预约';
    case OrderStatus.sign:
      return '签到';
    case OrderStatus.complete:
      return '完工';
  }
}

const orderStatusList = <OrderStatus>[
  OrderStatus.receive,
  OrderStatus.booking,
  OrderStatus.sign,
  OrderStatus.complete,
];

enum OrderStatus {
  receive,
  booking,
  sign,
  complete,
}
