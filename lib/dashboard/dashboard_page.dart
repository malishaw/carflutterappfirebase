import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'coolant_temperature_card.dart';
import 'mileagecard.dart';
import 'airflow_rate_card.dart';
import 'batterycard.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late BluetoothConnection connection;

  double coolantTemperature = 48.5;
  double mileageLevel = 58325.2;
  double airflowRate = 5.2;
  double batteryLevel = 89.8;

  bool isConnecting = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initBluetoothConnection() async {
    setState(() {
      isConnecting = true;
    });

    // Get the list of paired devices
    List<BluetoothDevice> bondedDevices = [];
    try {
      bondedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();
    } catch (error) {
      print('Error fetching bonded devices: $error');
    }

    // Show dialog to select a device
    BluetoothDevice? selectedDevice = await showDialog<BluetoothDevice>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Bluetooth Device'),
          content: SingleChildScrollView(
            child: ListBody(
              children: bondedDevices.map((device) {
                return ListTile(
                  title: Text(device.name ?? ''),
                  onTap: () {
                    Navigator.pop(context, device);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (selectedDevice != null) {
      // Connect to the selected device
      _connectToDevice(selectedDevice);
    } else {
      // No device selected
      setState(() {
        isConnecting = false;
      });
    }
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      // Connection established, proceed with data transfer
      // Register listener for incoming data
      connection.input?.listen(_onDataReceived)?.onDone(() {
        // Handle disconnection
      });
      setState(() {
        isConnecting = false;
      });
    } catch (error) {
      setState(() {
        isConnecting = false;
      });
      // Handle connection error
      print('Error connecting to device: $error');
    }
  }

  void _onDataReceived(List<int> data) {
    // Parse data received from ECU
    String response = String.fromCharCodes(data);
    List<String> values = response.split(',');

    values.forEach((value) {
      List<String> parts = value.split(':');
      if (parts.length == 2) {
        String key = parts[0];
        double parsedValue = double.tryParse(parts[1]) ?? 0.0;
        switch (key) {
          case 'CT':
            setState(() {
              coolantTemperature = parsedValue;
            });
            break;
          case 'ML':
            setState(() {
              mileageLevel = parsedValue;
            });
            break;
          case 'AR':
            setState(() {
              airflowRate = parsedValue;
            });
            break;
          case 'BL':
            setState(() {
              batteryLevel = parsedValue;
            });
            break;
          default:
            break;
        }
      }
    });
  }
  
  Future<void> _fetchDataFromBackend() async {
    final url = Uri.parse('http://localhost:3000/data'); // Change this URL to match your backend endpoint
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Process the responseData as needed
        setState(() {
          coolantTemperature = responseData['coolantTemperature'] ?? 0.0;
          mileageLevel = responseData['mileageLevel'] ?? 0.0;
          airflowRate = responseData['airflowRate'] ?? 0.0;
          batteryLevel = responseData['batteryLevel'] ?? 0.0;
        });
      } else {
        // Handle errors
        print('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle network errors
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CoolantTemperatureCard(coolantTemperature: coolantTemperature),
              SizedBox(height: 16.0),
              MileageCard(mileageLevel: mileageLevel),
              SizedBox(height: 16.0),
              AirflowRateCard(airflowRate: airflowRate),
              SizedBox(height: 16.0),
              BatteryCard(batteryLevel: batteryLevel),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isConnecting ? null : _initBluetoothConnection,
                child: isConnecting ? CircularProgressIndicator() : Text('Connect to Bluetooth Device'),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Car Dashboard',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
      ),
    );
  }
}
