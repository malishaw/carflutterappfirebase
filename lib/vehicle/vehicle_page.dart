import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'vehicle_info_page.dart'; // Import correct path for VehicleInfoPage
import 'vehicle_details_page.dart'; // Import correct path for VehicleDetailsPage

class VehiclePage extends StatelessWidget {
  List<Map<String, String>> vehicles = [];

  void addOrUpdateVehicle(Map<String, String>? vehicleInfo) {
    if (vehicleInfo != null) {
      vehicles.add(vehicleInfo);
    }
  }

  void edit(Map<String, String>? vehicleInfo) {
    if (vehicleInfo != null) {

      String? documentId = vehicleInfo['id'];
      print('Document ID: $documentId');
      // Find the index of the vehicle to be edited
      int index = vehicles.indexWhere((vehicle) => vehicle['id'] == documentId);
      // If the vehicle is found, update its information
      if (index != -1) {
        vehicles[index] = vehicleInfo;
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicles',
          style: TextStyle(fontSize: 16, color: const Color(0xff1e366e)),
        ),
      ),
      body: VehicleList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, String>? newVehicleInfo = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VehicleInfoPage(addVehicle: addOrUpdateVehicle ,)),
          );
          addOrUpdateVehicle(newVehicleInfo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class VehicleList extends StatelessWidget {
  List<Map<String, String>> vehicles = [];

  void addOrUpdateVehicle(Map<String, String>? vehicleInfo) {
    if (vehicleInfo != null) {
      vehicles.add(vehicleInfo);
  }}

  void editVehicle(Map<String, String>? vehicleInfo) {
    if (vehicleInfo != null) {
      // Find the index of the vehicle to be edited
      int index = vehicles.indexWhere((vehicle) => vehicle['id'] == vehicleInfo['id']);
      // If the vehicle is found, update it in the local list
      if (index != -1) {
        vehicles[index] = vehicleInfo;
      }
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteVehicle(String documentId) async {
    try {
      await _firestore.collection('vehicles').doc(documentId).delete();
    } catch (e) {
      print('Failed to delete vehicle: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('vehicles').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // or any other loading indicator
        }
        return ListView(
          children: snapshot.data!.docs.map((document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                tileColor: Colors.blueGrey.withOpacity(0.1),
                leading: data['imageUrl'] == null
                    ? SizedBox()
                    : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        child: Image.network(
                          '${data['imageUrl']}',
                        ),
                      ),
                title: Text('Model: ${data['model']}'),
                subtitle: Text(
                  'Make: ${data['make']}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VehicleDetailsPage(vehicleInfo: data)),
                  );
                },
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      // Press this button to edit a single product
                      IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueGrey,
                            size: 18,
                          ),
                        onPressed: () async {
                          Map<String, String>? editedVehicleInfo = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VehicleInfoPage(addVehicle: editVehicle, vehicleInfo: data.cast<String, String>()),
                            ),
                          );

                          // If editedVehicleInfo is not null, update the vehicle
                          if (editedVehicleInfo != null) {
                            editVehicle(editedVehicleInfo); // Update the vehicle locally
                            addOrUpdateVehicle(editedVehicleInfo); // Update the vehicle in Firestore
                          }
                        },


                          ),
                      //_createOrUpdate(documentSnapshot)),
                      // This icon button is used to delete a single product
                      IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 18,
                          ),
                          onPressed: () async{
                            await _deleteVehicle(document.id);
                          }

                          ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
