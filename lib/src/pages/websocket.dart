import 'dart:async';
import 'dart:convert';

import 'package:crypto_watcher/src/components/coin_view.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class WebsocketApi extends StatefulWidget {
  const WebsocketApi({super.key});

  @override
  State<WebsocketApi> createState() => _WebsocketApiState();
}

class _WebsocketApiState extends State<WebsocketApi> {
  final String prefix = "ticker_";
  String currency = "btc_jpy";
  String currencyEth = "eth_jpy";
  String btcJpyPrice = "0";
  String ethJpyPrice = "0";

  final channel = IOWebSocketChannel.connect(
      'wss://stream.bitbank.cc/socket.io/?EIO=3&transport=websocket');

  @override
  void initState() {
    super.initState();
    channel.sink.add("42[\"join-room\",\"$prefix$currency\"]");
    channel.sink.add("42[\"join-room\",\"$prefix$currencyEth\"]");

    Timer.periodic(const Duration(seconds: 25), (_) {
      channel.sink.add("42[\"join-room\",\"$prefix$currency\"]");
      channel.sink.add("42[\"join-room\",\"$prefix$currencyEth\"]");
    });
    streamListener();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  streamListener() async {
    channel.stream.listen((message) {
      var reg = RegExp(r'^\d*');
      var jsonStr = message.toString().replaceAll(reg, "");
      if (jsonStr.contains("message")) {
        var tickerData = json.decode(jsonStr)[1];
        setState(() {
          // extract last price
          if (tickerData["room_name"].toString().contains("btc")) {
            btcJpyPrice = tickerData["message"]["data"]["last"];
          } else if (tickerData["room_name"].toString().contains("eth")) {
            ethJpyPrice = tickerData["message"]["data"]["last"];
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CoinView(coinName: currency, price: btcJpyPrice),
            CoinView(coinName: currencyEth, price: ethJpyPrice)
          ],
        ),
      ),
    );
  }
}
