const express = require('express');
const { exec } = require('child_process');
const SerialPort = require('serialport');
const Readline = require('@serialport/parser-readline');

const app = express();
const port = 3000; // Change this port as needed

let obdData = {}; // Placeholder for OBD-II PID data

// Function to discover Bluetooth address
function discoverBluetoothAddress() {
  return new Promise((resolve, reject) => {
    exec('bluetoothctl show', (error, stdout, stderr) => {
      if (error) {
        reject(error);
        return;
      }
      const matches = stdout.match(/Device ([^\s]+)\s/);
      if (matches && matches.length > 1) {
        resolve(matches[1]);
      } else {
        reject('Bluetooth device not found');
      }
    });
  });
}

// Function to initialize serial port and parse OBD-II data
function initializeSerialPort() {
  discoverBluetoothAddress()
    .then((bluetoothAddress) => {
      const portName = `/dev/tty.${bluetoothAddress}`;
      const baudRate = 9600;

      const serialPort = new SerialPort(portName, { baudRate });
      const parser = serialPort.pipe(new Readline({ delimiter: '\r\n' }));

      serialPort.on('open', () => {
        console.log('Serial port opened');
      });

      serialPort.on('error', (err) => {
        console.error('Error:', err.message);
      });

      parser.on('data', (data) => {
        // Parse and process the received data
        console.log('Received data:', data);
        // Assuming the data format is in the form of key:value
        const pairs = data.split(',');
        pairs.forEach(pair => {
          const [key, value] = pair.split(':');
          obdData[key] = value;
        });
      });

      console.log(`Bluetooth address: ${bluetoothAddress}`);
    })
    .catch((error) => {
      console.error('Error discovering Bluetooth address:', error);
    });
}

initializeSerialPort();

app.get('/obd-data', (req, res) => {
  // Here you can send the latest OBD-II PID data to the frontend
  res.json(obdData);
});

// Allow access from any origin
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  next();
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server is running on port ${port}`);
});

process.on('SIGINT', () => {
  console.log('Closing server');
  process.exit(0); // Exit gracefully on SIGINT
});
