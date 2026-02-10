class TreatmentSelection {
  final String id;
  final String name;
  final double price;
  int maleCount;
  int femaleCount;

  TreatmentSelection({
    required this.id,
    required this.name,
    required this.price,
    this.maleCount = 0,
    this.femaleCount = 0,
  });
}
