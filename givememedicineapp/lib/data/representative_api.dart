import 'dart:async';

import 'package:http/http.dart' as http;

class RepresentativeApi {
  static Future getRepresentative({required String ph, required String pas}) {
    return http.get(Uri.parse(
        'http://192.168.56.1:8000/api/sales-representative/?ph=$ph&pas=$pas'));
  }
}
