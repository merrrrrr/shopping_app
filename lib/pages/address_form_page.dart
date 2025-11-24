import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/models/address.dart';

class AddressFormPage extends StatefulWidget {
  final Address? address;

  const AddressFormPage({super.key, this.address});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
	final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();

  String _selectedState = 'Selangor';

  final List<String> _malaysianStates = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Penang',
    'Perak',
    'Perlis',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
    'Kuala Lumpur',
    'Labuan',
    'Putrajaya',
  ];

	Future<void> saveAddress() async {
		if (!_formKey.currentState!.validate()) {
      return;
    }

		try {
			final newAddress = Address(
				recipientName: _recipientNameController.text.trim(),
				phoneNumber: _phoneNumberController.text.trim(),
				addressLine1: _addressLine1Controller.text.trim(),
				addressLine2: _addressLine2Controller.text.trim(),
				city: _cityController.text.trim(),
				state: _selectedState,
				postcode: _postcodeController.text.trim(),
			).fullAddress;

			final user = _auth.currentUser;

			if (user == null) {
				throw Exception('User not found.');
			}

			QuerySnapshot userDocs = await _firestore
				.collection('users')
				.where('email', isEqualTo: user.email)
				.limit(1)
				.get();

			if (userDocs.docs.isEmpty) {
				throw Exception('User document not found.');
			}

			DocumentReference doc = userDocs.docs.first.reference;
      await doc.update({'address': newAddress});

			showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Address saved successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(content: Text('Failed to save address: $e'))
			);
  	}
	}

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? "Add Address" : "Edit Address"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _recipientNameController,
              decoration: InputDecoration(
                labelText: "Recipient Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter recipient name";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter phone number";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _addressLine1Controller,
              decoration: InputDecoration(
                labelText: "Address Line 1",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter address";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _addressLine2Controller,
              decoration: InputDecoration(
                labelText: "Address Line 2 (Optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter city";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedState,
              decoration: InputDecoration(
                labelText: "State",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _malaysianStates.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(
										state,
										style: const TextStyle(
											fontWeight: FontWeight.w500
										)
									),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _postcodeController,
              decoration: InputDecoration(
                labelText: "Postcode",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter postcode";
                }
                if (value.length != 5) {
                  return "Postcode must be 5 digits";
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
								saveAddress();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

}