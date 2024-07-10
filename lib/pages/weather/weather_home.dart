import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mc/pages/weather/services.dart';
import 'package:mc/pages/weather/weather_model.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({Key? key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherData weatherInfo;
  bool isLoading = false;

  myWeather() {
    isLoading = false;
    WeatherServices().fetchWeather().then((value) {
      setState(() {
        weatherInfo = value;
        isLoading = true;
      });
    });
  }

  @override
  void initState() {
    weatherInfo = WeatherData(
      name: '',
      temperature: Temperature(current: 0.0),
      humidity: 0,
      wind: Wind(speed: 0.0),
      maxTemperature: 0,
      minTemperature: 0,
      pressure: 0,
      seaLevel: 0,
      weather: [],
    );
    myWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE d, MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather Now',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: const Color(0xFF676BD0),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: isLoading
                  ? WeatherDetail(
                      weather: weatherInfo,
                      formattedDate: formattedDate,
                      formattedTime: formattedTime,
                    )
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;
  const WeatherDetail({
    Key? key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.name,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "${weather.temperature.current.toStringAsFixed(2)}°C",
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (weather.weather.isNotEmpty)
          Text(
            weather.weather[0].main,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 30),
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/cloudy.png"),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.air,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Wind", value: "${weather.wind.speed}km/h"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.sunny,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Max",
                            value:
                                "${weather.maxTemperature.toStringAsFixed(2)}°C"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.air,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Min",
                            value:
                                "${weather.minTemperature.toStringAsFixed(2)}°C"),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Humidity", value: "${weather.humidity}%"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.air,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Pressure", value: "${weather.pressure}hPa"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.leaderboard,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Sea-Level", value: "${weather.seaLevel}m"),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column weatherInfoCard({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
