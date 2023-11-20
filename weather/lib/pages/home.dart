import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> _weatherData = {};

  Future<void> _getWeatherData(String location) async {
    final apiKey = '4e296985875041cc9e7154319232011';
    final apiUrl = 'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location&aqi=yes';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        // Check if the data exists and it's a valid object
        if (decodedData != null && decodedData is Map<String, dynamic>) {
          // Check if the current property exists
          if (decodedData['current'] != null && decodedData['current'] is Map<String, dynamic>) {
            // Extract the current weather data
            final weatherData = decodedData['current'];

            // Update the weather data
            setState(() {
              _weatherData = weatherData;
            });
          } else {
            print('Invalid response structure');
          }
        } else {
          print('Invalid response data');
        }
      } else {
        print('Failed to fetch weather data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching weather data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter City',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _getWeatherData(_searchController.text);
                  },
                  child: const Text('Search Weather'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            if (_weatherData.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.wb_sunny),
                        title: Text('Temperature: ${_weatherData['temp_c']}°C'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.opacity),
                        title: Text('Humidity: ${_weatherData['humidity']}%'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.airplanemode_active),
                        title: Text('Wind Gust: ${_weatherData['gust_kph']} km/h'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.cloud),
                        title: Text('Condition: ${_weatherData['condition']['text']}'),
                      ),
                    ),
                  ],
                ),
              )
            else
              const Text('No weather data available'),
          ],
        ),
      ),
    );
  }
}
