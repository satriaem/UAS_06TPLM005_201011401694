import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';

void main() {
  runApp(MyWeatherApp());
}

class MyWeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Cuaca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String namaKota = "Tangerang Selatan";
  int temperature = 0;
  int maxTemperature = 0;
  int minTemperature = 0;
  String deskripsiCuaca = "";
  String date = "";

  Future<void> getWeatherData() async {
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$namaKota&appid=969116c6a2215379c38057138b6d279a&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final formattedDate =
          DateFormat('EEEE, MMMM d, y').format(DateTime.now());
      setState(() {
        temperature = data['main']['temp'].toInt();
        maxTemperature = data['main']['temp_max'].toInt();
        minTemperature = data['main']['temp_min'].toInt();
        deskripsiCuaca = data['weather'][0]['main'];
        date = formattedDate;
      });
    } else {
      throw Exception('Gagal memuat data cuaca');
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.postimg.cc/TY73Pmch/beach-2179183-1280.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                namaKota,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'SigmaFive'),
              ),
              SizedBox(height: 8),
              Text(
                '$date',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'SigmaFive',
                    color: Color.fromARGB(255, 24, 23, 23)),
              ),
              SizedBox(height: 20),
              Text(
                '$temperature°C',
                style: TextStyle(
                    fontSize: 60,
                    height: 1.0,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 15, 15, 15),
                    fontFamily: 'SigmaFive'),
              ),
              SizedBox(height: 0),
              Text(
                '---------',
                style: TextStyle(
                    fontSize: 60, color: const Color.fromARGB(255, 66, 65, 65)),
              ),
              SizedBox(height: 15),
              Text(
                deskripsiCuaca,
                style: TextStyle(
                    fontSize: 24,
                    color: const Color.fromARGB(255, 20, 20, 20),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SigmaFive'),
              ),
              SizedBox(height: 8),
              Text(
                '$maxTemperature°C / $minTemperature°C',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'SigmaFive',
                    color: Color.fromARGB(255, 17, 17, 17)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
