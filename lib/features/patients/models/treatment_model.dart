class TreatmentModel {
  final int? id;
  final String? name;
  final String? duration;
  final String? price;
  final bool? isActive;
  final List<dynamic>? branches; 
  final String? createdAt;
  final String? updatedAt;

  TreatmentModel({
    this.id,
    this.name,
    this.duration,
    this.price,
    this.isActive,
    this.branches,
    this.createdAt,
    this.updatedAt,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      duration: json['duration'] as String?,
      price: json['price']?.toString(), 
      isActive: json['is_active'] as bool?,
      branches: json['branches'] as List<dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
