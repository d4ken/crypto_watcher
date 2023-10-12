class Define {
  static RegExp div3Format = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  static const List<Map<String, Object>> spotBTC = [
    {'method': "subscribe", 'params': {
      'channel': "lightning_ticker_BTC_JPY"
    }},
  ];

  static const List<Map<String, Object>> spotETH = [
    {'method': "subscribe", 'params': {
      'channel': "lightning_ticker_ETH_JPY"
    }},
  ];
}