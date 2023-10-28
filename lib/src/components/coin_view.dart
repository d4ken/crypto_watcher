import 'package:crypto_watcher/src/models/coin.dart';
import 'package:flutter/material.dart';

class CoinView extends StatelessWidget {
  const CoinView({Key? key, required this.coin}) : super(key: key);

  final Coin coin;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey[400],
      height: 50,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Text(
              coin.name.toUpperCase().replaceAll("_", "/"),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              coin.price,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
