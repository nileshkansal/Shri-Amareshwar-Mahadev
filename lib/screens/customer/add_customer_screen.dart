import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/customer_controller.dart';
import '../../models/customer_model.dart';
import '../../services/api_service.dart';
import '../../controllers/auth_controller.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CustomerController>() ? Get.find<CustomerController>() : Get.put(CustomerController(Get.find<ApiService>()), permanent: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: controller.firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.spouseNameController,
                decoration: const InputDecoration(
                  labelText: 'Spouse Name',
                  prefixIcon: Icon(Icons.people_outline),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.gotraController,
                decoration: const InputDecoration(
                  labelText: 'Gotra',
                  prefixIcon: Icon(Icons.family_restroom),
                ),
              ),
              const SizedBox(height: 15),
              Obx(() => ListTile(
                    title: const Text('Date of Birth'),
                    subtitle: Text(
                      controller.dateOfBirth.value != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(controller.dateOfBirth.value!)
                          : 'Not selected',
                    ),
                    leading: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        controller.dateOfBirth.value = date;
                      }
                    },
                  )),
              const SizedBox(height: 15),
              Obx(() => ListTile(
                    title: const Text('Date of Anniversary'),
                    subtitle: Text(
                      controller.dateOfAnniversary.value != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(controller.dateOfAnniversary.value!)
                          : 'Not selected',
                    ),
                    leading: const Icon(Icons.favorite_outline),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        controller.dateOfAnniversary.value = date;
                      }
                    },
                  )),
              const SizedBox(height: 20),
              const Text(
                'Children',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.children.length,
                    itemBuilder: (context, index) {
                      final child = controller.children[index];
                      return ListTile(
                        title: Text(child.name),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy').format(child.dateOfBirth),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => controller.removeChild(index),
                        ),
                      );
                    },
                  )),
              ElevatedButton.icon(
                onPressed: () => _showAddChildDialog(context, controller),
                icon: const Icon(Icons.add),
                label: const Text('Add Child'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ancestors',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.ancestors.length,
                    itemBuilder: (context, index) {
                      final ancestor = controller.ancestors[index];
                      return ListTile(
                        title: Text(ancestor.name),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy')
                              .format(ancestor.deathAnniversary),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => controller.removeAncestor(index),
                        ),
                      );
                    },
                  )),
              ElevatedButton.icon(
                onPressed: () => _showAddAncestorDialog(context, controller),
                icon: const Icon(Icons.add),
                label: const Text('Add Ancestor'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Service Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: controller.selectedService.value.isEmpty ? null : controller.selectedService.value,
                decoration: const InputDecoration(
                  labelText: 'Service',
                  border: OutlineInputBorder(),
                ),
                items: Get.find<AuthController>().user.value?.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.name,
                    child: Text(category.name),
                  );
                }).toList() ?? [],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedService.value = newValue;
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a service';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Obx(() => DropdownButtonFormField<ServiceDuration>(
                    value: controller.serviceDuration.value,
                    decoration: const InputDecoration(
                      labelText: 'Service Duration',
                      prefixIcon: Icon(Icons.timer_outlined),
                    ),
                    items: ServiceDuration.values
                        .map((duration) => DropdownMenuItem(
                              value: duration,
                              child: Text(duration.toString().split('.').last),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.serviceDuration.value = value;
                      }
                    },
                  )),
              const SizedBox(height: 15),
              Obx(() => ListTile(
                    title: const Text('Service Start Date'),
                    subtitle: Text(
                      controller.serviceDurationStartDate.value != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(controller.serviceDurationStartDate.value!)
                          : 'Not selected',
                    ),
                    leading: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        controller.serviceDurationStartDate.value = date;
                      }
                    },
                  )),
              const SizedBox(height: 15),
              Obx(() => ListTile(
                    title: const Text('Service End Date'),
                    subtitle: Text(
                      controller.serviceDurationEndDate.value != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(controller.serviceDurationEndDate.value!)
                          : 'Not selected',
                    ),
                    leading: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        controller.serviceDurationEndDate.value = date;
                      }
                    },
                  )),
              const SizedBox(height: 30),
              Obx(() => ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.addCustomer,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Add Customer'),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddChildDialog(
      BuildContext context, CustomerController controller) async {
    final nameController = TextEditingController();
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Child'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 15),
            ListTile(
              title: const Text('Date of Birth'),
              subtitle: Text(selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                  : 'Not selected'),
              leading: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  selectedDate = date;
                  (context as Element).markNeedsBuild();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && selectedDate != null) {
                controller.addChild(nameController.text, selectedDate!);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddAncestorDialog(
      BuildContext context, CustomerController controller) async {
    final nameController = TextEditingController();
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Ancestor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 15),
            ListTile(
              title: const Text('Death Anniversary'),
              subtitle: Text(selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                  : 'Not selected'),
              leading: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  selectedDate = date;
                  (context as Element).markNeedsBuild();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && selectedDate != null) {
                controller.addAncestor(nameController.text, selectedDate!);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
} 