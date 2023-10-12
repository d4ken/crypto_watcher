import 'package:crypto_watcher/src/models/coin.dart';
import 'package:flutter/material.dart';

class CoinView extends StatelessWidget {
  const CoinView({super.key, required this.coin});

  final Coin coin;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Text(
            coin.name.toUpperCase().replaceAll("_", "/"),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            coin.price,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 24),
          ),
        ),
      ],
    );
  }
}
