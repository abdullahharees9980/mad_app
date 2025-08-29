import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' show placemarkFromCoordinates, Placemark;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mad_app/widgets/offline_wrapper.dart'; 
import 'package:flutter_contacts/flutter_contacts.dart';


class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreen({required this.cartItems, super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isLoadingLocation = false;

  Future<void> _getCurrentLocation() async {
  setState(() {
    _isLoadingLocation = true;
  });

  try {
  
    PermissionStatus permission = await Permission.location.status;
    if (!permission.isGranted) {
      permission = await Permission.location.request();
      if (!permission.isGranted) {
        _showSnackBar('Location permission denied. Please enable it in settings.');
        return;
      }
    }

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled. Please enable them.');
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String address = '${place.street ?? ''}, ${place.locality ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}';
      _addressController.text = address.trim();
      _showSnackBar('Location fetched successfully!');
    } else {
      _showSnackBar('Unable to fetch address. Please try again.');
    }
  } catch (e) {
    _showSnackBar('Error fetching location: $e');
  } finally {
    setState(() {
      _isLoadingLocation = false;
    });
  }
}

Future<void> _pickContact() async {
  if (!await FlutterContacts.requestPermission()) {
    _showSnackBar('Contacts permission denied');
    return;
  }

  try {
    // Fetch all contacts 
    List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
    List<Contact> contactsWithPhone = contacts
        .where((c) => c.phones.isNotEmpty)
        .toList()
      ..sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

    if (contactsWithPhone.isEmpty) {
      _showSnackBar('No contacts with phone numbers found');
      return;
    }

    // search bar
    Contact? selectedContact = await showDialog<Contact>(
      context: context,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<Contact> filteredContacts = List.from(contactsWithPhone);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select a Contact'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredContacts = contactsWithPhone
                              .where((c) => c.displayName.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          Contact contact = filteredContacts[index];
                          return ListTile(
                            title: Text(contact.displayName),
                            subtitle: Text(contact.phones.first.number),
                            onTap: () {
                              Navigator.pop(context, contact);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    // Autofill if user selected a contact
    if (selectedContact != null) {
      _contactController.text = selectedContact.phones.first.number;
      _showSnackBar('Contact selected: ${selectedContact.displayName}');
    }

  } catch (e) {
    _showSnackBar('Error fetching contacts: $e');
  }
}




  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWide = screenWidth > 600;

    Widget inputSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Information:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              child: _isLoadingLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Get Current Location'),
            ),
          ],
        ),
        const SizedBox(height: 10),
      Row(
  children: [
    Expanded(
      child: TextField(
        controller: _contactController,
        decoration: const InputDecoration(
          labelText: 'Contact Number',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.phone,
      ),
    ),
    const SizedBox(width: 8),
    IconButton(
      icon: const Icon(Icons.contacts),
      onPressed: _pickContact,
    ),
  ],
),

      ],
    );

    Widget summarySection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Price:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _addressController.text.isNotEmpty &&
                _contactController.text.isNotEmpty) {
              _showSnackBar('Order Placed Successfully');
            } else {
              _showSnackBar('Please fill in all fields');
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            'Place Order',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.blue,
      ),
      body: OfflineWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: inputSection),
                    const SizedBox(width: 20),
                    Expanded(child: summarySection),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputSection,
                    const SizedBox(height: 20),
                    summarySection,
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}
