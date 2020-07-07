import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// PowerModel class to store the values in its objects that will come from back-end
class PowerModel {
  double power;
  String date;
  String time;
  String windSpeed;
  String temperature;
  String humidity;
  String pressure;

  PowerModel(
      {this.power,
      this.date,
      this.time,
      this.windSpeed,
      this.temperature,
      this.humidity,
      this.pressure});

  // this method will convert the json data to PowerModel object
  factory PowerModel.fromJson(Map<String, dynamic> json) {
    return PowerModel(
        power: json['power'],
        date: json['date'],
        time: json['time'],
        windSpeed: json['wind_speed'],
        temperature: json['temperature'],
        humidity: json['humidity'],
        pressure: json['pressure']);
  }
}

// ResultScreen class with latitude and longitudes as parameters which are passed from previous screen
class ResultScreen extends StatefulWidget {
  final String latitude;
  final String longitude;
  ResultScreen({this.latitude, this.longitude});

  @override
  _ResultScreenState createState() =>
      _ResultScreenState(latitude: latitude, longitude: longitude);
}

class _ResultScreenState extends State<ResultScreen> {
  final String latitude;
  final String longitude;
  _ResultScreenState({this.latitude, this.longitude});

  List<PowerModel> powerList;   // This list will store jsonOutput in PowerModel's object form 
  List<int> indexList;          // This will store all the indexes of above list which are included in highest power. Its length will be equal to hours variable
  int hours = 1;                // Currently set number of hours
  int prevHours = 0;            // Just previous value of hours before updating
  double bestPower = 0;         // bestPower is the average of all the powers at index present in indexList

  getBest() {
    // function to find the best intervals in which power is maximum
    if (prevHours < hours) {
      // if number of operational hours is increased then add one more interval in the list
      double maxPower = -0.1;
      int maxIndex = -1;
      for (int i = 0; i < powerList.length; i++) {
        if (powerList[i].power > maxPower && !indexList.contains(i)) {
          maxPower = powerList[i].power;
          maxIndex = i;
        }
      }
      bestPower += maxPower;
      indexList.add(maxIndex);
    } else {
      // if number of operational hours is decreased then removed the last input index and its power because last entering index is obviously smallest
      bestPower -= powerList[indexList[indexList.length - 1]].power;
      indexList.removeLast();
    }
    prevHours = hours;
    setState(() {
      // setting states
      indexList = indexList;
      bestPower = bestPower;
    });
  }

  bool _notLoaded = true;
  // This variable keeps app in loading state till data from server doesn't arrive

  // The main function which is the link between front-end and back-end
  dynamic getPredictions() async {
    String uri =
        "https://windmill-harsh.herokuapp.com/predict?latitude=$latitude&longitude=$longitude";
    // Link to the server, it will receive predicted power data as well as weather connection

    var response = await http.get(uri);   // Storing reponse in a variable of type http.Response
    if (response != null) {
      // For error handling in case no data comes due to absence of internet connection or any other reason
      var list = json.decode(response.body) as List;
      //Storing the json data in a Dart list
      powerList = list.map((json) => PowerModel.fromJson(json)).toList();
      // Converting list into list of PowerModel objects
      setState(() {
        // Setting the notLoaded state false so that app can show results
        _notLoaded = false;
      });
      // For getting the first best power output in any intervl of length 1 hour
      getBest();
    } else {
      // In case no response comes, go back to previous screen
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    indexList = [];
    getPredictions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.black,
        // When not loaded, loading() function will run else loaded() will run
        body: _notLoaded ? loading() : loaded());
  }

  loading() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SpinKitWave(
                color: Colors.blue,
                size: 100.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 100.0, left: 10.0, right: 10.0),
            child: Text(
              "This may take some time...",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  loaded() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/windmill.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.80)),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.1),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    border: Border.all(color: Colors.lightBlue, width: 0.3),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.0, top: 12.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 3.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Best Power Generated',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                // Best generated power
                                Text(
                                  "Power : " +
                                      (bestPower / hours).toStringAsFixed(4) +
                                      " kW",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 1.0,
                                ),
                                Text(
                                  "Latitude : " +
                                      double.tryParse(latitude)
                                          .abs()
                                          .toStringAsFixed(4) +
                                      "º" +
                                      (double.tryParse(latitude) > 0
                                          ? " N"
                                          : " S"),
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 15.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 1.0,
                                ),
                                Text(
                                  "Longitude : " +
                                      double.tryParse(longitude)
                                          .abs()
                                          .toStringAsFixed(4) +
                                      "º" +
                                      (double.tryParse(longitude) > 0
                                          ? " E"
                                          : " W"),
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100.0,
                        child: Center(
                          child: Column(
                            // This column will increase/decrease number of hours
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                // This will decrease the number of hours
                                icon: Icon(Icons.arrow_drop_up),
                                color: Colors.lightBlue,
                                iconSize: 50.0,
                                onPressed: () {
                                  if (hours > 1) {
                                    setState(() {
                                      hours = hours - 1;
                                      getBest();
                                    });
                                  }
                                },
                              ),
                              Container(
                                height: 15.0,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                                child: Text(
                                  // It will display number of hours currently considered
                                  'hours : ' + hours.toString(),
                                ),
                              ),
                              IconButton(
                                // It will increase number of hours
                                icon: Icon(Icons.arrow_drop_down),
                                color: Colors.lightBlue,
                                iconSize: 50.0,
                                onPressed: () {
                                  if (hours < 72) {
                                    setState(() {
                                      hours = hours + 1;
                                      getBest();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  // This list will display the next 72 hours prediction along with the weather data
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: powerList.length,
                  itemBuilder: (context, index) => Container(
                    height: 110.0,
                    margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 5.0),
                    decoration: BoxDecoration(
                      color: indexList.contains(index)
                          ? Colors.lightBlue.withOpacity(0.78)    
                          // Indexes included in indexList will be displayed blue i.e. these indexes are considered while evaluating bestPower 
                          : powerList[index].power == 0   
                              ? Colors.red.withOpacity(0.78)
                              // In case when power generation is zero cell color is red because operating windmill in this interval is worthless
                              : Colors.black.withOpacity(0.78),
                      border: Border.all(color: Colors.white30, width: 0.5),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.1),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: ListTile(
                              title: Text(
                                powerList[index].time +
                                    " - " +
                                    powerList[(index + 1) % powerList.length]
                                        .time,
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              subtitle: Text(
                                "Power : " +
                                    powerList[index].power.toString() +
                                    "kW",
                                style: TextStyle(
                                  fontSize: 22.0,
                                ),
                              ),
                              trailing: Text(
                                powerList[index].date,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Temperature : " +
                                         _FtoC(index) +
                                        " ºC",
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  "Wind Speed : " +
                                      double.tryParse(
                                              powerList[index].windSpeed)
                                          .toStringAsFixed(2) +
                                      " mph",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.white54,
                                  ),
                                ),
                              )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Humidity : " +
                                        double.tryParse(
                                                powerList[index].humidity)
                                            .toString() +
                                        "%",
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  "Pressure : " +
                                      double.tryParse(powerList[index].pressure)
                                          .toStringAsFixed(2) +
                                      " inHg",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.white54,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // For converting Fahrenheit to Celcius
  _FtoC(index){
    return (((double.tryParse(powerList[index].temperature) -32.0) *5.0) /9.0).toStringAsFixed(2);
  }
}
