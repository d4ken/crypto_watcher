import 'dart:convert';
import 'package:crypto_watcher/src/constants.dart';
import 'package:web_socket_channel/io.dart';

class BitflyerApi {
  List<String> coinNames = ["BTC", "ETH"];
  static Map<String, String> coinPrices = {'btc': "0", 'eth': "0", 'xrp': "0"};
  final _channel = IOWebSocketChannel.connect(
      'wss://ws.lightstream.bitflyer.com/json-rpc');
  // Bitbank クライアント接続処理
  void pongSender() {
      _channel.sink.add(json.encode(Define.spotBTC));
      _channel.sink.add(json.encode(Define.spotETH));
  }

  void closeChannel() {
    _channel.sink.close();
  }

  // ticker情報　受け取り　コールバックで更新処理
  void messageChannel(Function updateFunction) async {
    _channel.stream.listen((message) {
      var tickerData = json.decode(message);
      String productCode = tickerData["params"]["message"]["product_code"];
      String ask = (tickerData["params"]["message"]["best_ask"]).toInt().toString();
      String askFormat = ask.replaceAllMapped(Define.div3Format, (match) => '${match[1]},');
      switch(productCode) {
        case "BTC_JPY":
          coinPrices['btc'] = askFormat;
          break;
        case "ETH_JPY":
          coinPrices['eth'] = askFormat;
          break;
        // case "ticker_xrp_jpy":
        //   coinPrices['xrp'] = lastPrice;
        //   break;
        default:
          break;
      }
    updateFunction();
    });
  }
}
