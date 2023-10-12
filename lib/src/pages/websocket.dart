import 'dart:async';

import 'package:crypto_watcher/src/components/coin_view.dart';
import 'package:crypto_watcher/src/models/coin.dart';
import 'package:crypto_watcher/src/service/bitbank_api.dart';
import 'package:crypto_watcher/src/service/bitflyer_api.dart';
import 'package:flutter/material.dart';

class WebsocketApi extends StatefulWidget {
  const WebsocketApi({super.key});

  @override
  State<WebsocketApi> createState() => _WebsocketApiState();
}

class _WebsocketApiState extends State<WebsocketApi> {
  BitbankApi bbApi = BitbankApi();
  BitflyerApi bfApi = BitflyerApi();

  Coin bitBankBTC = Coin("Bitbank", "");
  Coin bitBankETH = Coin("Bitbank", "");
  Coin bitflyerBTC = Coin("Bitflyer", "");
  Coin bitflyerETH = Coin("Bitflyer", "");

  @override
  void initState() {
    super.initState();

    bfApi.pongSender();
    bbApi.pongSender();
    // 25秒おきにpong返信
    Timer.periodic(const Duration(seconds: 25), (_) {
      bbApi.pongSender();
    });
    streamListener();
  }

  // 価格情報更新処理
  streamListener() async {
    bfApi.messageChannel(() => {
          setState(() {
            bitflyerBTC.price = BitflyerApi.coinPrices['btc'].toString();
            bitflyerETH.price = BitflyerApi.coinPrices['eth'].toString();
          })
        });

    bbApi.messageChannel(() => {
          setState(() {
            bitBankBTC.price = BitbankApi.coinPrices['btc'].toString();
            bitBankETH.price = BitbankApi.coinPrices['eth'].toString();
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
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text("Realtime Ticker",
            style: TextStyle(color: Colors.white)),
        actions: [],
      ),
      backgroundColor: Colors.blueAccent,
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(tabs: [
              Tab(
                child: Text(
                  "BTC/JPY",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "ETH/JPY",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "XRP/JPY",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: TabBarView(
              children: [
                  Center(
                    child: Column(
                      children: [
                        CoinView(coin: bitBankBTC),
                        CoinView(coin: bitflyerBTC),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        CoinView(coin: bitBankETH),
                        CoinView(coin: bitflyerETH),
                      ],
                    ),
                  ),
                  Center(child: Text("Under Constraction")),
              ],
            ),
                ))
          ],
        ),
      ),
    );
  }
}
