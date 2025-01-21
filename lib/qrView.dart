// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
// import 'package:http/http.dart' as http;

// class QRCode extends StatelessWidget {
//   const QRCode({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // appBar: AppBar(title: const Text('Test4Life QR Code Scanner')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 95, bottom: 5),
//             child:SizedBox(
//             // height: 140,
//           ),
//             // child: Image.asset(
//             //   "assets/app_icon.png",
//             //   width: 100,
//             // ),
//           ),
//           Text(
//             "GutHealthLab",
//             style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
//           ),
//           Text(
//             "Scanner",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
//           ),
//           SizedBox(
//             height: 200,
//           ),
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => const QrView(),
//                 ));
//               },
//               style: ButtonStyle(
//                 backgroundColor: WidgetStateProperty.all(Colors.lightBlueAccent),
//                 foregroundColor: WidgetStateProperty.all(Colors.white),
//                 shape: WidgetStateProperty.all(RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 )),
//                 elevation: WidgetStateProperty.all(
//                     5), // You can adjust the elevation
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5),
//                 child: const Text('Scan Kits',style: TextStyle(fontSize: 20),),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class QrView extends StatefulWidget {
//   const QrView({Key? key}) : super(key: key);

//   @override
//   State<QrView> createState() => _QrViewState();
// }

// class _QrViewState extends State<QrView> {
//   final GlobalKey qrKey = GlobalKey();
//   QRViewController? controller;
//   bool _isProcessing = false;
//   bool _isSuccess = false;

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller?.pauseCamera();
//     }
//     controller?.resumeCamera();
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) async {
//       if (!_isProcessing) {
//         _processQRCode(scanData.code!);
//       }
//     });
//   }

//   Future<void> _processQRCode(String code) async {
//     setState(() {
//       _isProcessing = true;
//     });

//     // Pause the camera while processing the API request
//     controller?.pauseCamera();

//     const apiUrl = 'https://testforlife-a4b515517434.herokuapp.com/kitrecbyqr';

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'qrCode': code}),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _isSuccess = true;
//         });

//         await Future.delayed(const Duration(seconds: 3));
//         setState(() {
//           _isSuccess = false;
//         });
//       } else {
//         log('Failed to retrieve kit: ${response.body}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: ${response.body}'),
//             backgroundColor: Colors.lightBlueAccent,
//           ),
//         );
//       }
//     } catch (e) {
//       log('Error sending QR code: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('An error occurred: $e'),
//           backgroundColor: Colors.lightBlueAccent,
//         ),
//       );
//     } finally {
//       // Resume the camera after processing
//       controller?.resumeCamera();
//       setState(() {
//         _isProcessing = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var scanArea = MediaQuery.of(context).size.width < 400 ? 300.0 : 400.0;

//     return Scaffold(
//       body: Stack(
//         children: [
//           QRView(
//             key: qrKey,
//             onQRViewCreated: _onQRViewCreated,
//             overlay: QrScannerOverlayShape(
//               borderColor: Colors.red,
//               borderRadius: 10,
//               borderLength: 30,
//               borderWidth: 10,
//               cutOutSize: scanArea,
//             ),
//           ),
//           if (_isProcessing)
//             const Center(
//               child: CircularProgressIndicator(color: Colors.white),
//             ),
//           if (_isSuccess)
//             const Center(
//               child: Icon(
//                 Icons.check_circle,
//                 color: Colors.green,
//                 size: 100,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }




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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 95, bottom: 5),
            child:SizedBox(
            // height: 140,
          ),
            // child: Image.asset(
            //   "assets/app_icon.png",
            //   width: 100,
            // ),
          ),
          Text(
            "GutHealthLab",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
          ),
          Text(
            "Scanner",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 200,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QrView(),
                ));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
                elevation: MaterialStateProperty.all(5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'Scan Kits',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QrView extends StatefulWidget {
  @override
  _QrViewState createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;
  bool _isProcessing = false;
  bool _isSuccess = false;
  bool _isError = false;

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

    // By default, the controller will scan QR codes and barcodes
    controller.scannedDataStream.listen((scanData) async {
      if (!_isProcessing) {
        _processQRCode(scanData.code!);
      }
    });
  }

  Future<void> _processQRCode(String code) async {
    setState(() {
      _isProcessing = true;
      _isSuccess = false;
      _isError = false;
    });

    // Pause the camera while processing the API request
    controller?.pauseCamera();

    const apiUrl1 = 'https://testforlife-a4b515517434.herokuapp.com/kitrecbyqr';
    const apiUrl2 = 'https://yourgutmap-food-sensitivity-423a2af84621.herokuapp.com/kitrecbyqr'; // Add the second API URL here

    try {
      // Call both APIs
      final response1 = await http.post(
        Uri.parse(apiUrl1),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'qrCode': code}),
      );

      final response2 = await http.post(
        Uri.parse(apiUrl2),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'qrCode': code}),
      );

      if (response1.statusCode == 200 || response2.statusCode == 200) {
        setState(() {
          _isSuccess = true;
        });
      } else {
        setState(() {
          _isError = true;
        });
      }

      // Show success or error message for 1 second and then reset
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isSuccess = false;
        _isError = false;
      });
    } catch (e) {
      log('Error sending QR code: $e');
      setState(() {
        _isError = true;
      });
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
          if (_isSuccess || _isError)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isSuccess
                            ? Icons.check_circle
                            // : Icons.cancel_outlined,
                            : Icons.check_circle,
                        color: _isSuccess ? Colors.green : Colors.green,//Colors.red,
                        size: 100,
                      ),
                      Text(
                        _isSuccess
                            ? 'Kit Scanned Successfully'
                            // : 'Kit Not Found',
                            : 'Kit Scanned Successfully',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
