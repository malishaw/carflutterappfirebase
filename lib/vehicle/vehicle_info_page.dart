import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class VehicleInfoPage extends StatefulWidget {
  final Function(Map<String, String>?) addVehicle;
  final Map<String, String>? vehicleInfo;

  VehicleInfoPage(
      {required this.addVehicle, this.vehicleInfo});

  @override
  _VehicleInfoPageState createState() => _VehicleInfoPageState();
}

class _VehicleInfoPageState extends State<VehicleInfoPage> {
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController licenseNoController = TextEditingController();
  TextEditingController vinController = TextEditingController();
  TextEditingController insuranceController = TextEditingController();

  String errormsg = "";

  List<String> fuelTypes = ['Petrol', 'Diesel'];
  String selectedFuelType = 'Petrol';
  File? _selectedImage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _validateMake(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the $value';
    }
    return null;
  }

  void _selectImage() async {
    File? image = await _pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<String?> _uploadImage(File file) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      firebase_storage.UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() => print('Image uploaded'));
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.vehicleInfo != null) {
      makeController.text = widget.vehicleInfo!['make'] ?? '';
      modelController.text = widget.vehicleInfo!['model'] ?? '';
      yearController.text = widget.vehicleInfo!['year'] ?? '';
      licenseNoController.text = widget.vehicleInfo!['licensePlate'] ?? '';
      vinController.text = widget.vehicleInfo!['vin'] ?? '';
      insuranceController.text = widget.vehicleInfo!['insurance'] ?? '';
      selectedFuelType = widget.vehicleInfo!['fuelType'] ?? 'Petrol';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Vehicle Details'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      height: 250,
                      width: double.infinity,
                    )
                  : Container(),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: _selectImage,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: Colors.blueGrey),
                ),
                child: const Text(
                  'Select Image',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 25),
              const Divider(
                thickness: 2,
              ),
              const Text(
                'Vehicle Information',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blueGrey),
              ),
              const SizedBox(height: 15),
              const Text(
                'Make',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: makeController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.2,
                  ),
                  hintText: 'E.g. Toyota, Ford, Honda',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Model',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: modelController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.2,
                  ),
                  hintText: 'E.g. Camri, Ranger, Civic',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Year',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  hintText: 'Enter year',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'License Plate Number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: licenseNoController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.2,
                  ),
                  hintText: 'Enter License Plate Number',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'VIN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: vinController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.2,
                  ),
                  hintText: 'Enter VIN Number',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Insurance',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: insuranceController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.2,
                  ),
                  hintText: 'Enter Insurance Details',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Fuel Type',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedFuelType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFuelType = newValue!;
                      });
                    },
                    items:
                        fuelTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontStyle: FontStyle.italic),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (makeController.text == "" ||
                      modelController.text == "" ||
                      yearController.text == "" ||
                      licenseNoController.text == "" ||
                      vinController.text == "" ||
                      insuranceController.text == "" ||
                      selectedFuelType == "") {
                    // If the make field is empty, show an alert
                    setState(() {
                      errormsg = "Fill the form";
                    });
                  } else {
                    // If the make field is not empty, proceed with adding the vehicle
                    Map<String, String> vehicleInfo = {
                      'make': makeController.text,
                      'model': modelController.text,
                      'year': yearController.text,
                      'licensePlate': licenseNoController.text,
                      'vin': vinController.text,
                      'insurance': insuranceController.text,
                      'fuelType': selectedFuelType,
                    };

                    // if (_selectedImage != null) {
                    //   String? imageUrl = await _uploadImage(_selectedImage!);
                    //   if (imageUrl != null) {
                    //     vehicleInfo['imageUrl'] = imageUrl;
                    //   }
                    // }

                    if (widget.vehicleInfo != null) {

    if (_selectedImage != null) {
    String? imageUrl = await _uploadImage(_selectedImage!);
    if (imageUrl != null) {
    vehicleInfo['imageUrl'] = imageUrl;
    }
    }

    try {
    // Update the existing document in Firestore
    await _firestore.collection('vehicles').doc(vehicleInfo['id']).update(vehicleInfo);
    print('Vehicle updated successfully in Firestore');
    } catch (error) {
    print('Failed to update vehicle in Firestore: $error');
    }
                    } else {
                      _firestore
                          .collection('vehicles')
                          .add(vehicleInfo)
                          .then((value) {
                        print('Vehicle added successfully');
                        Navigator.pop(context);
                      }).catchError((error) {
                        print('Failed to add vehicle: $error');
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1e366e),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 18),
                    textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                child: const Text(
                  'Add Vehicle',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                errormsg,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
