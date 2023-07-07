import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../Declarations/DashboardScreen.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/icon/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<void> _makeReport() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("healthyFood");

    QuerySnapshot querySnapshot = await collectionReference.get();

    final foodName = querySnapshot.docs.map((doc) => doc['foodName']).toList();
    final carbs = querySnapshot.docs.map((doc) => doc['Carbs']).toList();
    final volume = querySnapshot.docs.map((doc) => doc['Volume']).toList();
    final kcals = querySnapshot.docs.map((doc) => doc['foodCalories']).toList();
    final category = querySnapshot.docs.map((doc) => doc['Category']).toList();

    String foodToString = foodName.join('\n');
    String carbsToString = carbs.join('\n');
    String volumeToString = volume.join('\n');
    String kcalsToString = kcals.join('\n');
    String categoryToString = category.join('\n');
    PdfDocument pdfDocument = PdfDocument();
    PdfPage page = pdfDocument.pages.add();

    File f = await getImageFileFromAssets('dumbbell.png');
    page.graphics.drawImage(
      PdfBitmap(f.readAsBytesSync()),
      Rect.fromLTWH(230, 0, 60, 60),
    );

    page.graphics.drawString(
        "Supreme Fitness", PdfStandardFont(PdfFontFamily.helvetica, 20),
        bounds: Rect.fromLTWH(180, 60, 500, 500), pen: PdfPens.gray);

    PdfGrid pdfGrid = PdfGrid();

    pdfGrid.columns.add(count: 5);
    pdfGrid.headers.add(1);

    PdfGridRow header = pdfGrid.headers[0];
    header.cells[0].value = "FoodName";
    header.cells[1].value = "Carbs";
    header.cells[2].value = "Volume";
    header.cells[3].value = "Kcal's";
    header.cells[4].value = "Category";

    PdfGridRow row = pdfGrid.rows.add();
    row.cells[0].value = foodToString;
    row.cells[1].value = carbsToString;
    row.cells[2].value = volumeToString;
    row.cells[3].value = kcalsToString;
    row.cells[4].value = categoryToString;

    pdfGrid.draw(page: page, bounds: const Rect.fromLTWH(0, 110, 0, 0));

    page.graphics.drawString(
        "Total Found Records:- " + foodName.length.toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(190, 180, 0, 0),
        pen: PdfPens.green);

    final directory = await getExternalStorageDirectory();
    final path = directory!.path;
    print("PATH::-" + path);

    File('$path/SupremeFitness.pdf').writeAsBytes(pdfDocument.saveSync());

    pdfDocument.dispose();

    OpenFile.open('$path/SupremeFitness.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: dashboardColors[10],
          shadowColor: dashboardColors[10].withAlpha(0),
          title: const Text(
            "Reports",
            style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
          ),
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 38.0),
            child: Text(
              "Note: To generate reports kindly click to below button:-",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Tooltip(
            message: "Generate Reports",
            child: IconButton(
                iconSize: 50.0,
                onPressed: () => _makeReport(),
                icon: Icon(Icons.picture_as_pdf_rounded)),
          ),
        ])));
  }
}
