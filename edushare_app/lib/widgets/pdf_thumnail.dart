import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter/services.dart';

class PdfThumbnail extends StatefulWidget {

  final String url;

  const PdfThumbnail({
    super.key,
    required this.url,
  });

  @override
  State<PdfThumbnail> createState() => _PdfThumbnailState();
}

class _PdfThumbnailState extends State<PdfThumbnail> {

  PdfPageImage? image;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {

    try {

      final data = await NetworkAssetBundle(
        Uri.parse(widget.url),
      ).load(widget.url);

      final doc = await PdfDocument.openData(
        data.buffer.asUint8List(),
      );

      final page = await doc.getPage(1);

      final img = await page.render(
        width: 300,
        height: 400,
        format: PdfPageImageFormat.png,
      );

      setState(() {
        image = img;
        loading = false;
      });

    } catch (e) {

      debugPrint("PDF ERROR: $e");

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (image == null) {

      return Container(
        color: Colors.grey.shade900,
        child: const Center(
          child: Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
            size: 40,
          ),
        ),
      );
    }

    return Image.memory(
      image!.bytes,
      fit: BoxFit.cover,
    );
  }
}