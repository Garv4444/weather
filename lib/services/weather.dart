import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';

const apiKey = '40c90881e3a2af0a07cf718fddcf9ed0';

class WeatherModel {
  Future getCityData(String typedCity) async {
    var url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$typedCity&appid=$apiKey&units=metric');
    var weatherData = await NetworkHelper(url).getData();
    return weatherData;
  }

  Future getLocationData() async {
    Location location = Location();
    await location.getCurrentLocation();
    var url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var weatherData = await NetworkHelper(url).getData();
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
