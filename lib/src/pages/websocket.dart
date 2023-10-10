import 'dart:async';

import 'package:crypto_watcher/src/components/coin_view.dart';
import 'package:crypto_watcher/src/service/bitbank_api.dart';
import 'package:flutter/material.dart';

class WebsocketApi extends StatefulWidget {
  const WebsocketApi({super.key});

  @override
  State<WebsocketApi> createState() => _WebsocketApiState();
}

class _WebsocketApiState extends State<WebsocketApi> {
  BitbankApi bbApi = BitbankApi();
  String btcPrice = "";
  String ethPrice = "";
  String xrpPrice = "";

  @override
  void initState() {
    super.initState();
    bbApi.pongSender();
    // 25秒おきにpong返信
    Timer.periodic(const Duration(seconds: 25), (_) {
      bbApi.pongSender();
    });
    streamListener();
  }

  // 価格情報更新処理
  streamListener() async {
    bbApi.messageChannel(() => {
          setState(() {
            btcPrice = BitbankApi.coinPrices['btc'].toString();
            ethPrice = BitbankApi.coinPrices['eth'].toString();
            xrpPrice = BitbankApi.coinPrices['xrp'].toString();
          })
        });
  }

  @override
  void dispose() {
    bbApi.closeChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CoinView(coinName: bbApi.coinNames[0], price: btcPrice),
            CoinView(coinName: bbApi.coinNames[1], price: ethPrice),
            CoinView(coinName: bbApi.coinNames[2], price: xrpPrice),
          ],
        ),
      ),
    );
  }
}
