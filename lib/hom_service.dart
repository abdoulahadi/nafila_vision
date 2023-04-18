import 'package:flutter/material.dart';

import 'accueil.dart';
import 'quran.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildServiceCard(
              context, 'Nafila du Jour', 'Source Xurratul Ayni', Colors.blue,
              () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PageAccueil()));
          }),
          _buildServiceCard(
              context, 'Coran', 'Source API cdn.islamic.network', Colors.green,
              () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SouratesListScreen()));
          }),
          _buildServiceCard(context, 'Service 3', 'Description du service 3',
              Colors.deepOrange, () {}),
          _buildServiceCard(context, 'Service 4', 'Description du service 4',
              Colors.yellow, () {}),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title,
      String description, Color color, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              ),
              Text(
                description,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
