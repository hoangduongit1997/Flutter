import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:pika_maintenance/module/change_language_module/change_language_module.dart';
import 'package:pika_maintenance/screens/home_screen/send_request_page/send_request_page.dart';
import 'package:pika_maintenance/styles/styles.dart';

import 'package:pika_maintenance/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:toast/toast.dart';

class ScanPage extends StatefulWidget {
  _ScanPageState createState() => _ScanPageState();
}

String flash_on = "FLASH ON";
String flash_off = "FLASH OFF";

class _ScanPageState extends State<ScanPage> {
  String qrText = "";
  String flashState = flash_on;

  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.orange,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 5,
                  cutOutSize: 300,
                ),
              ),
              flex: 4,
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Colors.orange,
                            onPressed: () {
                              if (controller != null) {
                                controller.toggleFlash();
                                if (_isFlashOn(flashState)) {
                                  setState(() {
                                    flashState = flash_off;
                                  });
                                } else {
                                  setState(() {
                                    flashState = flash_on;
                                  });
                                }
                              }
                            },
                            child: Text(flashState, style: StylesText.style20While),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.orange,
                        onPressed: () {
                          controller.pauseCamera();
                          Navigator.of(context)
                              .push(CupertinoPageRoute(builder: (context) => SendRequestPage()))
                              .then((_) {
                            controller.resumeCamera();
                          });
                        },
                        child: Text(allTranslations.text("input_by_hand"), style: StylesText.style20While),
                      ),
                    )
                  ],
                ),
              ),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  _isFlashOn(String current) {
    return flash_on == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData != null) {
        controller.pauseCamera();
        qrText = scanData;
        Toast.show(allTranslations.text("scan_success")+" "+ qrText.trim(), context, gravity: Toast.BOTTOM, duration:
        Toast.LENGTH_SHORT);
        Future.delayed(Duration(milliseconds: 500));
        Navigator.of(context)
            .push(CupertinoPageRoute(
                builder: (context) => SendRequestPage(
                      machineId: int.tryParse(qrText),
                    )))
            .then((_) {
          controller.resumeCamera();
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
