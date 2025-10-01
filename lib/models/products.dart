class Product{
  final int id;
  final String name;
  final String image;
  final double price;
  final int likes;
  final String category;
  final String? description;
  final String? dimension;
  final String? size;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.likes,
    required this.category,
    this.description,
    this.dimension,
    this.size,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'], 
      name: json['name'],  
      image: json['image'], 
      price: json['price'], 
      likes: json['likes'], 
      category: json['category'],
      description: json['description'],
      dimension: json['dimension'],
      size: json['size'],
    );
  }
}