import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:remote_eye/core/utils/date_formater.dart';
import 'package:remote_eye/features/detector/models/meta_data.dart';

class PdfService {
  static Future<Uint8List> createPdf(
    List<MetaDataModel> eventsMetadataList,
  ) async {
    final pdf = pw.Document();
    // Download images and store them as Uint8List
    List<Uint8List> imageBytesList = [];
    for (var eventMetadata in eventsMetadataList) {
      final response = await http.get(Uri.parse(eventMetadata.imageUrl!));
      if (response.statusCode == 200) {
        imageBytesList.add(response.bodyBytes);
      } else {
        throw Exception();
      }
    }
    pw.Widget textWidget(
      String text, {
      bool softWrap = false,
      double? fontSize,
    }) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(4),
        margin: const pw.EdgeInsets.all(2),
        child: pw.Text(text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: fontSize),
            softWrap: softWrap),
      );
    }

    // Add a page with a table to the PDF
    pdf.addPage(pw.MultiPage(
      build: (pw.Context context) => [
        pw.Table(
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          border: pw.TableBorder.all(width: 1),
          children: [
            pw.TableRow(
              children: [
                textWidget('Image'),
                textWidget('Message'),
                textWidget(' Date '),
                textWidget(' Time '),
              ],
            ),
            ...eventsMetadataList.asMap().entries.map((entry) {
              final index = entry.key;
              final eventMetadata = entry.value;
              return pw.TableRow(
                children: [
                  pw.Container(
                    height: 180,
                    width: 180,
                    margin: const pw.EdgeInsets.all(3),
                    child: pw.Image(
                      pw.MemoryImage(imageBytesList[index]),
                    ),
                  ),
                  textWidget(eventMetadata.message!,
                      softWrap: true, fontSize: 10),
                  textWidget(
                      formatDate(
                        eventMetadata.metadataTime,
                      ),
                      fontSize: 11),
                  textWidget(formatTime(eventMetadata.metadataTime)!,
                      fontSize: 11),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    ));

    return await pdf.save();
  }
}
