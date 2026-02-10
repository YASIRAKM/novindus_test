import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novindus_tets/core/constants/color_constants.dart';
import 'package:novindus_tets/core/constants/text_style_constants.dart';
import '../../models/patient_model.dart';

class PatientListCard extends StatelessWidget {
  const PatientListCard({
    super.key,
    required this.patient,
    required this.index,
  });

  final PatientModel patient;
  final int index;

  @override
  Widget build(BuildContext context) {
    final String name = patient.name ?? 'Unknown';
    final String user = patient.user ?? 'Unknown User';

    final List<PatientDetail> details = patient.patientdetailsSet ?? [];
    final List<String> treatmentNames = details
        .map((d) => d.treatmentName)
        .where((name) => name != null && name.isNotEmpty)
        .map((name) => name!)
        .toList();
    final String treatmentsString = treatmentNames.isEmpty
        ? 'No treatments'
        : treatmentNames.join(', ');

    String dateString = 'No Date';
    if (patient.dateNdTime != null) {
      try {
        final DateTime parsedDate = DateTime.parse(patient.dateNdTime!);
        dateString = DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (e) {
        dateString = 'No Date';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.textFieldFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${index + 1}. ", style: TextStyleConstants.heading2),
                SizedBox(width: 3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyleConstants.cardTitle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        treatmentsString,
                        style: TextStyleConstants.cardSubtitle,
                        // maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 15,
                                color: AppColors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                dateString,
                                style: TextStyleConstants.cardInfo,
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const Icon(
                                Icons.people_alt_outlined,
                                size: 15,
                                color: AppColors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(user, style: TextStyleConstants.cardInfo),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.textLight, thickness: 0.5),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "View Booking details",
                  style: TextStyleConstants.actionText,
                ),
                SizedBox(width: 12),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
