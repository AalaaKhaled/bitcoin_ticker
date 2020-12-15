import 'networking.dart';
import 'package:bitcoin_ticker/coin_data.dart';

const apiKey = '2002592A-5411-42FC-9FEB-6375ABCFA891';
const baseURL = 'https://rest.coinapi.io/v1/exchangerate';

class BitcoinModel {
  Future getRateBTC(String currency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      NetworkHelper networkHelper =
          NetworkHelper(url: '$baseURL/$crypto/$currency?apikey=$apiKey');
      var data = await networkHelper.getData();
      double rate = data['rate'];
      cryptoPrices[crypto] = rate.toStringAsFixed(0);
    }
    return cryptoPrices;
  }
}
