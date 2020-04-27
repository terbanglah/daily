class InventoryModel {
  final int id;
  final String inventoryName;
  final double price;
  final int stock;
  final String image;
  final int categoryId;
  final String category;

  InventoryModel(
    this.id,
    this.inventoryName,
    this.price,
    this.stock,
    this.image,
    this.categoryId,
    this.category,
  );
}
