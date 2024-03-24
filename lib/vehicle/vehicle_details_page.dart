import 'package:flutter/material.dart';

class VehicleDetailsPage extends StatelessWidget {
  final Map<String, dynamic> vehicleInfo;

  VehicleDetailsPage({required this.vehicleInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
      ),
      body: ListView(
        children: [
          vehicleInfo['imageUrl'] == '' ?SizedBox(): SizedBox(
              height: 400,
              width: double.infinity,
              child: Image.network('${vehicleInfo['imageUrl']}', fit: BoxFit.cover,)),
          ListTile(
            leading: Text('Year:'),
            trailing: Text(' ${vehicleInfo['year']}'),
          ),
          ListTile(
            leading: Text('Model: '),
            trailing: Text('${vehicleInfo['model']}'),
          ),
          ListTile(
            leading: Text('License Plate Number:'),
            trailing: Text('${vehicleInfo['licensePlate']}'),
          ),
          ListTile(
            leading: Text('VIN: '),
            trailing: Text('${vehicleInfo['vin']}'),
          ),
          ListTile(
            leading: Text('Insurance: '),
            trailing: Text('${vehicleInfo['insurance']}'),
          ),
          ListTile(
            leading: Text('Fuel Type: '),
            trailing: Text('${vehicleInfo['fuelType']}'),
          ),
          // ListTile(
          //   title: Text('Edit'),
          //   leading: Icon(Icons.edit),
          //   onTap: () {
          //    // Navigator.push(
          //       //context,
          //       //MaterialPageRoute(builder: (context) => EditVehicleInfoPage(vehicleInfo: vehicleInfo)),
          //    // );
          //   },
          // ),
        ],
      ),
    );
  }
}
