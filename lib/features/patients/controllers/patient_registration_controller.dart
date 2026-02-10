import 'package:flutter/material.dart';
import '../services/patient_service.dart';
import '../models/branch_model.dart';
import '../models/treatment_model.dart';
import '../models/treatment_selection_model.dart';

class PatientRegistrationController with ChangeNotifier {
  final PatientService _patientService = PatientService();

  List<BranchModel> _branches = [];
  List<TreatmentModel> _treatments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BranchModel> get branches => _branches;
  List<TreatmentModel> get treatments => _treatments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? _selectedLocation;
  String? _selectedBranch;
  String _selectedPayment = 'Cash';
  DateTime? _treatmentDate;
  String? _selectedHour;
  String? _selectedMinute;
  List<TreatmentSelection> _selectedTreatments = [];

  double _totalAmount = 0;
  double _discountAmount = 0;
  double _advanceAmount = 0;
  double _balanceAmount = 0;

  String? get selectedLocation => _selectedLocation;
  String? get selectedBranch => _selectedBranch;
  String get selectedPayment => _selectedPayment;
  DateTime? get treatmentDate => _treatmentDate;
  String? get selectedHour => _selectedHour;
  String? get selectedMinute => _selectedMinute;
  List<TreatmentSelection> get selectedTreatments => _selectedTreatments;

  double get totalAmount => _totalAmount;
  double get discountAmount => _discountAmount;
  double get advanceAmount => _advanceAmount;
  double get balanceAmount => _balanceAmount;

  Future<void> fetchMetadata() async {
    try {
      final results = await Future.wait([
        _patientService.getBranchList(),
        _patientService.getTreatmentList(),
      ]);
      _branches = results[0] as List<BranchModel>;
      _treatments = results[1] as List<TreatmentModel>;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void setLocation(String? val) {
    _selectedLocation = val;
    notifyListeners();
  }

  void setBranch(String? val) {
    _selectedBranch = val;
    notifyListeners();
  }

  void setPayment(String val) {
    _selectedPayment = val;
    notifyListeners();
  }

  void setTreatmentDate(DateTime? date) {
    _treatmentDate = date;
    notifyListeners();
  }

  void setTime(String? hour, String? minute) {
    if (hour != null) _selectedHour = hour;
    if (minute != null) _selectedMinute = minute;
    notifyListeners();
  }

  void addTreatment(TreatmentSelection selection) {
    final index = _selectedTreatments.indexWhere((e) => e.id == selection.id);
    if (index != -1) {
      _selectedTreatments[index] = selection;
    } else {
      _selectedTreatments.add(selection);
    }
    _updateTotalFromTreatments();
  }

  void removeTreatment(int index) {
    _selectedTreatments.removeAt(index);
    _updateTotalFromTreatments();
  }

  void _updateTotalFromTreatments() {
    double total = 0;
    for (var selection in _selectedTreatments) {
      final count = selection.maleCount + selection.femaleCount;
      total += count * selection.price;
    }
    _totalAmount = total;
    _calculateBalance();
    notifyListeners();
  }

  void updateAmounts({
    double? discount,
    double? advance,
    double? totalOverride,
  }) {
    if (discount != null) _discountAmount = discount;
    if (advance != null) _advanceAmount = advance;
    if (totalOverride != null) _totalAmount = totalOverride;

    _calculateBalance();
    notifyListeners();
  }

  void _calculateBalance() {
    _balanceAmount = _totalAmount - _discountAmount - _advanceAmount;
  }

  void clearRegistrationForm() {
    _selectedLocation = null;
    _selectedBranch = null;
    _selectedPayment = 'Cash';
    _treatmentDate = null;
    _selectedHour = null;
    _selectedMinute = null;
    _selectedTreatments = [];
    _totalAmount = 0;
    _discountAmount = 0;
    _advanceAmount = 0;
    _balanceAmount = 0;
    notifyListeners();
  }

  String? _draftTreatmentId;
  int _draftMaleCount = 0;
  int _draftFemaleCount = 0;

  String? get draftTreatmentId => _draftTreatmentId;
  int get draftMaleCount => _draftMaleCount;
  int get draftFemaleCount => _draftFemaleCount;

  void prepareAddTreatment() {
    _draftTreatmentId = null;
    _draftMaleCount = 0;
    _draftFemaleCount = 0;
    notifyListeners();
  }

  void prepareEditTreatment(TreatmentSelection selection) {
    _draftTreatmentId = selection.id;
    _draftMaleCount = selection.maleCount;
    _draftFemaleCount = selection.femaleCount;
    notifyListeners();
  }

  void setDraftTreatmentId(String? id) {
    _draftTreatmentId = id;
    notifyListeners();
  }

  void updateDraftCounts({int? male, int? female}) {
    if (male != null) _draftMaleCount = male;
    if (female != null) _draftFemaleCount = female;
    notifyListeners();
  }

  void saveTreatmentDraft(List<TreatmentModel> availableTreatments) {
    if (_draftTreatmentId == null) return;

    final treatmentName =
        availableTreatments
            .firstWhere(
              (t) => t.id.toString() == _draftTreatmentId,
              orElse: () => TreatmentModel(name: 'Unknown'),
            )
            .name ??
        'Unknown';

    final treatmentPrice =
        double.tryParse(
          availableTreatments
              .firstWhere(
                (t) => t.id.toString() == _draftTreatmentId,
                orElse: () => TreatmentModel(price: '0'),
              )
              .price
              .toString(),
        ) ??
        0.0;

    final newSelection = TreatmentSelection(
      id: _draftTreatmentId!,
      name: treatmentName,
      price: treatmentPrice,
      maleCount: _draftMaleCount,
      femaleCount: _draftFemaleCount,
    );

    addTreatment(newSelection);
  }

  Future<bool> registerPatient(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    final (success, message) = await _patientService.registerPatient(data);

    if (success) {
      clearRegistrationForm();
    } else {
      _errorMessage = message;
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
