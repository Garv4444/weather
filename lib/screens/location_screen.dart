import 'package:flutter/material.dart';
import 'package:weather/utilities/constants.dart';
import 'package:weather/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({this.weatherData});
  final weatherData;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  late int temperature;
  late String weatherIcon;
  late String message;
  late String cityName;

  @override
  void initState() {
    super.initState();
    updatedData(widget.weatherData);
  }

  void updatedData(weatherData) {
    setState(
          () {
        if (weatherData != Null) {
          temperature = weatherData['main']['temp'].toInt();
          int condition = weatherData['weather'][0]['id'];
          weatherIcon = weatherModel.getWeatherIcon(condition);
          message = weatherModel.getMessage(temperature);
          cityName = weatherData['name'];
        } else {
          temperature = 0;
          weatherIcon = '';
          message = 'Error, location inaccessible or incorrect city entered';
          cityName = '';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await WeatherModel().getLocationData();
                      updatedData(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedCity = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CityScreen();
                          },
                        ),
                      );
                      var weatherData =
                      await WeatherModel().getCityData(typedCity);
                      updatedData(weatherData);
                    },
                    child: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature??',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0).copyWith(bottom: 70),
                child: Text(
                  '$message in $cityName',
                  textAlign: TextAlign.center,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
