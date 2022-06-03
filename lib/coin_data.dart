import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '0E9E70F8-1656-48F4-B978-FA4C6BB7DF45';
const url = 'https://rest.coinapi.io/v1/exchangerate';

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

  CoinData({required this.currency});
  String currency;

  Future getCoinData() async{
    //var link = Uri.parse('${url}/${crypto}/${currency}?apikey=${apiKey}');
   // var response = await http.get(link);

    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList){
      var requestURL = Uri.parse('$url/$crypto/$currency?apikey=$apiKey');
      http.Response response = await http.get(requestURL);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];

        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }

    return cryptoPrices;

    }

  }

