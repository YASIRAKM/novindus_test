import 'package:flutter/material.dart';
import 'package:novindus_tets/core/constants/color_constants.dart';
import 'package:novindus_tets/core/widgets/primary_button.dart';
import 'package:novindus_tets/core/widgets/custom_dropdown_field.dart';
import 'package:provider/provider.dart';
import '../../models/treatment_selection_model.dart';
import '../../controllers/patient_registration_controller.dart';

class TreatmentSelectionWidget extends StatelessWidget {
  const TreatmentSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientRegistrationController>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Treatments",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            ...provider.selectedTreatments.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == provider.selectedTreatments.length - 1
                      ? 0
                      : 8,
                ),
                child: _TreatmentCard(
                  index: index,
                  item: item,
                  onEdit: () {
                    provider.prepareEditTreatment(item);
                    _showAddTreatmentDialog(context);
                  },
                  onDelete: () => provider.removeTreatment(index),
                ),
              );
            }),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                provider.prepareAddTreatment();
                _showAddTreatmentDialog(context);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "+ Add Treatments",
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddTreatmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const _AddTreatmentDialog();
      },
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  final int index;
  final TreatmentSelection item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TreatmentCard({
    required this.index,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.textFieldFill.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}. ${item.name}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCountBadge("Male", item.maleCount),
                    const SizedBox(width: 24),
                    _buildCountBadge("Female", item.femaleCount),
                  ],
                ),
              ],
            ),
          ),

          Column(
            children: [
              InkWell(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 219, 129, 129),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
       
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountBadge(String label, int count) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.primary, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddTreatmentDialog extends StatelessWidget {
  const _AddTreatmentDialog();

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientRegistrationController>(
      builder: (context, provider, _) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdownField<String>(
                  label: "Choose Treatment",
                  value: provider.draftTreatmentId,
                  hint: "Choose preferred treatment",
                  items: provider.treatments.map<DropdownMenuItem<String>>((t) {
                    return DropdownMenuItem(
                      value: t.id.toString(),
                      child: Text(t.name ?? 'Unknown'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    provider.setDraftTreatmentId(val);
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Add Patients",
                  style: TextStyle(fontSize: 14, color: AppColors.textLight),
                ),
                const SizedBox(height: 12),
                _buildCounterRow("Male", provider.draftMaleCount, (val) {
                  provider.updateDraftCounts(male: val);
                }),
                const SizedBox(height: 12),
                _buildCounterRow("Female", provider.draftFemaleCount, (val) {
                  provider.updateDraftCounts(female: val);
                }),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: "Save",
                  onPressed: () {
                    provider.saveTreatmentDraft(provider.treatments);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCounterRow(
    String label,
    int currentCount,
    Function(int) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(label),
        ),
        Row(
          children: [
            _CounterButton(
              icon: Icons.remove,
              onTap: () {
                if (currentCount > 0) onChanged(currentCount - 1);
              },
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentCount.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            _CounterButton(
              icon: Icons.add,
              onTap: () => onChanged(currentCount + 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
