import 'package:flutter/material.dart';

class SalesButton extends StatelessWidget {
  const SalesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
      BoxConstraints.tightFor(width: 100, height: 40),
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              buyButtonClicked = true;
              sellButtonClicked = false;
            });
          },
          child: Text(
            "BUY",
            style: TextStyle(
              fontSize: 15,
            ),
          ) //BUY Button
      ),
    );
  }
}
