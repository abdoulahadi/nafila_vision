import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String? image;
  const Description({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nafila Jour ...",
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(image!),
      ),
    );
  }
}
