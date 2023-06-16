class PropertyListModel {
  final String PropertyID;
  final String Address;
  final String State;
  final String Amenities;
  final int Bathrooms;
  final int Bedrooms;
  final String Category;
  final String Facilities;
  final int LotSize;
  final String Image;
  final int Price;
  final String SalesType;
  final String OID;
  final String Date;
  final String Contact;
  final String Name;
  final int NumOfVisits;

  PropertyListModel(
      {
        required this.Amenities,
        required this.Bathrooms,
        required this.Bedrooms,
        required this.Category,
        required this.Facilities,
        required this.LotSize,
        required this.Image,
        required this.Address,
        required this.Price,
        required this.SalesType,
        required this.NumOfVisits,
        required this.State,
        required this.Contact,
        required this.PropertyID,
        required this.Name,
        required this.Date,
        required this.OID,
      });

}