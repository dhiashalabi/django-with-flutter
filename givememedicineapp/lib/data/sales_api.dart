import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class SalesApi {
  static Future postSale(body) {
    return http.post(Uri.parse('http://192.168.56.1:8000/api/sales/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
  }
}
