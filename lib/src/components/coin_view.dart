import 'package:flutter/material.dart';

class CoinView extends StatelessWidget {
  const CoinView({super.key, required this.coinName, required this.price});

  final String coinName;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          coinName.toUpperCase().replaceAll("_", "/"),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            price,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 24),
          ),
        ),
      ],
    );
  }
}
