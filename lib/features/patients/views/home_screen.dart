import 'package:flutter/material.dart';
import 'package:novindus_tets/core/constants/color_constants.dart';
import 'package:novindus_tets/core/constants/text_style_constants.dart';
import 'package:novindus_tets/core/widgets/loading_widget.dart';
import 'package:novindus_tets/core/widgets/nod_data_widget.dart';
import 'package:novindus_tets/core/widgets/primary_button.dart';
import 'package:novindus_tets/features/patients/views/widgets/patient_list_card.dart';

import 'package:provider/provider.dart';
import 'package:novindus_tets/core/routes/routes.dart';

import '../controllers/patient_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientController>().fetchPatients();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      context.read<PatientController>().filterByDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_on),
            onPressed: () {},
          ),
        ],
        backgroundColor: AppColors.background,
      ),
      body: Consumer<PatientController>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search for treatments',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              onChanged: (value) {
                                provider.searchPatients(value);
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: PrimaryButton(
                            height: 48,
                            onPressed: () =>
                                provider.searchPatients(_searchController.text),
                            text: "Search",
                            isSmallText: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sort by :", style: TextStyleConstants.heading3),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  provider.hasActiveFilters &&
                                          provider.selectedDate != null
                                      ? "${provider.selectedDate!.day}/${provider.selectedDate!.month}/${provider.selectedDate!.year}"
                                      : "Date",
                                  style: TextStyleConstants.labelStyle,
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (provider.hasActiveFilters)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              _searchController.clear();
                              provider.clearFilters();
                            },
                            icon: const Icon(Icons.clear, color: Colors.red),
                            label: Text(
                              "Clear Filters",
                              style: TextStyleConstants.bodySmall.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (provider.isLoading) {
                      return LoadingWidget();
                    }

                    if (provider.patients.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: provider.fetchPatients,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: NoDataWidget(text: "No patients found"),
                          ),
                        ),
                      );
                    }
                    if (provider.patientFetchError.isNotEmpty) {
                      return RefreshIndicator(
                        onRefresh: provider.fetchPatients,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: NoDataWidget(
                              text: provider.patientFetchError,
                            ),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: provider.fetchPatients,
                      child: ListView.builder(
                        itemCount: provider.patients.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final patient = provider.patients[index];
                          return PatientListCard(
                            patient: patient,
                            index: index,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: "Register Now",
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.register);
          },
        ),
      ),
    );
  }
}
