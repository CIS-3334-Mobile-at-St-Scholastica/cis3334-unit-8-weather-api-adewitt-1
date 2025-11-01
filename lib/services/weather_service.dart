import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

/// Fetches Weather data from the API.
Future<List<DailyForecast>> fetchWeather() async {
  final uri = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=duluth&units=imperial&cnt=8&appid=5aa6c40803fbb300fe98c6728bdafce7');
  final resp = await http.get(uri);

  if (resp.statusCode != 200) {
    throw Exception('Weather API ${resp.statusCode}');
  }
  Weather weather = weatherFromJson(resp.body);
  return weather.list;
}
