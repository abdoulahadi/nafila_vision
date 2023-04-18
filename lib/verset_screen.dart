// import 'package:flutter/material.dart';

// import 'models/sourates.dart';

// class VersetListScreen extends StatelessWidget {
//   final Sourate sourate;

//   const VersetListScreen({Key? key, required this.sourate}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(sourate.nom),
//       ),
//       body: ListView.builder(
//         itemCount: sourate.versets.length,
//         itemBuilder: (context, index) {
//           final verset = sourate.versets[index];
//           return Card(
//             child: ListTile(
//               contentPadding: const EdgeInsets.all(12),
//               title: Text(
//                 '${verset.positionDsSourate}. ${verset.textArabe}',
//                 style: const TextStyle(
//                   fontSize: 25.0,
//                 ),
//                 textDirection: TextDirection.rtl,
//               ),
//               subtitle: Text(
//                 '${verset.positionDsSourate}. ${verset.text}',
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'models/sourates.dart';

class VersetListScreen extends StatefulWidget {
  final Sourate sourate;

  const VersetListScreen({Key? key, required this.sourate}) : super(key: key);

  @override
  _VersetListScreenState createState() => _VersetListScreenState();
}

class _VersetListScreenState extends State<VersetListScreen> {
  List<Verset> _versets = [];
  bool _downloading = false;
  bool _hasPermission = false;
  bool _isPlaying = false;
  AudioPlayer? _audioPlayer;
  int _currentTrack = 0;
  final audioCacheManager = CacheManager(
    Config(
      'audio_cache',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 100,
    ),
  );

  @override
  void initState() {
    super.initState();
    _loadVerset();
  }

  Future<void> _loadVerset() async {
    try {
      List<Verset> listeVerset = widget.sourate.versets;
      setState(() {
        _versets = listeVerset;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    if (statuses[Permission.storage] == PermissionStatus.granted) {
      setState(() {
        _hasPermission = true;
      });
    }
  }

  Future<void> _downloadAudio(int ayahNumber) async {
    setState(() {
      _downloading = true;
    });
    String edition = "ar.alafasy";
    String bitrate = "128";
    String number = ayahNumber.toString();
    String url =
        "https://cdn.islamic.network/quran/audio/$bitrate/$edition/$number.mp3";

    Dio dio = Dio();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    String filePath =
        "$appDocPath/${widget.sourate.englishNameTranslation}_${ayahNumber.toString()}.mp3";
    try {
      Response response = await dio.download(url, filePath);
      print(response);
      Fluttertoast.showToast(msg: "Téléchargement terminé");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Erreur de téléchargement");
    }

    setState(() {
      _downloading = false;
    });
  }

  Future<void> _playTrack(int trackIndex) async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
    }

    String edition = "ar.alafasy";
    String bitrate = "128";
    String number = _versets[trackIndex].position.toString();
    String fileName = "${widget.sourate.englishNameTranslation}_${number}.mp3";
    String localFilePath =
        "${(await getApplicationDocumentsDirectory()).path}/$fileName";

    // Vérifier si le fichier existe localement
    final file = File(localFilePath);
    if (await file.exists()) {
      // Fichier existe, le lire
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.play(DeviceFileSource(localFilePath));
      setState(() {
        _isPlaying = true;
        _currentTrack = trackIndex;
      });

      // Ecouter l'événement de fin de lecture
      _audioPlayer!.onPlayerStateChanged.listen((playerState) {
        if (playerState == PlayerState.completed) {
          // Passer automatiquement à la piste suivante
          if (_currentTrack < _versets.length - 1) {
            _playTrack(_currentTrack + 1);
          }
        }
      });
    } else {
      // Fichier non trouvé localement, le télécharger
      setState(() {
        _downloading = true;
      });

      String url =
          "https://cdn.islamic.network/quran/audio/$bitrate/$edition/$number.mp3";

      Dio dio = Dio();
      try {
        await dio.download(url, localFilePath);
        print("Téléchargement terminé");
      } catch (e) {
        print("Erreur de téléchargement : $e");
        setState(() {
          _downloading = false;
        });
        return;
      }

      setState(() {
        _downloading = false;
      });

      // Lire le fichier téléchargé
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.play(DeviceFileSource(localFilePath));
      setState(() {
        _isPlaying = true;
        _currentTrack = trackIndex;
      });

      // Ecouter l'événement de fin de lecture
      _audioPlayer!.onPlayerStateChanged.listen((playerState) {
        if (playerState == PlayerState.completed) {
          // Passer automatiquement à la piste suivante
          if (_currentTrack < _versets.length - 1) {
            _playTrack(_currentTrack + 1);
          }
        }
      });
    }
  }

  Future<void> _pauseTrack() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sourate.nomPhonetique),
        actions: const [
          // IconButton(
          //   icon: Icon(Icons.download),
          //   onPressed: () async {
          //     await _requestPermission();
          //     if (_hasPermission) {
          //       for (var i = 0; i < _versets.length; i++) {
          //         await _downloadAudio(_versets[i].position);
          //       }
          //     }
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _versets.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 12,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _versets[index].textArabe,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 36),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _versets[index].text,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: () {
                                // Reload function here
                              },
                            ),
                            IconButton(
                              icon: _isPlaying && _currentTrack == index
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow),
                              onPressed: () {
                                if (_isPlaying && _currentTrack == index) {
                                  _pauseTrack();
                                } else {
                                  _playTrack(index);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.stop),
                              onPressed: () {
                                // Stop function here
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            if (_downloading)
              Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}
