import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_api/constants/color.dart';
import 'package:weather_api/constants/icons.dart';
import 'package:weather_api/models/weather_api.dart';
import 'package:weather_api/screens/loading_screen.dart';
import 'package:weather_api/services/wather_services.dart';
import 'package:weather_api/widgets/forecast.dart';
import 'package:weather_api/widgets/header.dart';
import 'package:weather_api/widgets/info_card.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  
  WeatherService weatherService = WeatherService();
  Weather weather = Weather();

  String image = '';
  Color defaultColor = Colors.black;
  int hour = 0;
  bool isDay = false;
  bool isNight = false;
  String icon = '';

  Future getWeather() async {
    weather = await weatherService.getWeaterData();
    setState(() {
      getWeather();
      isLoading = false;
    });
  }

  void setDay() async {
    List datetime = weather.date.split(' ');
    var hour = datetime[1].split(':');
    var turnInt = int.parse(hour[0]);
    if (turnInt >= 10 || turnInt <= 5) {
      print(turnInt);
      setState(() {
        isDay = false;
        isNight = true;
        defaultColor = nightappcolor;
      });
    }
    if (turnInt > 5 && turnInt < 19) {
      setState(() {
        isNight = false;
        isDay = true;
        defaultColor = dayappcolor;
      });
    }
  }

  void day() {
    setState(() {
      defaultColor = dayappcolor;
    });
    if (weather.text == 'Partly Cloud') {
      setState(() {
        loadingIcon = partlyCloudDayIcon;
      });
      if (weather.text == 'Sunny') {
        setState(() {
          loadingIcon = sunnyIcon;
        });
        if (weather.text == 'Overcast') {
          setState(() {
            loadingIcon = overcastDayIcon;
          });
        }
      }
    }
  }

  void night() {
    setState(() {
      defaultColor = nightappcolor;
    });
    if (weather.text == 'Partly Cloud') {
      setState(() {
        loadingIcon = partlyCloudyIconNight;
      });
      if (weather.text == 'Clear') {
        setState(() {
          loadingIcon = clearNightIcon;
        });
      }
    }
  }

  void gethour() {
    List datetime = weather.date.split(' ');
    var hour = datetime[1].split(':');
    var turnInt = int.parse(hour[0]);
    setState(() {
      hour = turnInt;
    });
  }

  @override
  void initState() {
    getWeather();
    Timer.periodic(Duration(seconds: 2), (timer) {
      setDay();
    });
    Timer.periodic(Duration(seconds: 2), (timer) {
      isDay ? day() : night();
    });
    Timer.periodic(Duration(seconds: 3), (timer) {
      gethour();
    });
    Future.delayed(Duration(seconds: 2), () async {
      await weatherService.getWeaterData();
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(300),
              child: Header(
                backgroundColor: defaultColor,
                city_name: weather.city,
                discription: weather.text,
                discriptionIMG: loadingIcon,
                state_name: weather.state,
                temp: weather.temp,
              ),
            ),
            body: Container(
            decoration: BoxDecoration(
                gradient: isDay
                    ? LinearGradient(
                        begin: const Alignment(-1.5, 8),
                        end: const Alignment(-1.5, -0.5),
                        colors: [Colors.white, defaultColor])
                    : LinearGradient(
                        begin: const Alignment(-1.5, 8),
                        end: const Alignment(-1.5, -0.5),
                        colors: [Colors.white, defaultColor])),
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(0, 255, 255, 255),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: weather.forecast.length - hour - 1,
                      itemBuilder: (context, index) => SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 5),
                        child: Center(
                            child: ForecastCard(
                                hour: weather.forecast[hour + index]['time']
                                    .toString()
                                    .split(' ')[1],
                                averageTemp: weather.forecast[hour + index]
                                    ['temp_c'],
                                description: weather.forecast[hour + index]
                                    ['condition']['text'],
                                descriptionIMG: weather.forecast[hour + index]
                                        ['condition']['icon']
                                    .toString()
                                    .replaceAll('//', 'http://'),),),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: InformartionsCard(humidity: weather.humidity, uvIndex: weather.uvIndex, wind: weather.wind),)
              ],
            ),
          ),
          );
  }
}
