class PatientModel {
  final int? id;
  final String? name;
  final String? phone;
  final String? address;
  final String? dateNdTime;
  final String? user;
  final List<PatientDetail>? patientdetailsSet;

  PatientModel({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.dateNdTime,
    this.user,
    this.patientdetailsSet,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      dateNdTime: json['date_nd_time'] as String?,
      user: json['user'] as String?,
      patientdetailsSet: (json['patientdetails_set'] as List<dynamic>?)
          ?.map((e) => PatientDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PatientDetail {
  final int? id;
  final String? treatmentName;

  PatientDetail({this.id, this.treatmentName});

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    return PatientDetail(
      id: json['id'] as int?,
      treatmentName: json['treatment_name'] as String?,
    );
  }
}
