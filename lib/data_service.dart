import 'dart:convert';
import 'package:nafila_mouride_vision/quran_json.dart';

import 'models/sourates.dart';

class DataService {
  Future<List<Sourate>> getSourates() async {
    Map<String, dynamic> quranMap = await jsonDecode(quranJson);
    List<Sourate> souratesList = quranMap['sourates'];

    // ignore: avoid_print
    print(souratesList);
    // final sourates = jsonData.map((e) => Sourate.fromJson(e)).toList();

    return souratesList;
  }
}
