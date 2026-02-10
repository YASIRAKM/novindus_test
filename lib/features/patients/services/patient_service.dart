import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/branch_model.dart';
import '../models/patient_model.dart';
import '../models/treatment_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/shared_preference_service.dart';

class PatientService {
  final SharedPreferenceService _prefsService = SharedPreferenceService();

  Future<String?> _getToken() async {
    return await _prefsService.getToken();
  }

  Future<List<PatientModel>> getPatientList() async {
    final token = await _getToken();
    if (token == null) throw Exception("No token found");

    final response = await http.get(
      Uri.parse(ApiConstants.patientList),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        final List<dynamic> patientsJson = data['patient'] ?? [];
        return patientsJson.map((json) => PatientModel.fromJson(json)).toList();
      }
    }
    return [];
  }

  Future<List<BranchModel>> getBranchList() async {
    final token = await _getToken();
    if (token == null) throw Exception("No token found");

    final response = await http.get(
      Uri.parse(ApiConstants.branchList),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        log(data['branches'].toString());
        final List<dynamic> branchesJson = data['branches'] ?? [];
        return branchesJson.map((json) => BranchModel.fromJson(json)).toList();
      }
    }
    return [];
  }

  Future<List<TreatmentModel>> getTreatmentList() async {
    final token = await _getToken();
    if (token == null) throw Exception("No token found");

    final response = await http.get(
      Uri.parse(ApiConstants.treatmentList),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        final List<dynamic> treatmentsJson = data['treatments'] ?? [];
        return treatmentsJson
            .map((json) => TreatmentModel.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  Future<(bool, String)> registerPatient(
    Map<String, dynamic> patientData,
  ) async {
    final token = await _getToken();
    if (token == null) throw Exception("No token found");

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.patientUpdate),
      );
      request.headers['Authorization'] = 'Bearer $token';

      log("Registering Patient with Data: $patientData");

      patientData.forEach((key, value) {
        if (key == 'payment') {
          request.fields[key] = value.toString().toLowerCase();
        } else if (value is List) {
          request.fields[key] = value.join(' , ');
        } else {
          request.fields[key] = value.toString();
        }
      });

      log("Request Fields: ${request.fields}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.body}");

      final responseBody = response.body;

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return (data['status'] == true, data['message'].toString());
      }
      return (false, "Something went wrong. Status: ${response.statusCode}");
    } catch (e) {
      log("Register Error: $e");
      return (false, "Something went wrong");
    }
  }
}
