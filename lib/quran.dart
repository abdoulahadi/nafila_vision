// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nafila_mouride_vision/quran_json.dart';
import 'package:nafila_mouride_vision/verset_screen.dart';

// import 'data_service.dart';
import 'models/sourates.dart';
// import 'package:flutter/services.dart';

class SouratesListScreen extends StatefulWidget {
  const SouratesListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SouratesListScreenState createState() => _SouratesListScreenState();
}

class _SouratesListScreenState extends State<SouratesListScreen> {
  // // ignore: unused_field
  List<Sourate> _sourates = [];

  @override
  void initState() {
    super.initState();
    _loadSourates();
  }

  Future<void> _loadSourates() async {
    try {
      List<Sourate> listeSourates = Quran.getListeSourates(quranJson);
      // print(listeSourates);
      setState(() {
        _sourates = listeSourates;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des sourates'),
      ),
      body: _sourates.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _sourates.length,
              itemBuilder: (context, index) {
                final sourate = _sourates[index];
                return ListTile(
                  title: Text(sourate.nom),
                  subtitle: Text(sourate.nomPhonetique),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VersetListScreen(sourate: sourate),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

