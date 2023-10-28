import 'dart:convert';
import 'package:crypto_watcher/src/constants.dart';
import 'package:web_socket_channel/io.dart';

class BitbankApi {
  final String _prefix = "ticker_";
  final String _currencySuffix = "_jpy";
  List<String> coinNames = ["btc", "eth", "xrp"];
  static Map<String, String> coinPrices = {'btc': "0", 'eth': "0", 'xrp': "0"};
  final _channel = IOWebSocketChannel.connect(
      'wss://stream.bitbank.cc/socket.io/?EIO=3&transport=websocket');

  // Bitbank クライアント接続処理
  void pongSender() {
    for (var coinName in coinNames) {
      _channel.sink
          .add("42[\"join-room\",\"$_prefix$coinName$_currencySuffix\"]");
    }
  }


  void closeChannel() {
    _channel.sink.close();
  }

  // ticker情報　受け取り　コールバックで更新処理
  void messageChannel(Function updateFunction) async {
    _channel.stream.listen((message) {
      var reg = RegExp(r'^\d*');
      var jsonStr = message.toString().replaceAll(reg, "");
      if (jsonStr.contains("message")) {
        var tickerData = json.decode(jsonStr)[1];
        // extract last price
        var roomName = tickerData["room_name"].toString();
        String last = tickerData["message"]["data"]["last"];
        String lastPrice = last.replaceAllMapped(Define.div3Format, (match) => '${match[1]},');
        switch(roomName) {
          case "ticker_btc_jpy":
            coinPrices['btc'] = lastPrice;
            break;
          case "ticker_eth_jpy":
            coinPrices['eth'] = lastPrice;
            break;
          case "ticker_xrp_jpy":
            coinPrices['xrp'] = lastPrice;
            break;
          default:
            break;
        }
      }
      updateFunction();
    }, onError: (error) {
      print('Error in Websocket communication: $error');
    });
  }
}
