import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:http/http.dart' as http;

class QRCode extends StatelessWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: const Text('Test4Life QR Code Scanner')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 45, bottom: 5),
            child: Image.asset(
              "assets/app_icon.png",
              width: 100,
            ),
          ),
          Text(
            "Test4Life",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Text(
            "Scanner",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 140,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const QrView(),
                ));
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.lightBlueAccent),
                foregroundColor: WidgetStateProperty.all(Colors.white),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
                elevation: WidgetStateProperty.all(
                    5), // You can adjust the elevation
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text('Scan Kits',style: TextStyle(fontSize: 20),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QrView extends StatefulWidget {
  const QrView({Key? key}) : super(key: key);

  @override
  State<QrView> createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;
  bool _isProcessing = false;
  bool _isSuccess = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!_isProcessing) {
        _processQRCode(scanData.code!);
      }
    });
  }

  Future<void> _processQRCode(String code) async {
    setState(() {
      _isProcessing = true;
    });

    // Pause the camera while processing the API request
    controller?.pauseCamera();

    const apiUrl = 'https://testforlife-a4b515517434.herokuapp.com/kitrecbyqr';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'qrCode': code}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isSuccess = true;
        });

        await Future.delayed(const Duration(seconds: 3));
        setState(() {
          _isSuccess = false;
        });
      } else {
        log('Failed to retrieve kit: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.body}'),
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
      }
    } catch (e) {
      log('Error sending QR code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
    } finally {
      // Resume the camera after processing
      controller?.resumeCamera();
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width < 400 ? 300.0 : 400.0;

    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea,
            ),
          ),
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          if (_isSuccess)
            const Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
            ),
        ],
      ),
    );
  }
}
