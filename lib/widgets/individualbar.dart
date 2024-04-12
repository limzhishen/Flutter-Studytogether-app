class IndividualBar {
  final int x;
  final double y;
  const IndividualBar({required this.x, required this.y});
}

class BarData {
  final double totalAmount;
  final double firstAmount;
  final double secondAmount;
  final double thirdAmount;
  BarData(
      {required this.totalAmount,
      required this.firstAmount,
      required this.secondAmount,
      required this.thirdAmount});
  List<IndividualBar> barData = [];
  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: totalAmount),
      IndividualBar(x: 1, y: firstAmount),
      IndividualBar(x: 2, y: secondAmount),
      IndividualBar(x: 3, y: thirdAmount),
    ];
  }
}
