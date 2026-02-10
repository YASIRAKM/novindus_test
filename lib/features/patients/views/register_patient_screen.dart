import 'package:flutter/material.dart';
import 'package:novindus_tets/core/constants/color_constants.dart';
import 'package:novindus_tets/core/constants/text_style_constants.dart';
import 'package:novindus_tets/core/constants/constant_lists.dart';
import 'package:novindus_tets/core/utils/extensions.dart';
import 'package:novindus_tets/core/widgets/primary_button.dart';
import 'package:novindus_tets/features/patients/models/invoice_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_dropdown_field.dart';

import 'package:novindus_tets/core/routes/routes.dart';
import '../controllers/patient_registration_controller.dart';
import 'widgets/treatment_selection_widget.dart';
import 'package:novindus_tets/features/patients/models/treatment_model.dart';
import 'package:novindus_tets/features/patients/models/branch_model.dart';
import 'package:novindus_tets/core/utils/snackbar_utils.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _totalAmountController = TextEditingController();
  final _discountAmountController = TextEditingController();
  final _advanceAmountController = TextEditingController();
  final _balanceAmountController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PatientRegistrationController>();
      provider.fetchMetadata();
      provider.clearRegistrationForm();
    });

    _discountAmountController.addListener(() {
      final val = double.tryParse(_discountAmountController.text);
      context.read<PatientRegistrationController>().updateAmounts(
        discount: val ?? 0,
      );
    });
    _advanceAmountController.addListener(() {
      final val = double.tryParse(_advanceAmountController.text);
      context.read<PatientRegistrationController>().updateAmounts(
        advance: val ?? 0,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();

    _phoneController.dispose();
    _addressController.dispose();
    _totalAmountController.dispose();
    _discountAmountController.dispose();
    _advanceAmountController.dispose();
    _balanceAmountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && context.mounted) {
      context.read<PatientRegistrationController>().setTreatmentDate(
        pickedDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: AppColors.background,
      ),
      body: Consumer<PatientRegistrationController>(
        builder: (context, provider, _) {
          if (_totalAmountController.text !=
                  provider.totalAmount.toStringAsFixed(2) &&
              provider.totalAmount != 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _totalAmountController.text = provider.totalAmount
                  .toStringAsFixed(2);
            });
          }
          if (_balanceAmountController.text !=
              provider.balanceAmount.toStringAsFixed(2)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _balanceAmountController.text = provider.balanceAmount
                  .toStringAsFixed(2);
            });
          }

          if (provider.treatmentDate != null) {
            final dateStr = DateFormat(
              'dd/MM/yyyy',
            ).format(provider.treatmentDate!);
            if (_dateController.text != dateStr) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _dateController.text = dateStr;
              });
            }
          } else if (_dateController.text.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _dateController.clear();
            });
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: "Name",
                    hint: "Enter your full name",
                    validator: (v) => v.isNullOrEmpty ? "Name Required" : null,
                  ),
                  CustomTextField(
                    controller: _phoneController,
                    label: "Whatsapp Number",
                    hint: "Enter your Whatsapp number",
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v.isValidPhone ? null : "Enter a valid phone number",
                  ),
                  CustomTextField(
                    controller: _addressController,
                    label: "Address",
                    hint: "Enter your full address",
                    validator: (v) =>
                        v.isNullOrEmpty ? "Address Required" : null,
                  ),
                  CustomDropdownField<String>(
                    label: "Location",
                    value: provider.selectedLocation,
                    hint: "Choose Location",
                    items: locations.map((String val) {
                      return DropdownMenuItem(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) => provider.setLocation(val),
                    validator: (v) =>
                        v.isNullOrEmpty ? "Location Required" : null,
                  ),
                  CustomDropdownField<String>(
                    label: "Branch",
                    value: provider.selectedBranch,
                    hint: "Select the branch",
                    items: provider.branches.map<DropdownMenuItem<String>>((
                      BranchModel branch,
                    ) {
                      return DropdownMenuItem(
                        value: branch.id.toString(),
                        child: Text(branch.name ?? 'Unknown'),
                      );
                    }).toList(),
                    onChanged: (val) => provider.setBranch(val),
                    validator: (v) => v == null ? "Branch Required" : null,
                  ),
                  const SizedBox(height: 16),

                  TreatmentSelectionWidget(),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _totalAmountController,
                    label: "Total Amount",
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    validator: (v) =>
                        v.isNullOrEmpty ? "Total Amount Required" : null,
                  ),
                  CustomTextField(
                    controller: _discountAmountController,
                    label: "Discount Amount",
                    keyboardType: TextInputType.number,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Payment Option",
                      style: TextStyleConstants.labelStyle,
                    ),
                  ),
                  Row(
                    children: paymentOptions.map((option) {
                      return Expanded(
                        child: Row(
                          children: [
                            RadioGroup(
                              groupValue: provider.selectedPayment,
                              onChanged: (val) => provider.setPayment(val!),
                              child: Radio<String>(
                                value: option,

                                activeColor: Colors.green,
                              ),
                            ),
                            Text(option, style: TextStyleConstants.bodyRegular),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  CustomTextField(
                    controller: _advanceAmountController,
                    label: "Advance Amount",
                    keyboardType: TextInputType.number,
                    hint: "Enter Advance Amount",
                  ),
                  CustomTextField(
                    controller: _balanceAmountController,
                    label: "Balance Amount",
                    hint: "Enter Balance Amount",
                    readOnly: true,
                  ),

                  CustomTextField(
                    controller: _dateController,
                    label: "Treatment Date",
                    hint: "Select Date",
                    readOnly: true,
                    onTap: () => _pickDate(context),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text("Treatment Time", style: TextStyleConstants.labelStyle),

                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdownField<String>(
                          label: "Hour",
                          value: provider.selectedHour,
                          showLabel: false,
                          hint: "Select",
                          items: hours
                              .map(
                                (h) =>
                                    DropdownMenuItem(value: h, child: Text(h)),
                              )
                              .toList(),
                          onChanged: (val) => provider.setTime(val, null),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomDropdownField<String>(
                          label: "Minute",
                          value: provider.selectedMinute,
                          showLabel: false,
                          hint: "Select",
                          items: minutes
                              .map(
                                (m) =>
                                    DropdownMenuItem(value: m, child: Text(m)),
                              )
                              .toList(),
                          onChanged: (val) => provider.setTime(null, val),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  PrimaryButton(
                    text: "Save",
                    isLoading: provider.isLoading,
                    onPressed: provider.isLoading ? null : _submitForm,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm() async {
    final provider = context.read<PatientRegistrationController>();

    if (_formKey.currentState!.validate()) {
      if (provider.treatmentDate == null ||
          provider.selectedHour == null ||
          provider.selectedMinute == null) {
        SnackbarUtils.showError("Please select Date and Time");
        return;
      }

      final int hour = int.parse(provider.selectedHour!);
      final int minute = int.parse(provider.selectedMinute!);
      final dt = DateTime(
        provider.treatmentDate!.year,
        provider.treatmentDate!.month,
        provider.treatmentDate!.day,
        hour,
        minute,
      );
      final dateNdTime = DateFormat('dd/MM/yyyy-hh:mm a').format(dt);

      final List<String> maleIds = [];
      final List<String> femaleIds = [];
      final List<String> treatmentIds = [];

      List<InvoiceTreatment> invoiceTreatments = [];

      for (var selection in provider.selectedTreatments) {
        treatmentIds.add(selection.id);

        if (selection.maleCount > 0) {
          maleIds.add(selection.id);
        } else {
          maleIds.add("");
        }

        if (selection.femaleCount > 0) {
          femaleIds.add(selection.id);
        } else {
          femaleIds.add("");
        }

        final t = provider.treatments.firstWhere(
          (element) => element.id.toString() == selection.id,
          orElse: () => TreatmentModel(name: 'Unknown', price: '0'),
        );
        final price = double.tryParse(t.price?.toString() ?? '0') ?? 0;
        final total = price * (selection.maleCount + selection.femaleCount);

        invoiceTreatments.add(
          InvoiceTreatment(
            name: selection.name,
            price: price,
            maleCount: selection.maleCount,
            femaleCount: selection.femaleCount,
            total: total,
          ),
        );
      }

      var parts = dateNdTime.split('-');
      String treatmentDate = parts[0].trim();
      String treatmentTime = parts[1].trim();

      final invoiceModel = InvoiceModel(
        patientName: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        bookingDate: dateNdTime,
        treatmentDate: treatmentDate,
        treatmentTime: treatmentTime,
        treatments: invoiceTreatments,
        totalAmount: provider.totalAmount,
        discount: provider.discountAmount,
        advance: provider.advanceAmount,
        balance: provider.balanceAmount,
      );

      final Map<String, dynamic> data = {
        "name": _nameController.text,
        "excecutive": "sids",
        "payment": provider.selectedPayment,
        "phone": _phoneController.text,
        "address": _addressController.text,
        "total_amount": provider.totalAmount.toInt(),
        "discount_amount": provider.discountAmount.toInt(),
        "advance_amount": provider.advanceAmount.toInt(),
        "balance_amount": provider.balanceAmount.toInt(),
        "date_nd_time": dateNdTime,
        "id": "",
        "male": maleIds,
        "female": femaleIds,
        "branch": provider.selectedBranch ?? '',
        "treatments": treatmentIds,
      };

      final success = await provider.registerPatient(data);

      if (context.mounted) {
        if (success) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.clearRegistrationForm();
            _nameController.clear();
            _addressController.clear();
            _phoneController.clear();
            _totalAmountController.clear();
            _discountAmountController.clear();
            _advanceAmountController.clear();
            _balanceAmountController.clear();
            _formKey.currentState!.reset();
            SnackbarUtils.showSuccess("Patient registered successfully");
            Routes.pushNamed(Routes.invoice, arguments: invoiceModel);
          });
        } else {
          SnackbarUtils.showError(
            provider.errorMessage ?? "Registration failed",
          );
        }
      }
    }
  }
}
