import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the time

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Converter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimeConverterScreen(),
    );
  }
}

class TimeConverterScreen extends StatefulWidget {
  @override
  _TimeConverterScreenState createState() => _TimeConverterScreenState();
}

class _TimeConverterScreenState extends State<TimeConverterScreen> {
  late String _currentTime; // Holds the current time as a string
  String _selectedTimeZone = 'WIB'; // Default time zone

  // List of time zones to choose from
  final List<String> _timeZones = ['WIB', 'WITA', 'WIT'];

  @override
  void initState() {
    super.initState();
    _currentTime = _getCurrentTime(); // Initialize with current time
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _getCurrentTime(); // Update the time every second
      });
    });
  }

  // Function to get the current time in the selected time zone
  String _getCurrentTime() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    switch (_selectedTimeZone) {
      case 'WIB':
        return _convertToWib(now);
      case 'WITA':
        return _convertToWita(now);
      case 'WIT':
        return _convertToWit(now);
      default:
        return formattedTime;
    }
  }

  // Convert current time to WIB (Waktu Indonesia Barat) = UTC + 7
  String _convertToWib(DateTime time) {
    DateTime wibTime = time.toUtc().add(Duration(hours: 7));
    return DateFormat('HH:mm:ss').format(wibTime);
  }

  // Convert current time to WITA (Waktu Indonesia Tengah) = UTC + 8
  String _convertToWita(DateTime time) {
    DateTime witaTime = time.toUtc().add(Duration(hours: 8));
    return DateFormat('HH:mm:ss').format(witaTime);
  }

  // Convert current time to WIT (Waktu Indonesia Timur) = UTC + 9
  String _convertToWit(DateTime time) {
    DateTime witTime = time.toUtc().add(Duration(hours: 9));
    return DateFormat('HH:mm:ss').format(witTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Clock with Time Zone Converter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Digital clock display
            Text(
              _currentTime,
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier New',
              ),
            ),
            SizedBox(height: 40),
            
            // Dropdown for selecting time zone
            DropdownButton<String>(
              value: _selectedTimeZone,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTimeZone = newValue!;
                  _currentTime = _getCurrentTime(); // Update time based on new selection
                });
              },
              items: _timeZones.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
