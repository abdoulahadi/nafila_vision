// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:nafila_mouride_vision/description.dart';
import 'liste_image.dart';

class PageAccueil extends StatefulWidget {
  const PageAccueil({Key? key}) : super(key: key);

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Naafila du Mois de Ramadan"),
      ),
      body: GridView.builder(
        // ignore: non_constant_identifier_names
        itemBuilder: (BuildContext, index) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Description(image: images[index])));
              },
              child: GridTile(
                child: CircleAvatar(
                  backgroundImage: AssetImage(images[index]),
                ),
                footer: Text("Nuit du Jour ${index + 1}"),
              ),
            ),
          );
        },
        itemCount: images.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(1),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
      ),
    );
  }
}
