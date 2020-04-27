class CartModel {
  final int id;
  final int inventoryId;
  final String inventoryName;
  final double price;
  final int stock;
  final int qty;
  final String image;

  CartModel(
    this.id,
    this.inventoryId,
    this.inventoryName,
    this.price,
    this.stock,
    this.qty,
    this.image,
  );

  Map<String, dynamic> toJson() {
    return {
      "inventory_id": this.inventoryId,
      "qty": this.qty,
    };
  }

  static List encondeToJson(List<CartModel> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }
}
