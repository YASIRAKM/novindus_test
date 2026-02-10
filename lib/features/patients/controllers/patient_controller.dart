import 'package:flutter/material.dart';
import '../services/patient_service.dart';

import '../models/branch_model.dart';
import '../models/patient_model.dart';
import '../models/treatment_model.dart';

class PatientController with ChangeNotifier {
  final PatientService _patientService = PatientService();

  List<PatientModel> _patients = [];
  List<PatientModel> _filteredPatients = [];
  List<BranchModel> _branches = [];
  List<TreatmentModel> _treatments = [];
  bool _isLoading = false;
  String _patientFetchError = "";

  List<PatientModel> get patients =>
      _filteredPatients.isNotEmpty || hasActiveFilters
      ? _filteredPatients
      : _patients;

  List<BranchModel> get branches => _branches;
  List<TreatmentModel> get treatments => _treatments;
  bool get isLoading => _isLoading;
  String get patientFetchError => _patientFetchError;

  String _searchQuery = '';
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  bool get hasActiveFilters => _searchQuery.isNotEmpty || _selectedDate != null;

  Future<void> fetchPatients() async {
    _isLoading = true;
    notifyListeners();
    try {
      _patients = await _patientService.getPatientList();
      _applyFilters();
    } catch (e) {
      _patientFetchError = "Failed To Fetch Patients";
      print("Error fetching patients: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchPatients(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByDate(DateTime? date) {
    _selectedDate = date;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedDate = null;
    _filteredPatients = [];
    notifyListeners();
  }

  void _applyFilters() {
    _filteredPatients = _patients.where((patient) {
      bool matchesSearch = true;
      bool matchesDate = true;

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final name = patient.name?.toLowerCase() ?? '';
        final treatments =
            patient.patientdetailsSet
                ?.map((d) => d.treatmentName?.toLowerCase() ?? '')
                .join(' ') ??
            '';
        matchesSearch = name.contains(query) || treatments.contains(query);
      }

      if (_selectedDate != null && patient.dateNdTime != null) {
        try {
          final patientDate = DateTime.parse(patient.dateNdTime!);
          matchesDate =
              patientDate.year == _selectedDate!.year &&
              patientDate.month == _selectedDate!.month &&
              patientDate.day == _selectedDate!.day;
        } catch (e) {
          matchesDate = false;
        }
      }

      return matchesSearch && matchesDate;
    }).toList();
    notifyListeners();
  }

  Future<void> fetchMetadata() async {
    try {
      final results = await Future.wait([
        _patientService.getBranchList(),
        _patientService.getTreatmentList(),
      ]);
      _branches = results[0] as List<BranchModel>;
      _treatments = results[1] as List<TreatmentModel>;
      notifyListeners();
    } catch (e) {}
  }
}
