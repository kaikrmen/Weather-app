import 'package:flutter/material.dart';
import 'package:weatherapp/screens/city_screen.dart';
import '../utilities/constants.dart';
import 'package:weatherapp/services/weather.dart';


class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weather = WeatherModel();

  int temperature = 0;
  String? weatherIcon;
  String? cityName;
  String? weatherMessage;

  void updateIU(dynamic weatherData) {

   setState(() {

     if (weatherData == null)
     {
       temperature = 0;
       weatherIcon = 'Error';
       weatherMessage = 'Unable to get weather data';
       cityName = '';
       return;
     }


     var condition=  weatherData['weather'][0]['id'];
     double temp =  weatherData['main']['temp'];
     temperature = temp.toInt();
     cityName =  weatherData['name'];
     print(cityName);
     weatherMessage = weather.getMessage(temperature);
     weatherIcon = weather.getWeatherIcon(condition);
   });
  }


  @override
  void initState(){
    super.initState();
    updateIU(widget.locationWeather);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: ()  async {
                      var weatherData = await weather.getLocationWeather();
                      print('hello');
                      updateIU(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {

                      var typedName =  await Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CityScreen();
                      }));
                      if(typedName != null) {
                        var weatherData = await weather.getCityWeather(typedName);
                        updateIU(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Text(
                '$weatherMessage in $cityName',
                textAlign: TextAlign.right,
                style: kMessageTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
