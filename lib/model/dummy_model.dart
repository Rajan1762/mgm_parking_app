class DealsCardModel {
  final String productID;
  final String productName;
  final String? imgUrl;
  final String? priceType;
  final double? price;
  bool selected;
  int cartCount;

  DealsCardModel._(
      {required this.productID,
        required this.cartCount,
        required this.selected,
        required this.productName,
        this.imgUrl,
        this.priceType,
        this.price});

  factory DealsCardModel.fromJson(Map<String, dynamic> json) =>
      DealsCardModel._(
          productID: json['id'],
          productName: json['pname'],
          imgUrl: json['imgurl'],
          priceType: json['uom'],
          price: json['price'],
          selected: false,
          cartCount: 0);
}
