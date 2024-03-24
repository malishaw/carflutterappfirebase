import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sdgp_95/vehicle/vehicle_details_page.dart';

class VehicleUpdateAddPage extends StatefulWidget {
  const VehicleUpdateAddPage({Key? key}) : super(key: key);

  @override
  _VehicleUpdateAddPageState createState() => _VehicleUpdateAddPageState();
}

class _VehicleUpdateAddPageState extends State<VehicleUpdateAddPage> {
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController licenseNoController = TextEditingController();
  TextEditingController vinController = TextEditingController();
  TextEditingController insuranceController = TextEditingController();

  List<String> fuelTypes = ['Petrol', 'Diesel'];
  String selectedFuelType = 'Petrol';
  File? _selectedImage;

  final CollectionReference _vehicles =
      FirebaseFirestore.instance.collection('vehicle');

  @override
  void initState() {
    super.initState();
  }


  //Image Upload Functions
  String? imageUrl;
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


  Future<void> _createOrUpdateVehicle([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      makeController.text = documentSnapshot['make'];
      modelController.text = documentSnapshot['model'];
      licenseNoController.text = documentSnapshot['licensePlate'];
      vinController.text = documentSnapshot['vin'];
      insuranceController.text = documentSnapshot['insurance'];
      yearController.text = documentSnapshot['year'];
      imageUrl = documentSnapshot['imageUrl'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Center(
              child: Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              shrinkWrap: true,
              children: [
                _selectedImage != null?   Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                )
                    : SizedBox(),

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
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5)),
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
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5)),
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
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5)),
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
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5)),
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
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5)),
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
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5)),
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
                  style: TextStyle(
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
                        items: fuelTypes
                            .map<DropdownMenuItem<String>>((String value) {
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
                    )),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1e366e),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 150, vertical: 18),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    child: Text(action == 'create' ? 'Create' : 'Update', style: TextStyle(color: Colors.white,),),
                    onPressed: () async {
                      Map<String, String> vehicleInfo = {
                        'make': makeController.text,
                        'model': modelController.text,
                        'year': yearController.text,
                        'licensePlate': licenseNoController.text,
                        'vin': vinController.text,
                        'insurance': insuranceController.text,
                        'fuelType': selectedFuelType,
                      };



                      if (action == 'create') {


                        if (_selectedImage != null) {
                          String? imageUrl =
                              await _uploadImage(_selectedImage!);
                          if (imageUrl != null) {
                            vehicleInfo['imageUrl'] = imageUrl;
                          }
                        }else{
                          vehicleInfo['imageUrl'] = "";
                        }
                        // Persist a new product to Firestore
                        await _vehicles.add(vehicleInfo);
                        makeController.text = '';
                        modelController.text = '';
                        yearController.text = '';
                        insuranceController.text = '';
                        vinController.text = '';
                        licenseNoController.text = '';
                        _selectedImage = null;
                      }

                      if (action == 'update') {
                        // Update the product
                        if (_selectedImage != null) {
                          String? imageUrl =
                          await _uploadImage(_selectedImage!);
                          if (imageUrl != null) {
                            vehicleInfo['imageUrl'] = imageUrl;
                          }
                        }else{
                          vehicleInfo['imageUrl'] = "";
                        }
                        await _vehicles
                            .doc(documentSnapshot!.id)
                            .update(vehicleInfo);

                        makeController.text = '';
                        modelController.text = '';
                        yearController.text = '';
                        insuranceController.text = '';
                        vinController.text = '';
                        licenseNoController.text = '';

                        // Hide the bottom sheet
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //         backgroundColor: Colors.red,
                        //         content:
                        //             Text('Please add vehicle information')));
                      }
                    },
                  ),
                )
              ],
            ),
          ));
        });
  }

  // Deleteing a product by id
  Future<void> _deleteVehicle(String productId) async {
    await _vehicles.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('You have successfully deleted a vehicle')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _vehicles.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    tileColor: Colors.blueGrey.withOpacity(0.1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VehicleDetailsPage(
                                vehicleInfo: documentSnapshot.data()
                                    as Map<String, dynamic>)),
                      );
                    },
                    leading:  documentSnapshot['imageUrl'] == '' || documentSnapshot['imageUrl'] == null
                        ? SizedBox()
                        : Image.network(documentSnapshot['imageUrl']),
                    title: Text(documentSnapshot['model'] ,style:TextStyle(fontWeight: FontWeight.w600) ,),
                    subtitle: Text(documentSnapshot['make'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Iconsax.edit),
                              onPressed: () =>
                                  _createOrUpdateVehicle(documentSnapshot)),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: Icon(
                                Iconsax.trash,
                                color: Colors.red,
                              ),
                              onPressed: () =>
                                  _deleteVehicle(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _createOrUpdateVehicle(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
