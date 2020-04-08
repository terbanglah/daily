class CartModel {
  final int id;
  final int inventoryId;
  final String inventoryName;
  final double price;
  final int qty;
  final String image;

  CartModel(
    this.id,
    this.inventoryId,
    this.inventoryName,
    this.price,
    this.qty,
    this.image,
  );
}
