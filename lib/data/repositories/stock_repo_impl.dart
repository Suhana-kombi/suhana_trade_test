import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class Repository {
  final String apiUrl = 'https://www.alphavantage.co/query';
  final client = http.Client();
  Future<Map<String, double>> fetchBatchStockPrices(
      List<String> symbols) async {
    final prices = <String, double>{};

    await Future.wait(symbols.map((symbol) async {
      try {
        final response = await client.get(Uri.parse(
            '$apiUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=EBSP14E9IZ2K7P0G'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          final stockPrice = data['Global Quote']['05. price'];
          final price = double.tryParse(stockPrice);
          if (price != null) {
            prices[symbol] = price;
          }
        }
      } catch (e) {
        if (e is NoSuchMethodError) {
          const SnackBar snackBar = SnackBar(
              content: Text(
                  'Alpha Vantage standard API call frequency is 5 calls per minute and 100 calls per day.'));
          snackbarKey.currentState?.showSnackBar(snackBar);
        }
      }
    }));

    return prices;
  }

  Future<List<dynamic>> searchCompanies(String query) async {
    try {
      final response = await client.get(Uri.parse(
          '$apiUrl?function=SYMBOL_SEARCH&keywords=$query&apikey=EBSP14E9IZ2K7P0G'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['bestMatches'] != null) {
          return data['bestMatches'];
        } else {
          return <dynamic>[];
        }
      }
    } catch (e) {
      // Todo
    }
    return <dynamic>[];
  }
}
