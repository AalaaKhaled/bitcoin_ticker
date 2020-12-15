import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'services/bitcoin.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  BitcoinModel bitcoinModel = BitcoinModel();
  String selectedCurrency = 'USD';
  Map<String, String> coinValues = {};
  bool isWaiting = false;
  String selectedCryptoCoin = 'BTC';
  //double bitcoinValue;
  DropdownButton<String> getDropdownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: getDropdownItems(),
      onChanged: (value) {
        setState(() async {
          selectedCurrency = value;
          updateUI();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  void updateUI() async {
    isWaiting = true;
    try {
      var data = await bitcoinModel.getRateBTC(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Column makeCards() {
    List<CryptoCard> cards = [];
    for (String cryptoCoin in cryptoList) {
      var newItem = CryptoCard(
        cryptoCurrency: cryptoCoin,
        value: isWaiting ? '?' : coinValues[cryptoCoin],
        selectedCurrency: selectedCurrency,
      );
      cards.add(newItem);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cards,
    );
  }

  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      items.add(newItem);
    }
    return items;
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        updateUI();
      },
      children: getCupertinoPickerItems(),
    );
  }

  List<Text> getCupertinoPickerItems() {
    List<Text> items = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      items.add(newItem);
    }
    return items;
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return getCupertinoPicker();
    } else if (Platform.isAndroid) {
      return getDropdownButton();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;
  const CryptoCard({
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
