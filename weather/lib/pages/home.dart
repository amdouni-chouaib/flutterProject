// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _searchController = TextEditingController();
//   Map<String, dynamic> _weatherData = {};

//   Future<void> _getWeatherData(String location) async {
//     final apiKey = '4e296985875041cc9e7154319232011';
//     final apiUrl = 'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location&aqi=yes';

//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         final decodedData = jsonDecode(response.body);

//         // Check if the data exists and it's a valid object
//         if (decodedData != null && decodedData is Map<String, dynamic>) {
//           // Check if the current property exists
//           if (decodedData['current'] != null && decodedData['current'] is Map<String, dynamic>) {
//             // Extract the current weather data
//             final weatherData = decodedData['current'];

//             // Update the weather data
//             setState(() {
//               _weatherData = weatherData;
//             });
//           } else {
//             print('Invalid response structure');
//           }
//         } else {
//           print('Invalid response data');
//         }
//       } else {
//         print('Failed to fetch weather data. Status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error fetching weather data: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter City',
//                       prefixIcon: Icon(Icons.search),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     _getWeatherData(_searchController.text);
//                   },
//                   child: const Text('Search Weather'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20.0),
//             if (_weatherData.isNotEmpty)
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Card(
//                       child: ListTile(
//                         leading: Icon(Icons.wb_sunny),
//                         title: Text('Temperature: ${_weatherData['temp_c']}°C'),
//                       ),
//                     ),
//                     Card(
//                       child: ListTile(
//                         leading: Icon(Icons.opacity),
//                         title: Text('Humidity: ${_weatherData['humidity']}%'),
//                       ),
//                     ),
//                     Card(
//                       child: ListTile(
//                         leading: Icon(Icons.airplanemode_active),
//                         title: Text('Wind Gust: ${_weatherData['gust_kph']} km/h'),
//                       ),
//                     ),
//                     Card(
//                       child: ListTile(
//                         leading: Icon(Icons.cloud),
//                         title: Text('Condition: ${_weatherData['condition']['text']}'),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               const Text('No weather data available'),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _weeklyWeatherData = [];

  Future<void> _getWeeklyWeatherData(String location) async {
    final apiKey = 'WLKqBAxOLXD7cqb5T1TRyw41RY2oYAwk';
    final apiUrl = 'https://api.tomorrow.io/v4/weather/forecast?location=$location&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        // Log the entire response for debugging
        print('API Response: $decodedData');

        // Check if the 'timelines' property is present
        if (decodedData.containsKey('timelines')) {
          // Extract the 'daily' timeline
          final dailyTimeline = decodedData['timelines']['daily'];

          // Check if 'daily' timeline is present and contains a non-empty list
          if (dailyTimeline is List && dailyTimeline.isNotEmpty) {
            // Extract the weekly weather data
            final weeklyWeatherData = List<Map<String, dynamic>>.from(dailyTimeline);

            // Update the weather data
            setState(() {
              _weeklyWeatherData = weeklyWeatherData;
            });
          } else {
            print('Invalid daily timeline. Missing or empty daily timeline.');
          }
        } else {
          print('Invalid timelines property. Missing or invalid timelines property.');
        }
      } else {
        print('Failed to fetch weather data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching weather data: $error');
    }
  }

  // Function to get condition icon based on weather code
  Icon getConditionIcon(int weatherCode) {
    switch (weatherCode) {
      case 1000: // Clear
        return Icon(Icons.wb_sunny);
      case 1001: // Cloudy
        return Icon(Icons.cloud);
      case 1100: // Mostly Clear
      case 1101: // Partly Cloudy
      case 1102: // Mostly Cloudy
        return Icon(Icons.cloud_queue);
      case 2000: // Fog
      case 2100: // Light Fog
        return Icon(Icons.cloud_off);
      case 3000: // Light Rain
      case 3001: // Rain
      case 3002: // Heavy Rain
        return Icon(Icons.grain);
      case 4000: // Light Snow
      case 4001: // Snow
      case 4002: // Heavy Snow
        return Icon(Icons.ac_unit);
      case 5000: // Sleet
      case 5001: // Freezing Rain
      case 5002: // Heavy Freezing Rain
        return Icon(Icons.ac_unit); // Adjust this icon accordingly
      case 6000: // Light Showers
      case 6001: // Showers
      case 6002: // Heavy Showers
        return Icon(Icons.grain); // Adjust this icon accordingly
      case 7000: // Thunderstorm
        return Icon(Icons.flash_on);
      case 8000: // Light Drizzle
      case 8001: // Drizzle
      case 8002: // Heavy Drizzle
        return Icon(Icons.grain); // Adjust this icon accordingly
      default:
        return Icon(Icons.error); // Default icon for unknown weather codes
    }
  }

  String formatDate(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      return formattedDate;
    } catch (e) {
      print('Error formatting date: $e');
      return 'Invalid Date';
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
        child: SingleChildScrollView(
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
                      _getWeeklyWeatherData(_searchController.text);
                    },
                    child: const Text('Search Weather'),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              if (_weeklyWeatherData.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final dayData in _weeklyWeatherData)
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Date: ${formatDate(dayData['time'])}'),
                            ),
                            ListTile(
                              leading: Icon(Icons.wb_sunny), // Temperature icon
                              title: Text('Temperature: ${dayData['values']['temperatureAvg']}°C'),
                            ),
                            ListTile(
                              leading: Icon(Icons.opacity), // Humidity icon
                              title: Text('Humidity: ${dayData['values']['humidityAvg']}%'),
                            ),
                            ListTile(
                              leading: Icon(Icons.airplanemode_active), // Wind Gust icon
                              title: Text('Wind Gust: ${dayData['values']['windGustAvg']} km/h'),
                            ),
                            ListTile(
                              leading: getConditionIcon(dayData['values']['weatherCodeMin']),
                              title: Text('Condition: ${dayData['values']['weatherCodeMin']}'),
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              else
                const Text('No weather data available'),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
