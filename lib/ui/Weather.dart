import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/material.dart';
import '../util/utills.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';




  class Weather extends StatefulWidget {
    @override
    _WeatherState createState() => _WeatherState();
  }

  class _WeatherState extends State<Weather> {

    String _cityEntered;

    Future _goToNextScreen(BuildContext context) async {

      Map result = await Navigator.of(context).push(
        MaterialPageRoute<Map>(builder: (BuildContext context){

          return new ChangeCity();

        })
      );

      if(result != null){
        _cityEntered = result['enter'];
      }

    }

//
//    void showStuff() async{
//
//     Map data =  await getWeather(util.apiId, util.defaultCity);
//     print(data.toString());
//     print("checking");
//    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(

        appBar: AppBar(title: Text("Weather"),backgroundColor: Colors.blue,
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){

              _goToNextScreen(context);
            },
          )

        ],
        ),

        body: Stack(
          children: <Widget>[

            Center(
              child: Image.asset("images/umbrella.png",
                width: 490,
                height: 1200,
                fit: BoxFit.fill,
              ),
            ),

            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.fromLTRB(0.0,10.9,20.9,0.0),
              child: Text("${_cityEntered == null ? util.defaultCity : _cityEntered }",

                style: cityStyle(),
              ),
            ),

            Container(

              alignment: Alignment.center,
              child: Image.asset("images/light_rain.png"),

            ),

            Container(
              margin: EdgeInsets.fromLTRB(125.0,398.5,66.0,34.0),
              alignment: Alignment.center,
              child: updateTempWidget(_cityEntered)
            )

          ],
        ),

      );
    }




    }


    Widget updateTempWidget(String city){

      return FutureBuilder(
        future: getWeather(util.apiId, city == null ? util.defaultCity : city),

        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){

          if(snapshot.hasData){

            Map content = snapshot.data;

            return Container(
              margin: EdgeInsets.fromLTRB( 4,40, 4, 4),

              child: ListView(

                children: <Widget>[
                  Column(
                  children: <Widget>[

                     ListTile(

                      title: Text(content["main"]['temp'].toString() + "C",
                      style: TextStyle(color: Colors.white,
                      fontSize: 45.0),
                      ),
                       subtitle: Text("Humidity : ${content['main']['humidity'].toString()}F \n"
                         "Mini : ${content["main"]["temp_min"].toString()} C \n"
                         "Max : ${content["main"]["temp_max"].toString()} C",
                       style: TextStyle(color: Colors.white54,
                       fontSize: 20),
                       ),
                    )

                  ],
                )
          ],
              ),
            );

          }else{

            return Container();
          }


        }
      );

    }





    class ChangeCity extends StatefulWidget {

  @override
  _ChangeCityState createState() => _ChangeCityState();
}

class _ChangeCityState extends State<ChangeCity> {
      var _cityFieldController = new TextEditingController();

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text("Weather"),backgroundColor: Colors.red),

          body: Stack(

            children: <Widget>[
              Center(

                child: Image.asset('images/white_snow.png',
                width: 490.0,height: 1200.0,
                  fit: BoxFit.fill,
                ),
              ),

              ListView(
                children: <Widget>[
                  ListTile(
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter City Name'
                      ),
                      controller: _cityFieldController,
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  ListTile(
                    title: FlatButton(
                      onPressed: (){

                        Navigator.pop(context,{
                          'enter': _cityFieldController.text
                        });

                      } ,
                      textColor: Colors.white30,
                      color: Colors.red,
                      child: Text("Get Weather"),
                    ),
                  )

                ],
              )

            ],

          ),



        );
      }
}




  cityStyle() {

      return TextStyle(
        color: Colors.white,
        fontSize: 22.9,
        fontStyle: FontStyle.italic

      );

  }

  TextStyle tempStyle(){

      return TextStyle(
        color:  Colors.white,
        fontSize: 49.9,
        fontWeight: FontWeight.w500
      );

  }


Future<Map> getWeather(String appId,String city) async {
  String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid='
      '${util.apiId}&units=metric';

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);

}



