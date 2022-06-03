import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

String selectedCurrency = 'EUR';

CoinData coinData = CoinData(currency: selectedCurrency);

class _PriceScreenState extends State<PriceScreen> {
  CupertinoPicker iOSPicker() {
    List<Widget> dropDownItems = [];

    for (String coin in currenciesList) {
      var newItem = Text(coin);
      dropDownItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 28.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: dropDownItems,
    );
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String coin in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(coin),
        value: coin,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

   Map coinValues = {};
   bool isWaiting = false;

  void getData() async{
    isWaiting = true;
  try{
      Map data = await CoinData(currency: selectedCurrency).getCoinData();

      isWaiting = false;
      setState(() {
        coinValues =  data;
      });
  }catch(e){ print(e); }

}

  @override
  void initState() {
    super.initState();
    getData();
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
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CryptoCard(
                  cryptoCurrency: 'BTC',
                  value: isWaiting ? '?' : coinValues['BTC'],
                  selectedCurrency: selectedCurrency,

                ),
        CryptoCard(
          cryptoCurrency: 'ETH',
          value: isWaiting ? '?' : coinValues['ETH'],
          selectedCurrency: selectedCurrency,

        ),
                CryptoCard(
                  cryptoCurrency: 'LTC',
                  value: isWaiting ? '?' : coinValues['LTC'],
                  selectedCurrency: selectedCurrency,

                ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? androidDropDown() : iOSPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {

  CryptoCard({required this.value, required this.selectedCurrency, required this.cryptoCurrency});

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
