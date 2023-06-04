import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappWidget extends StatefulWidget {
  final String imageURL, name, salesType;
  final int price;

  const WhatsappWidget({super.key, required this.salesType, required this.imageURL, required this.name, required this.price});

  @override
  State<WhatsappWidget> createState() => _WhatsappWidgetState();
}

class _WhatsappWidgetState extends State<WhatsappWidget> {
  void launchWhatsApp(String phone, String message) {
    final Uri whatsApp = Uri.parse("https://wa.me/6$phone?text=$message");
    launchUrl(
      whatsApp,
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        String message =
            "${widget.imageURL}\nHi, I am interested in ${widget.name} which is for ${widget.salesType} at RM${widget.price}.";
        launchWhatsApp("0143096966", message);
      },
      child: IgnorePointer(
        child: SizedBox(
          height: 60,
          width: 250,
          child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Contact Me"),
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "assets/images/whatsapp.png",
                    width: 20,
                    height: 20,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
