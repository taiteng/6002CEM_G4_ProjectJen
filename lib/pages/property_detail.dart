import 'package:flutter/material.dart';
import 'package:projectjen/widgets/property_detail_widget.dart';
import 'package:projectjen/widgets/property_detail_form_widget.dart';
import 'package:projectjen/widgets/review_dialog.dart';
import 'package:projectjen/widgets/whatsapp_widget.dart';
import '../widgets/property_detail_favourite_widget.dart';
import '../widgets/review_widget.dart';

class PropertyDetail extends StatefulWidget {
  final String imageURL,
      name,
      address,
      date,
      id,
      category,
      facilities,
      contact,
      state,
      salesType,
      amenities;
  final int price, lotSize, numOfVisits, beds, bathrooms;

  const PropertyDetail({
    Key? key,
    required this.imageURL,
    required this.name,
    required this.address,
    required this.date,
    required this.id,
    required this.category,
    required this.facilities,
    required this.contact,
    required this.salesType,
    required this.amenities,
    required this.price,
    required this.lotSize,
    required this.beds,
    required this.bathrooms,
    required this.state,
    required this.numOfVisits,
  }) : super(key: key);

  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0.00,
        title: Text(widget.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PropertyDetailFavouriteWidget(id: widget.id),
          WhatsappWidget(
            imageURL: widget.imageURL,
            name: widget.name,
            price: widget.price,
            salesType: widget.salesType,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  PropertyDetailWidget(
                    name: widget.name,
                    salesType: widget.salesType,
                    address: widget.address,
                    beds: widget.beds,
                    bathrooms: widget.bathrooms,
                    lotSize: widget.lotSize,
                    price: widget.price,
                    amenities: widget.amenities,
                    category: widget.category,
                    facilities: widget.facilities,
                    contact: widget.contact,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  PropertyFormWidget(id: widget.id),
                  const SizedBox(
                    height: 25,
                  ),
                  ReviewWidget(
                    id: widget.id,
                    imageURL: widget.imageURL,
                  ),
                  ReviewDialog(pid: widget.id),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
