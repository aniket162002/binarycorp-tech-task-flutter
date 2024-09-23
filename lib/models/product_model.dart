class ProductModel {
  final String name;
  final String description;
  final String availability;
  final String image;

  ProductModel({
    required this.name,
    required this.description,
    required this.availability,
    required this.image,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'description': description,
      'availability': availability,
      'image': image,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'],
      description: map['description'],
      availability: map['availability'],
      image: map['image'],
    );
  }
}
