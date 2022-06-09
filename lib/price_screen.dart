import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  CoinData coinData = CoinData();
  Color cardColor = Colors.lightBlueAccent;

  DropdownButton<String> androidDropdown() {
    return DropdownButton(
      items: [
        for (String i in currenciesList)
          DropdownMenuItem(
            child: Text(i),
            value: i,
          ),
      ],
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          if (value != null) {
            {
              selectedCurrency = value;
            }
          }
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
      },
      children: [
        for (String i in currenciesList) Text(i),
      ],
    );
  }

  Widget cryptoCard(String crypto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Card(
        color: cardColor,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = ${coinData.cryptoMap[crypto]?[selectedCurrency]?.toStringAsFixed(0) ?? '???'} $selectedCurrency',
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

  void updateData() async {
    // whiten the cards to show that something is loading
    setState(() {
      cardColor = Colors.lightBlueAccent.shade100;
    });
    // wait until new data done being queried
    await coinData.getData();
    // set the color back to normal
    setState(() {
      cardColor = Colors.lightBlueAccent;
    });
  }

  @override
  void initState() {
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (String i in cryptoList) cryptoCard(i),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  updateData();
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    'Update Data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
