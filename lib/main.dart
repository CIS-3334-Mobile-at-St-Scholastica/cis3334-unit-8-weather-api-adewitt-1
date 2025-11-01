import 'package:flutter/material.dart';
import 'services/weather_service.dart';
import 'models/weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CIS 3334 Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Future<List<DailyForecast>> futureWeatherForecasts;

  @override
  void initState() {
    super.initState();
    futureWeatherForecasts = fetchWeather();
  }

  Widget weatherTile (DailyForecast dailyForecast) {
    // print ("Inside weatherTile and setting up tile for positon ${dailyForecast}");
    return ListTile(
      leading: weatherImage(dailyForecast.weather[0].main),
      title: Text('Temperature will be ${dailyForecast.main.temp}'),
      subtitle: Text("${dailyForecast.weather[0].main}: ${dailyForecast.weather[0].description}. High: ${dailyForecast.main.tempMax} Low: ${dailyForecast.main.tempMin}"),
      trailing: Text("Forecast Time: ${dailyForecast.dtTxt.toLocal()}"),
    );
  }

  Widget weatherImage (String weatherMain) {
    final _imageMap = {
      "Clear": "graphics/sun.png",
      "Clouds": "graphics/cloud.png",
      "Thunderstorm": "graphics/rain.png",
      "Drizzle": "graphics/drizzle.png",
      "Rain": "graphics/rain.png",
      "Snow": "graphics/snow.png",
      "Fog": "graphics/fog.png",
      "Mist": "graphics/fog.png",
      "Haze": "graphics/fog.png",
      "Smoke": "graphics/fog.png",
    };

    final _imagePath = _imageMap[weatherMain] ?? 'graphics/default.png';
    return Image(image: AssetImage(_imagePath));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: futureWeatherForecasts,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.data == null ||
              asyncSnapshot.connectionState == ConnectionState.none) {
            print('project snapshot data is: ${asyncSnapshot.data}');
            return Container();
          }
          List<DailyForecast> myForecastList = asyncSnapshot.data!;
          return ListView.builder(
            itemCount: myForecastList.length,
            itemBuilder: (BuildContext context, int position) {
              return Card(
                child: weatherTile(myForecastList[position]),
              );
            },
          );
        }
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}