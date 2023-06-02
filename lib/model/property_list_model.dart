class PropertyListModel {
  final String propertyID;
  final String address;
  final String state;
  final String amenities;
  final int bathrooms;
  final int bedrooms;
  final String category;
  final String facilities;
  final int lotSize;
  final String image;
  final int price;
  final String salesType;
  final String OwnerID;
  final String date;
  final String contact;
  final String name;
  final String numOfVisits;

  PropertyListModel(
      {
        required this.amenities,
        required this.bathrooms,
        required this.bedrooms,
        required this.category,
        required this.facilities,
        required this.lotSize,
        required this.image,
        required this.address,
        required this.price,
        required this.salesType,
        required this.numOfVisits,
        required this.state,
        required this.contact,
        required this.propertyID,
        required this.name,
        required this.date,
        required this.OwnerID,
      });

}