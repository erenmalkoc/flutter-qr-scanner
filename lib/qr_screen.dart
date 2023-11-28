import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool showGreen = false;
  bool showRed = false;
  bool showResult = false;
  bool showLoading =false;
  String responseBody='';

  Future<void> sendRequest(String header) async {
    final url = 'YOUR_API_HERE$header';

    final headers = {
      'YOUR_HOST_HERE':
          'YOUR_ID_HERE',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        print(' yanıt: ${response.body}');
        setState(() {
          showResult = true;
          showGreen = true;
          responseBody=response.body;
        });
      } else {
        print('hata: ${response.statusCode}');
        print('hata: ${response.body}');
        setState(() {
          showResult = true;
          showRed = true;
          responseBody=response.body;
        });
      }
    } catch (error) {
      print('hata: $error');
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return showResult
        ? Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  showResult=false;
                  showGreen=false;
                  showRed=false;
                  showLoading=false;
                });
              },
              child: const Icon(Icons.refresh_rounded,color: Colors.black,),
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: showGreen
                        ?  Text(
                            responseBody,
                            style: TextStyle(color: Colors.white,fontSize: 30),
                          )
                        :  Text(responseBody,
                            style: TextStyle(color: Colors.white,fontSize: 30),),
                  ),
                ],
              ),
              color: showGreen ? Colors.green : Colors.red,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Karekod Okuma Sistemi'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                 /* Expanded(
                    flex: 1,
                    child: Center(
                      child: (result != null)
                          ? Text(
                              'Barcode Type: ${describeEnum(result!.format)}   \nData: ${result!.code}',textAlign: TextAlign.center,)
                          : Text('Etkin Mod: Otomatik Tarama'),
                    ),
                  ),*/
                  Visibility(
                      visible: showLoading,
                      child: const Padding(padding: EdgeInsets.all(5.0),
                      child: Text("Lütfen bekleyiniz...",style: TextStyle(color: Colors.green),))),
                  Visibility(
                    visible: result != null,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            showLoading=true;
                            print('kod bu:');
                            print(result!.code as String);
                            sendRequest(result!.code as String);
                          },
                          child: const Text('KONTROL ET',style: TextStyle(color: Colors.black),)),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;

      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
