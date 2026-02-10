class InvoiceModel {
  final String patientName;
  final String address;
  final String phone;
  final String bookingDate; 
  final String treatmentDate;
  final String treatmentTime;
  final List<InvoiceTreatment> treatments;
  final double totalAmount;
  final double discount;
  final double advance;
  final double balance;

  InvoiceModel({
    required this.patientName,
    required this.address,
    required this.phone,
    required this.bookingDate,
    required this.treatmentDate,
    required this.treatmentTime,
    required this.treatments,
    required this.totalAmount,
    required this.discount,
    required this.advance,
    required this.balance,
  });
}

class InvoiceTreatment {
  final String name;
  final double price;
  final int maleCount;
  final int femaleCount;
  final double total;

  InvoiceTreatment({
    required this.name,
    required this.price,
    required this.maleCount,
    required this.femaleCount,
    required this.total,
  });
}
