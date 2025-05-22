import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shri_amareshwar_mahadev/controllers/customer_provider.dart';

class AddCustomerScreen extends StatefulWidget {
  final int categoryId;
  const AddCustomerScreen({super.key, required this.categoryId});

  @override
  State<AddCustomerScreen> createState() => AddCustomerScreenState();
}

class AddCustomerScreenState extends State<AddCustomerScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerProvider>(context, listen: false).clearFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Customer')),
      body: Consumer<CustomerProvider>(
        builder: (BuildContext context, CustomerProvider value, Widget? child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: value.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text('Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // GestureDetector(
                  //   onTap: () => value.pickImage(),
                  //   child: Container(
                  //     height: 150,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.grey),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: value.selectedImageFile != null
                  //         ? ClipRRect(
                  //       borderRadius: BorderRadius.circular(8),
                  //       child: Image.file(value.selectedImageFile!, fit: BoxFit.cover),
                  //     ) : const Center(child: Text('Tap to select image')),
                  //   ),
                  // ),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: value.selectedImageFile != null
                              ? FileImage(value.selectedImageFile!)
                              : const AssetImage('assets/images/placeholder.png') as ImageProvider,
                          backgroundColor: Colors.grey[200],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => value.pickImage(),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: value.firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: value.lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: value.phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: value.spouseNameController,
                    decoration: const InputDecoration(labelText: 'Spouse Name', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter spouse name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: value.gotraController,
                    decoration: const InputDecoration(labelText: 'Gotra', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter gotra';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    title: const Text('Date of Birth'),
                    subtitle: Text(value.dateOfBirth != null ? DateFormat('dd/MM/yyyy').format(value.dateOfBirth!) : 'Not selected'),
                    leading: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                      if (date != null) {
                        value.setDateOfBirth(date);
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    title: const Text('Date of Anniversary'),
                    subtitle: Text(value.dateOfAnniversary != null ? DateFormat('dd/MM/yyyy').format(value.dateOfAnniversary!) : 'Not selected'),
                    leading: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                      if (date != null) {
                        value.setDateOfAnniversary(date);
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    title: const Text('Date of Death'),
                    subtitle: Text(value.dateOfDeath != null ? DateFormat('dd/MM/yyyy').format(value.dateOfDeath!) : 'Not selected'),
                    leading: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                      if (date != null) {
                        value.setDateOfDeath(date);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Children', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.children.length,
                    itemBuilder: (context, index) {
                      final child = value.children[index];
                      return ListTile(title: Text(child.name), subtitle: Text(DateFormat('dd/MM/yyyy').format(child.dateOfBirth)), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => value.removeChild(index)));
                    },
                  ),
                  ElevatedButton.icon(onPressed: () => _showAddChildDialog(context, value), icon: const Icon(Icons.add), label: const Text('Add Child')),
                  const SizedBox(height: 20),
                  const Text('Ancestors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.ancestors.length,
                    itemBuilder: (context, index) {
                      final ancestor = value.ancestors[index];
                      return ListTile(title: Text(ancestor.name), subtitle: Text(DateFormat('dd/MM/yyyy').format(ancestor.dateOfBirth)), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => value.removeAncestor(index)));
                    },
                  ),
                  ElevatedButton.icon(onPressed: () => _showAddAncestorDialog(context, value), icon: const Icon(Icons.add), label: const Text('Add Ancestor')),
                  const SizedBox(height: 20),
                  const Text('Service Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: value.serviceDuration,
                    decoration: const InputDecoration(labelText: 'Service Duration', prefixIcon: Icon(Icons.timer_outlined)),
                    items:
                    value.serviceDurationMap.entries.map((entry) {
                      return DropdownMenuItem<String>(value: entry.key, child: Text(entry.value));
                    }).toList(),
                    onChanged: (String? selected) {
                      if (selected != null) {
                        debugPrint("selected value =====> $selected");
                        value.setServiceDuration(selected);
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    title: const Text('Service End Date'),
                    subtitle: Text(value.serviceEndDate != null ? DateFormat('dd/MM/yyyy').format(value.serviceEndDate!) : 'Not selected'),
                    leading: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
                      if (date != null) {
                        value.setServiceEndDate(date);
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: value.addressController,
                    decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                    minLines: 4,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: value.isLoading ? null : () => value.addCustomer(context, widget.categoryId),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      decoration: BoxDecoration(color: value.isLoading ? Colors.grey : Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(8)),
                      child: value.isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Add Customer', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddChildDialog(BuildContext context, CustomerProvider controller) async {
    final nameController = TextEditingController();
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
        builder:
            (context, setState) => AlertDialog(
          title: const Text('Add Child'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Child Name', border: OutlineInputBorder())),
              const SizedBox(height: 15),
              ListTile(
                title: const Text('Date of Birth'),
                subtitle: Text(selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : 'Not selected'),
                leading: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                  if (date != null) {
                    selectedDate = date;
                    setState(() {}); // Update UI
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && selectedDate != null) {
                  controller.addChild(nameController.text, selectedDate!);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAncestorDialog(BuildContext context, CustomerProvider controller) async {
    final nameController = TextEditingController();
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
        builder:
            (context, setState) => AlertDialog(
          title: const Text('Add Ancestor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Ancestor Name', border: OutlineInputBorder())),
              const SizedBox(height: 15),
              ListTile(
                title: const Text('Date of Birth'),
                subtitle: Text(selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : 'Not selected'),
                leading: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                  if (date != null) {
                    selectedDate = date;
                    setState(() {}); // Update UI
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && selectedDate != null) {
                  controller.addAncestor(nameController.text, selectedDate!);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}