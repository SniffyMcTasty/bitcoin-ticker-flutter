import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Map<String, Map<String, double?>> cryptoMap = {
    for (String i in cryptoList)
      i: {
        for (String j in currenciesList) j: null,
      },
  };

  Future<void> getData() async {
    // create filtered list for currency in https response
    String concatenatedCryptoList = '';
    for (String i in currenciesList) concatenatedCryptoList += '$i,';
    concatenatedCryptoList.substring(0, concatenatedCryptoList.length - 2);

    // make a request for each type of crypto
    for (MapEntry<String, Map<String, double?>> mapEntry in cryptoMap.entries) {
      Uri uri =
          Uri.https('rest.coinapi.io', '/v1/exchangerate/${mapEntry.key}', {
        'filter_asset_id': concatenatedCryptoList,
        'apikey': 'AA03B24B-C792-4C45-9C4E-8B897AF8A954',
      });
      http.Response response = await http.get(uri);

      // if successful, insert result in
      if (response.statusCode == 200) {
        for (var i in jsonDecode(response.body)['rates']) {
          mapEntry.value[i['asset_id_quote']] = i['rate'];
        }
      } else {
        print(response.statusCode);
        print(response.headers);
      }
    }
  }
}
