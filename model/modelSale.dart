class SaleModel {
  final int id;
  final String saleNo;
  final int paymentId;
  final String payment;
  final double amount;
  final double pay;
  final double refund;
  final String createBy;
  final List<SaleDetailModel> details;

  SaleModel(
    this.id,
    this.saleNo,
    this.paymentId,
    this.payment,
    this.amount,
    this.pay,
    this.refund,
    this.createBy,
    this.details,
  );
}

class SaleDetailModel {
  final int id;
  final int inventoryId;
  final String inventoryName;
  final double price;
  final int qty;
  final double amount;
  final String image;
  final String category;

  SaleDetailModel(
    this.id,
    this.inventoryId,
    this.inventoryName,
    this.price,
    this.qty,
    this.amount,
    this.image,
    this.category,
  );
}