import 'dart:convert';

class Sourate {
  final int position;
  final String nom;
  final String nomPhonetique;
  final String englishNameTranslation;
  final String revelation;
  final List<Verset> versets;
  final String nomSourate;

  Sourate({
    required this.position,
    required this.nom,
    required this.nomPhonetique,
    required this.englishNameTranslation,
    required this.revelation,
    required this.versets,
    required this.nomSourate,
  });

  static Sourate fromJson(Map<String, dynamic> json) {
    return Sourate(
      position: json['position'],
      nom: json['nom'],
      nomPhonetique: json['nom_phonetique'],
      englishNameTranslation: json['englishNameTranslation'],
      revelation: json['revelation'],
      versets:
          (json['versets'] as List).map((v) => Verset.fromJson(v)).toList(),
      nomSourate: json['nom_sourate'],
    );
  }
}

class Verset {
  final int position;
  final String text;
  final int positionDsSourate;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;
  final String textArabe;

  Verset({
    required this.position,
    required this.text,
    required this.positionDsSourate,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
    required this.textArabe,
  });

  static Verset fromJson(Map<String, dynamic> json) {
    return Verset(
      position: json['position'],
      text: json['text'],
      positionDsSourate: json['position_ds_sourate'],
      juz: json['juz'] ?? 0,
      manzil: json['manzil'] ?? 0,
      page: json['page'] ?? 0,
      ruku: json['ruku'] ?? 0,
      hizbQuarter: json['hizbQuarter'] ?? 0,
      sajda: json['sajda'] is bool ? json['sajda'] : false,
      textArabe: json['text_arabe'],
    );
  }
}

class Quran {
  static List<Sourate> getListeSourates(String jsonStr) {
    final jsonList = json.decode(jsonStr)['sourates'];
    return List<Sourate>.from(jsonList.map((json) => Sourate.fromJson(json)));
  }
}
