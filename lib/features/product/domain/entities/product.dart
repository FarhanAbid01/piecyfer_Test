class Product {
   int? id;
   String? name;
   String? description;
   double? price;
   String? imageUrl;
   String? color;


  Product({
     this.id,
     this.name,
     this.description,
     this.price,
     this.imageUrl,
      this.color,
  });

  /// Factory constructor to create a ProductModel from JSON data
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ??'',
      name: json['name'] ?? '',
      description: json['description'] ?? ' ',
      price: json['price'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      color: json['color'] ?? '',
    );
  }

  /// Converts a ProductModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'color': color,
    };
  }
}
