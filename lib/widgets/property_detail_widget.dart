import 'package:flutter/material.dart';
import 'package:projectjen/widgets/rating_bar_widget.dart';

class PropertyDetailWidget extends StatefulWidget {
  final String id,
      name,
      salesType,
      address,
      amenities,
      category,
      facilities,
      contact;
  final int price, beds, bathrooms, lotSize;

  const PropertyDetailWidget(
      {super.key,
      required this.name,
      required this.salesType,
      required this.address,
      required this.beds,
      required this.bathrooms,
      required this.lotSize,
      required this.price,
      required this.amenities,
      required this.category,
      required this.facilities,
      required this.contact, required this.id});

  @override
  State<PropertyDetailWidget> createState() => _PropertyDetailWidgetState();
}

class _PropertyDetailWidgetState extends State<PropertyDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RatingBarWidget(id: widget.id),
            ElevatedButton(
              onPressed: () {},
              child: Container(
                child: widget.salesType == "Rent"
                    ? Text(
                        "RM${widget.price}/month",
                        style: const TextStyle(fontSize: 12),
                      )
                    : Text(
                        "RM${widget.price}",
                        style: const TextStyle(fontSize: 12),
                      ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                Text(
                  widget.address,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                ),
                height: 35,
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.bed,
                      size: 15,
                    ),
                    Text(
                      "  ${widget.beds.toString()} Beds",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                ),
                height: 35,
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.bathtub,
                      size: 15,
                    ),
                    Text(
                      "  ${widget.bathrooms.toString()} Bathrooms",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                ),
                height: 35,
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.landscape,
                      size: 15,
                    ),
                    Text(
                      "  ${widget.lotSize} Sqft",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.salesType} Details",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Amenities: ${widget.amenities}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "LotSize: ${widget.lotSize}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Category: ${widget.category}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Facilities: ${widget.facilities}",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Feel free to contact me at ${widget.contact} for more information!",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),

      ],
    );
  }
}
