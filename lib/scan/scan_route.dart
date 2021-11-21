import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanRoute extends StatefulWidget {
  const ScanRoute({Key? key}) : super(key: key);

  @override
  _ScanRouteState createState() => _ScanRouteState();
}

class _ScanRouteState extends State<ScanRoute> {
  final GlobalKey _qrKey = GlobalKey();
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    debugPrint("LLL");
    this.controller = controller;
    controller.scannedDataStream.listen((data) {
      debugPrint("LISTENER");
      setState(() => debugPrint(data.code));
    });
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 500.0;
    debugPrint(result?.code);
    return Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context)!.app_name),
        ),
        body: QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(cutOutSize: scanArea)));
  }
}
