import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../controllers/customer_controller.dart';

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CustomerController>() ? Get.find<CustomerController>() : Get.put(CustomerController(Get.find<ApiService>()), permanent: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            final customer = controller.selectedCustomer.value;
            if (customer == null) {
              return const Center(child: Text('No customer selected'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                _buildInfoSection(
                  'Personal Information',
                  [
                    _buildInfoTile('Spouse Name', customer.spouseName),
                    _buildInfoTile('Gotra', customer.gotra),
                    _buildInfoTile(
                      'Date of Birth',
                      DateFormat('dd/MM/yyyy').format(customer.dateOfBirth),
                    ),
                    if (customer.dateOfAnniversary != null)
                      _buildInfoTile(
                        'Date of Anniversary',
                        DateFormat('dd/MM/yyyy')
                            .format(customer.dateOfAnniversary!),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                if (customer.children.isNotEmpty) ...[
                  _buildListSection(
                    'Children',
                    customer.children.map((child) {
                      return ListTile(
                        title: Text(child.name),
                        subtitle: Text(
                          'Date of Birth: ${DateFormat('dd/MM/yyyy').format(child.dateOfBirth)}',
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                ],
                if (customer.ancestors.isNotEmpty) ...[
                  _buildListSection(
                    'Ancestors',
                    customer.ancestors.map((ancestor) {
                      return ListTile(
                        title: Text(ancestor.name),
                        subtitle: Text(
                          'Death Anniversary: ${DateFormat('dd/MM/yyyy').format(ancestor.deathAnniversary)}',
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                ],
                _buildInfoSection(
                  'Service Details',
                  [
                    _buildInfoTile('Selected Service', customer.selectedService),
                    _buildInfoTile(
                      'Service Duration',
                      customer.serviceDuration.toString().split('.').last,
                    ),
                    _buildInfoTile(
                      'Start Date',
                      DateFormat('dd/MM/yyyy')
                          .format(customer.serviceDurationStartDate),
                    ),
                    _buildInfoTile(
                      'End Date',
                      DateFormat('dd/MM/yyyy')
                          .format(customer.serviceDurationEndDate),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 