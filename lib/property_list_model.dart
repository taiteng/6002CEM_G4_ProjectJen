class Property {
  final String amenities;
  final int bathrooms;
  final int bedrooms;
  final String category;
  final String facilities;
  final String floorSize;
  final String image;
  final String location;
  final double price;
  final String salesType;

  Property(
      {
        required this.amenities,
        required this.bathrooms,
        required this.bedrooms,
        required this.category,
        required this.facilities,
        required this.floorSize,
        required this.image,
        required this.location,
        required this.price,
        required this.salesType
      });

  // Map<String, dynamic> toJson() => {
  //   'amenities': amenities,
  //   'bathrooms': bathrooms,
  //   'bedrooms' : bedrooms,
  //   'category' : category,
  //   'facilities' : facilities,
  //   'floorSize' : floorSize,
  //   'image' : image,
  //   'location' : location,
  //   'price' : price,
  //   'salesType' : salesType
  // };
}