import 'dart:io';
//import 'dart:convert';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:http/http.dart' as http;
import 'package:postgres/postgres.dart';

//https://pub.dev/packages/firebase_ml_vision

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File pickedImage;
  bool isImageLoaded = false;
  DateTime date = DateTime.now();

  pickImage() async {
    // ignore: deprecated_member_use
    File tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  //VARIABLES GLOBALES

  //integer

  // ignore: non_constant_identifier_names
  int cc_pres = 0,
      // ignore: non_constant_identifier_names
      cc_dip = 0,
      // ignore: non_constant_identifier_names
      fpv_pres = 0,
      // ignore: non_constant_identifier_names
      fpv_dip = 0,
      // ignore: non_constant_identifier_names
      mts_pres = 0,
      // ignore: non_constant_identifier_names
      mts_dip = 0,
      // ignore: non_constant_identifier_names
      ucs_pres = 0,
      // ignore: non_constant_identifier_names
      ucs_dip = 0,
      // ignore: non_constant_identifier_names
      mas_pres = 0,
      // ignore: non_constant_identifier_names
      mas_dip = 0,
      // ignore: non_constant_identifier_names
      f21_pres = 0,
      // ignore: non_constant_identifier_names
      f21_dip = 0,
      // ignore: non_constant_identifier_names
      pdc_pres = 0,
      // ignore: non_constant_identifier_names
      pdc_dip = 0,
      // ignore: non_constant_identifier_names
      mnr_pres = 0,
      // ignore: non_constant_identifier_names
      mnr_dip = 0,
      // ignore: non_constant_identifier_names
      pan_pres = 0,
      // ignore: non_constant_identifier_names
      pan_dip = 0,
      // ignore: non_constant_identifier_names
      blancos_pres = 0,
      // ignore: non_constant_identifier_names
      blancos_dip = 0,
      // ignore: non_constant_identifier_names
      nulos_pres = 0,
      // ignore: non_constant_identifier_names
      nulos_dip = 0;

  Future readText() async {
    //VARIABLES

    //boolean
    bool existePresCC = false,
        existeDipCC = false,
        existePresFPV = false,
        existeDipFPV = false,
        existePresMTS = false,
        existeDipMTS = false,
        existePresUCS = false,
        existeDipUCS = false,
        existePresMAS = false,
        existeDipMAS = false,
        existePres21F = false,
        existeDip21F = false,
        existePresPDC = false,
        existeDipPDC = false,
        existePresMNR = false,
        existeDipMNR = false,
        existePresPAN = false,
        existeDipPAN = false,
        existePresBlancos = false,
        existeDipBlancos = false,
        existePresNulos = false,
        existeDipNulos = false;

    //String
    String presCC = "",
        dipCC = "",
        presFPV = "",
        dipFPV = "",
        presMTS = "",
        dipMTS = "",
        presUCS = "",
        dipUCS = "",
        presMAS = "",
        dipMAS = "",
        pres21F = "",
        dip21F = "",
        presPDC = "",
        dipPDC = "",
        presMNR = "",
        dipMNR = "",
        presPAN = "",
        dipPAN = "",
        presBlancos = "",
        dipBlancos = "",
        presNulos = "",
        dipNulos = "";

    //var regex
    var numRegex = RegExp("\\b([1234567890o])", caseSensitive: false);
    var ccRegex = RegExp("\\b(C.C.)", caseSensitive: false);
    var fpvRegex = RegExp("\\b(FPV)", caseSensitive: false);
    var mtsRegex = RegExp("\\b(MTS)", caseSensitive: false);
    var ucsRegex = RegExp("\\b(UCS)", caseSensitive: false);
    var masRegex = RegExp("\\b(MAS-IPSP)", caseSensitive: false);
    var f21Regex = RegExp("\\b(21F)", caseSensitive: false);
    var pdcRegex = RegExp("\\b(PDC)", caseSensitive: false);
    var mnrRegex = RegExp("\\b(MNR)", caseSensitive: false);
    var panRegex = RegExp("\\b(PAN-BOL)", caseSensitive: false);
    var blancosRegex = RegExp("\\b(BLANCOS)", caseSensitive: false);
    var nulosRegex = RegExp("\\b(NULOS)", caseSensitive: false);

    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          // print(word.text);

          // recopilacion de datos
          if (ccRegex.hasMatch(word.text) || existePresCC || existeDipCC) {
            //la primera vez, entra con el regex,
            //la segunda vez entra por los existe xd
            //la tercera vez entra por dip
            if (!existePresCC && !existeDipCC) {
              existePresCC = true;
              existeDipCC = true;
            } else if (existePresCC) {
              if (numRegex.hasMatch(word.text)) {
                presCC = presCC + word.text;
              } else {
                print("CC Presidente: " + presCC);
                if (presCC != "") {
                  cc_pres = int.parse(presCC);
                }
                existePresCC = false;
              }
            } else if (existeDipCC) {
              if (numRegex.hasMatch(word.text)) {
                dipCC = dipCC + word.text;
              } else {
                print("CC Diputado: " + dipCC);
                if (dipCC != "") {
                  cc_dip = int.parse(dipCC);
                }
                existeDipCC = false;
              }
            }
          }

          if (fpvRegex.hasMatch(word.text) || existePresFPV || existeDipFPV) {
            if (!existePresFPV && !existeDipFPV) {
              existePresFPV = true;
              existeDipFPV = true;
            } else if (existePresFPV) {
              if (numRegex.hasMatch(word.text)) {
                presFPV = presFPV + word.text;
              } else {
                print("FPV Presidente: " + presFPV);
                if (presFPV != "") {
                  fpv_pres = int.parse(presFPV);
                }
                existePresFPV = false;
              }
            } else if (existeDipFPV) {
              if (numRegex.hasMatch(word.text)) {
                dipFPV = dipFPV + word.text;
              } else {
                print("FPV Diputado: " + dipFPV);
                if (dipFPV != "") {
                  fpv_dip = int.parse(dipFPV);
                }
                existeDipFPV = false;
              }
            }
          }

          if (mtsRegex.hasMatch(word.text) || existePresMTS || existeDipMTS) {
            if (!existePresMTS && !existeDipMTS) {
              existePresMTS = true;
              existeDipMTS = true;
            } else if (existePresMTS) {
              if (numRegex.hasMatch(word.text)) {
                presMTS = presMTS + word.text;
              } else {
                print("MTS Presidente: " + presMTS);
                if (presMTS != "") {
                  mts_pres = int.parse(presMTS);
                }
                existePresMTS = false;
              }
            } else if (existeDipMTS) {
              if (numRegex.hasMatch(word.text)) {
                dipMTS = dipMTS + word.text;
              } else {
                print("MTS Diputado: " + dipMTS);
                if (dipMTS != "") {
                  mts_dip = int.parse(dipMTS);
                }
                existeDipMTS = false;
              }
            }
          }

          if (ucsRegex.hasMatch(word.text) || existePresUCS || existeDipUCS) {
            if (!existePresUCS && !existeDipUCS) {
              existePresUCS = true;
              existeDipUCS = true;
            } else if (existePresUCS) {
              if (numRegex.hasMatch(word.text)) {
                presUCS = presUCS + word.text;
              } else {
                print("UCS Presidente: " + presUCS);
                if (presUCS != "") {
                  ucs_pres = int.parse(presUCS);
                }
                existePresUCS = false;
              }
            } else if (existeDipUCS) {
              if (numRegex.hasMatch(word.text)) {
                dipUCS = dipUCS + word.text;
              } else {
                print("UCS Diputado: " + dipUCS);
                if (dipUCS != "") {
                  ucs_dip = int.parse(dipUCS);
                }
                existeDipUCS = false;
              }
            }
          }

          if (masRegex.hasMatch(word.text) || existePresMAS || existeDipMAS) {
            if (!existePresMAS && !existeDipMAS) {
              existePresMAS = true;
              existeDipMAS = true;
            } else if (existePresMAS) {
              if (numRegex.hasMatch(word.text) &&
                  !f21Regex.hasMatch(word.text)) {
                presMAS = presMAS + word.text;
              } else {
                print("MAS Presidente: " + presMAS);
                if (presMAS != "") {
                  mas_pres = int.parse(presMAS);
                }
                existePresMAS = false;
              }
            } else if (existeDipMAS) {
              if (numRegex.hasMatch(word.text) &&
                  !f21Regex.hasMatch(word.text)) {
                dipMAS = dipMAS + word.text;
              } else {
                dipMAS = dipMAS.replaceAll(new RegExp(r'O'), '0');
                print("MAS Diputado: " + dipMAS);
                if (dipMAS != "") {
                  mas_dip = int.parse(dipMAS);
                }
                existeDipMAS = false;
              }
            }
          }

          if (f21Regex.hasMatch(word.text) || existePres21F || existeDip21F) {
            if (!existePres21F && !existeDip21F) {
              existePres21F = true;
              existeDip21F = true;
            } else if (existePres21F) {
              if (numRegex.hasMatch(word.text) &&
                  !f21Regex.hasMatch(word.text)) {
                pres21F = pres21F + word.text;
              } else {
                print("21F Presidente: " + pres21F);
                if (pres21F != "") {
                  f21_pres = int.parse(pres21F);
                }
                existePres21F = false;
              }
            } else if (existeDip21F) {
              if (numRegex.hasMatch(word.text) &&
                  !f21Regex.hasMatch(word.text)) {
                dip21F = dip21F + word.text;
              } else {
                print("21F Diputado: " + dip21F);
                if (dip21F != "") {
                  f21_dip = int.parse(dip21F);
                }
                existeDip21F = false;
              }
            }
          }

          if (pdcRegex.hasMatch(word.text) || existePresPDC || existeDipPDC) {
            if (!existePresPDC && !existeDipPDC) {
              existePresPDC = true;
              existeDipPDC = true;
            } else if (existePresPDC) {
              if (numRegex.hasMatch(word.text)) {
                presPDC = presPDC + word.text;
              } else {
                print("PDC Presidente: " + presPDC);
                if (presPDC != "") {
                  pdc_pres = int.parse(presPDC);
                }
                existePresPDC = false;
              }
            } else if (existeDipPDC) {
              if (numRegex.hasMatch(word.text)) {
                dipPDC = dipPDC + word.text;
              } else {
                print("PDC Diputado: " + dipPDC);
                if (dipPDC != "") {
                  pdc_dip = int.parse(dipPDC);
                }
                existeDipPDC = false;
              }
            }
          }

          if (mnrRegex.hasMatch(word.text) || existePresMNR || existeDipMNR) {
            if (!existePresMNR && !existeDipMNR) {
              existePresMNR = true;
              existeDipMNR = true;
            } else if (existePresMNR) {
              if (numRegex.hasMatch(word.text)) {
                presMNR = presMNR + word.text;
              } else {
                print("MNR Presidente: " + presMNR);
                if (presMNR != "") {
                  mnr_pres = int.parse(presMNR);
                }
                existePresMNR = false;
              }
            } else if (existeDipMNR) {
              if (numRegex.hasMatch(word.text)) {
                dipMNR = dipMNR + word.text;
              } else {
                print("MNR Diputado: " + dipMNR);
                if (dipMNR != "") {
                  mnr_dip = int.parse(dipMNR);
                }
                existeDipMNR = false;
              }
            }
          }

          if (panRegex.hasMatch(word.text) || existePresPAN || existeDipPAN) {
            if (!existePresPAN && !existeDipPAN) {
              existePresPAN = true;
              existeDipPAN = true;
            } else if (existePresPAN) {
              if (numRegex.hasMatch(word.text)) {
                presPAN = presPAN + word.text;
              } else {
                print("PANBOL Presidente: " + presPAN);
                if (presPAN != "") {
                  pan_pres = int.parse(presPAN);
                }
                existePresPAN = false;
              }
            } else if (existeDipPAN) {
              if (numRegex.hasMatch(word.text)) {
                dipPAN = dipPAN;
              } else {
                print("PANBOL Diputado: " + dipPAN);
                if (dipPAN != "") {
                  pan_dip = int.parse(dipPAN);
                }
                existeDipPAN = false;
              }
            }
          }

          if (blancosRegex.hasMatch(word.text) ||
              existePresBlancos ||
              existeDipBlancos) {
            if (!existePresBlancos && !existeDipBlancos) {
              existePresBlancos = true;
              existeDipBlancos = true;
            } else if (existePresBlancos) {
              if (numRegex.hasMatch(word.text)) {
                presBlancos = presBlancos + word.text;
              } else {
                print("Votos blancos para Presidente: " + presBlancos);
                if (presBlancos != "") {
                  blancos_pres = int.parse(presBlancos);
                }
                existePresBlancos = false;
              }
            } else if (existeDipBlancos) {
              if (numRegex.hasMatch(word.text)) {
                dipBlancos = dipBlancos + word.text;
              } else {
                print("Votos blancos para Diputado: " + dipBlancos);
                if (dipBlancos != "") {
                  blancos_dip = int.parse(dipBlancos);
                }
                existeDipBlancos = false;
              }
            }
          }

          if (nulosRegex.hasMatch(word.text) ||
              existePresNulos ||
              existeDipNulos) {
            if (!existePresNulos && !existeDipNulos) {
              existePresNulos = true;
              existeDipNulos = true;
            } else if (existePresNulos) {
              if (numRegex.hasMatch(word.text)) {
                presNulos = presNulos + word.text;
              } else {
                print("Votos nulos para Presidente: " + presNulos);
                if (presNulos != "") {
                  nulos_pres = int.parse(presNulos);
                }
                existePresNulos = false;
              }
            } else if (existeDipNulos) {
              if (numRegex.hasMatch(word.text)) {
                dipNulos = dipNulos + word.text;
              } else {
                print("Votos nulos para Diputado: " + dipNulos);
                if (dipNulos != "") {
                  nulos_dip = int.parse(dipNulos);
                }
                existeDipNulos = false;
              }
            }
          }
          // fin
        }
      }
    }
  }

  int _currentIndex = 1;

  Future connectionPostgres() async {
    List<String> recintos = [];
    List<int> idRecintos = [];
    final conn = PostgreSQLConnection(
      "192.168.0.13",
      5432,
      "segparcialsw1",
      username: "postgres",
      password: "123",
    );
    await conn.open();

    if (!conn.isClosed) {
      print("Si conecto");

      var results = await conn.query("SELECT * from votos_recinto");
      for (var row in results) {
        print('''
        id: ${row[0]}
        nombre: ${row[1]}
        ''');
      }

      var results2 = await conn.query("SELECT nombre_rec from votos_recinto");
      for (var row in results2) {
        recintos.add('${row[0]}');
      }

      var results3 = await conn.query("SELECT id from votos_recinto");
      for (var row in results3) {
        idRecintos.add(int.parse('${row[0]}'));
      }

      print(recintos);
      print(idRecintos);

      // await conn.query('''
      //   INSERT INTO votos_departamento (nombre_dep)
      //   VALUES ('$dep')
      // ''');

    }

    _selectRecinto(recintos, idRecintos);

    await conn.close();
  }

  Future<String> _selectRecinto(List<String> recintos, List<int> idRec) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return AlertDialog(
                title: Text('Seleccionar Recinto'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text('Cancelar'),
                  ),
                  FlatButton(
                    onPressed: () {
                      var pos = idRec[_currentIndex];
                      _asyncInputDialog(pos);
                    },
                    child: Text('Aceptar'),
                  ),
                ],
                content: Container(
                  width: double.minPositive,
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: recintos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                        value: index,
                        groupValue: _currentIndex,
                        title: Text(recintos[index]),
                        onChanged: (val) {
                          setState2(() {
                            _currentIndex = val;
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  Future _asyncInputDialog(int fkey) async {
    String idMesa = '';
    return showDialog(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Indique el codigo de Mesa'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration:
                    new InputDecoration(labelText: 'Mesa:', hintText: '#1'),
                onChanged: (value) {
                  idMesa = value;
                },
              ))
            ],
          ),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                _textDialog(idMesa, fkey);
              },
            ),
          ],
        );
      },
    );
  }

  void _textDialog(String mesa, int fkey) {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("Desea ingresar los datos obtenidos ?"),
            actions: <Widget>[
              RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  "Aceptar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  //FINAL
                  _insertarDatos(mesa, fkey);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future _insertarDatos(String mesa, int fkey) async {
    final conn = PostgreSQLConnection(
      "192.168.0.13",
      5432,
      "segparcialsw1",
      username: "postgres",
      password: "123",
    );
    await conn.open();

    if (!conn.isClosed) {
      print("Si conecto x2");

      await conn.query('''
         INSERT INTO votos_boleta (id_mesa,cc_pres,cc_dip,fpv_pres,fpv_dip,mts_pres,
         mts_dip,ucs_pres,ucs_dip,mas_pres,mas_dip,f21_pres,f21_dip,pdc_pres,pdc_dip,
         mnr_pres,mnr_dip,pan_pres,pan_dip,blancos_pres,blancos_dip,nulos_pres,nulos_dip,
         recinto_id)
         VALUES ('$mesa','$cc_pres','$cc_dip','$fpv_pres','$fpv_dip','$mts_pres',
         '$mts_dip','$ucs_pres','$ucs_dip','$mas_pres','$mas_dip','$f21_pres','$f21_dip','$pdc_pres','$pdc_dip',
         '$mnr_pres','$mnr_dip','$pan_pres','$pan_dip','$blancos_pres','$blancos_dip','$nulos_pres','$nulos_dip',
         '$fkey')
       ''');
      print("Insertado con exito!");
    }

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ingresar por Imagen"),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 100.0),
            isImageLoaded
                ? Center(
                    child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: FileImage(pickedImage),
                        ))),
                  )
                : Container(),
            SizedBox(height: 10.0),
            RaisedButton(
              color: Colors.blueAccent,
              child: Text(
                'Elige una imagen de tu Galeria',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: pickImage,
            ),
            RaisedButton(
              color: Colors.blueAccent,
              child: Text(
                'Analizar Texto',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: readText,
            ),
            RaisedButton(
              color: Colors.blueAccent,
              child: Text(
                'Ingresar los datos obtenidos',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: connectionPostgres,
            ),
          ],
        ));
  }
}
