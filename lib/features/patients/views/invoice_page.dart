import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:novindus_tets/features/patients/models/invoice_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoicePage extends StatelessWidget {
  final InvoiceModel model;

  const InvoicePage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice')),
      body: PdfPreview(
        build: (format) => _generatePdf(format, model),
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    InvoiceModel model,
  ) async {
    final pdf = pw.Document();

    final logoSvg = await rootBundle.loadString('assets/images/logo.svg');
    final font = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();

    const PdfColor primaryColor = PdfColor.fromInt(0xFF4CAF50);
    const PdfColor greyColor = PdfColor.fromInt(0xFF757575);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Center(
                child: pw.Opacity(
                  opacity: 0.1,
                  child: pw.SvgImage(svg: logoSvg, width: 400, height: 400),
                ),
              ),

              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 80,
                        height: 80,
                        child: pw.SvgImage(svg: logoSvg),
                      ),

                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "KUMARAKOM",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            "Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563",
                            style: const pw.TextStyle(
                              fontSize: 11,
                              color: greyColor,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            "e-mail: unknown@gmail.com",
                            style: const pw.TextStyle(
                              fontSize: 11,
                              color: greyColor,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            "Mob: +91 9876543210 | +91 9786543210",
                            style: const pw.TextStyle(
                              fontSize: 11,
                              color: greyColor,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            "GST No: 32AABCU9603R1ZW",
                            style: const pw.TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(color: greyColor, thickness: 0.5),
                  pw.SizedBox(height: 20),

                  pw.Text(
                    "Patient Details",
                    style: pw.TextStyle(
                      color: primaryColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Name", model.patientName),
                            pw.SizedBox(height: 4),
                            _buildInfoRow("Address", model.address),
                            pw.SizedBox(height: 4),
                            _buildInfoRow("WhatsApp Number", model.phone),
                          ],
                        ),
                      ),

                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Booked On", model.bookingDate),
                            pw.SizedBox(height: 4),
                            _buildInfoRow(
                              "Treatment Date",
                              model.treatmentDate,
                            ),
                            pw.SizedBox(height: 4),
                            _buildInfoRow(
                              "Treatment Time",
                              model.treatmentTime,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(
                    color: greyColor,
                    thickness: 0.5,
                    borderStyle: pw.BorderStyle.dashed,
                  ),
                  pw.SizedBox(height: 20),

                  pw.Text(
                    "Treatment",
                    style: pw.TextStyle(
                      color: primaryColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    columnWidths: {
                      0: const pw.FlexColumnWidth(4),
                      1: const pw.FlexColumnWidth(1.5),
                      2: const pw.FlexColumnWidth(1),
                      3: const pw.FlexColumnWidth(1),
                      4: const pw.FlexColumnWidth(2),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text(
                            "",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            "Price",
                            style: pw.TextStyle(
                              color: primaryColor,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            "Male",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              color: primaryColor,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            "Female",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              color: primaryColor,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            "Total",
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                              color: primaryColor,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),

                      pw.TableRow(
                        children: [
                          pw.SizedBox(height: 8),
                          pw.SizedBox(height: 8),
                          pw.SizedBox(height: 8),
                          pw.SizedBox(height: 8),
                          pw.SizedBox(height: 8),
                        ],
                      ),

                      ...model.treatments.map((t) {
                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 6),
                              child: pw.Text(
                                t.name,
                                style: const pw.TextStyle(
                                  fontSize: 10,
                                  color: greyColor,
                                ),
                              ),
                            ),
                            pw.Text(
                              "₹${t.price.toStringAsFixed(0)}",
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: greyColor,
                              ),
                            ),
                            pw.Text(
                              "${t.maleCount}",
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: greyColor,
                              ),
                            ),
                            pw.Text(
                              "${t.femaleCount}",
                              textAlign: pw.TextAlign.center,
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: greyColor,
                              ),
                            ),
                            pw.Text(
                              "₹ ${t.total.toStringAsFixed(0)}",
                              textAlign: pw.TextAlign.right,
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: greyColor,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(
                    color: greyColor,
                    thickness: 0.5,
                    borderStyle: pw.BorderStyle.dashed,
                  ),
                  pw.SizedBox(height: 10),

                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.SizedBox(
                      width: 200,
                      child: pw.Column(
                        children: [
                          _buildTotalRow(
                            "Total Amount",
                            "₹ ${model.totalAmount.toStringAsFixed(0)}",
                            isBold: true,
                          ),
                          pw.SizedBox(height: 4),
                          _buildTotalRow(
                            "Discount",
                            "₹ ${model.discount.toStringAsFixed(0)}",
                          ),
                          pw.SizedBox(height: 4),
                          _buildTotalRow(
                            "Advance",
                            "₹ ${model.advance.toStringAsFixed(0)}",
                          ),
                          pw.SizedBox(height: 8),
                          pw.Divider(
                            color: greyColor,
                            thickness: 0.5,
                            borderStyle: pw.BorderStyle.dashed,
                          ),
                          pw.SizedBox(height: 4),
                          _buildTotalRow(
                            "Balance",
                            "₹${model.balance.toStringAsFixed(0)}",
                            isBold: true,
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  pw.Spacer(),

                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Column(
                      children: [
                        pw.Text(
                          "Thank you for choosing us",
                          style: pw.TextStyle(
                            color: primaryColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          "Your well-being is our commitment, and we're honored\nyou've entrusted us with your health journey",
                          textAlign: pw.TextAlign.center,
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.only(right: 100),
                      child: pw.Text(
                        "Lee",
                        style: pw.TextStyle(
                          fontStyle: pw.FontStyle.italic,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Divider(
                    color: greyColor,
                    thickness: 0.5,
                    borderStyle: pw.BorderStyle.dashed,
                  ),
                  pw.SizedBox(height: 5),
                  pw.Center(
                    child: pw.Text(
                      "\"Booking amount is non-refundable, and it's important to arrive on the allotted time for your treatment\"",
                      style: const pw.TextStyle(fontSize: 10, color: greyColor),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 100,
          child: pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          ),
        ),
        pw.SizedBox(width: 05),
        pw.Expanded(
          child: pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColor.fromInt(0xFF757575),
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTotalRow(
    String label,
    String value, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: isBold ? 12 : 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: isBold ? 12 : 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
