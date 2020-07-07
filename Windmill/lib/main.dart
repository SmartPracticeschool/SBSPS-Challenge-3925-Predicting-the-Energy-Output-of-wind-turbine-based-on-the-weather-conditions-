// Developed for Smart Internz IBM Hack Challenge 2020

// main.dart file is run by default by Flutter. All other files are then called from this file or are imported in this file

// import statement is used to import all the plugin and files which are used in this file.
import 'package:Windmill/results.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  // main() function is called by the compiler
  runApp(
      //runApp is the method called by main to start the execution of app
      MaterialApp(
    // Material app is the root widget of any Flutter app
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),    // Dark theme is used
    home: HomeScreen(),
  ));
}

// Main Home Screen of our app
class HomeScreen extends StatefulWidget {
  // StatefulWidget means this screen contains widget with which user can interact
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Subclass that reaturns State object
  TextEditingController _latController, _lonController;   // For controlling text of TextFormField
  GlobalKey<FormState> _formKey;    // key for the Form
  String latitude, longitude;       // global variables to store latitude and longitude values
  final _scaffoldKey = GlobalKey<ScaffoldState>();    // for creating snackbar on top of Scaffold

  void validateForm() {
    // function for validating the input of TextFormField
    if (double.tryParse(_latController.text) != null &&     // Check whether input is double value or not
        double.parse(_lonController.text) != null) {
      if (_formKey.currentState.validate()) {               // if no error has been returned from input field then form is validated
        latitude = double.parse(_latController.text).toStringAsFixed(4);
        longitude = double.parse(_lonController.text).toStringAsFixed(4);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(   // Navigating to ResultScreen with latitude and longitude as parameters
              latitude: latitude,
              longitude: longitude,
            ),
          ),
        );
      }
    } else {      // Error handling in case when input is not in decimal or integer format
      _scaffoldKey.currentState.showSnackBar(SnackBar(    // Creating SnackBar on top of Scaffold using its key
        content: Text(
          "Invalid coordinate point entered... Use only XX.XX format number",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 15.0,
          ),
        ),
        backgroundColor: Colors.black38.withOpacity(0.3),
      ));
    }
  }

  @override
  void initState() { 
    // initState is run first and only for one time in a State during the app Cycle
    super.initState();
    _latController = TextEditingController();
    _lonController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    // every Widget in Flutter is made from build method
    // Every build method takes BUildContext as an argument which describes where you are in tree of widgets
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/windmill.jpg"),
            // Backgrounds Designed By 30000003675 From "https://lovepik.com/image-400235291/windmill-cell-phone-wallpaper.html" LovePik.com
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.75)),
          // Designed the background of screen in above Widgets

          // Now the foreground is designed below
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 100.0),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: Form(
                  key: _formKey,      // the global key of FormState is assigned to form here
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 45.0, left: 30.0, right: 30.0, top: 30.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Coordinates',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 45.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            border:
                                Border.all(color: Colors.white70, width: 0.5),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: TextFormField(
                            // this TextFormField will take latitude as input
                            validator: (value) {
                              // validations on input value for error handling
                              if (value.isEmpty) {
                                return "Please enter some value";
                              } else if (double.tryParse(value) > 90 ||
                                  double.parse(value) < -90) {
                                return "Not in range (Range : -90 to 90)";
                              }
                              return null;
                            },
                            controller: _latController, 
                            // assigning the globally declared textEditingController to this TextFormField
                            decoration: InputDecoration(
                              hintText: 'Enter Latitude',
                              hintStyle: TextStyle(
                                color: Colors.white38,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 30.0),
                            ),
                            keyboardType: TextInputType.number,
                            // Allowing only Number Keyboard to appear to avoid maximum ambiguities 
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            border:
                                Border.all(color: Colors.white70, width: 0.5),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: TextFormField(
                            // this TextFormField will take longitude as input
                            validator: (value) {
                              // Validator on input values for error handling
                              if (value.isEmpty) {
                                return "Please enter some value";
                              } else if (double.tryParse(value) == null) {
                                return "Please enter a valid coordinate";
                              } else if (double.parse(value) > 180 ||
                                  double.parse(value) < -180) {
                                return "Not in range (Range : -180 to 180)";
                              }
                              return null;
                            },
                            controller: _lonController,
                            // assigning the globally declared textEditingController to this TextFormField
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 30.0),
                              border: InputBorder.none,
                              hintText: 'Enter Longitude',
                              hintStyle: TextStyle(
                                color: Colors.white38,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            // Allowing only Number Keyboard to appear to avoid maximum ambiguities
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              // Gesture Detector will let the below Text Widget to listen to clicks
                              onTap: _findLocation,   // function to get our current location
                              child: Text(
                                // clickable text widget
                                'Use my location instead?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RaisedButton(
                                // Button to submit the form
                                onPressed: () {
                                  validateForm();
                                  // This function will check whether there was error in form and if not will push the values to next screen
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _latController.text = "";
                                    _lonController.text = "";
                                  });
                                },
                                color: Colors.white.withOpacity(0.25),
                                disabledColor: Colors.white.withOpacity(0.25),
                                disabledElevation: 5.0,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Center(
                                    child: Text(
                                      'Search for these coordinates',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Expanded(
                              child: RaisedButton(
                                // This button will open a new screen with a search bar where 
                                // you can search for cities from a database of 13k cities
                                onPressed: () {
                                  showSearch(
                                    context: context, delegate: CitySearch()
                                    // Class which will form new screen with search bar
                                  );
                                },
                                color: Colors.white.withOpacity(0.25),
                                disabledColor: Colors.white.withOpacity(0.25),
                                disabledElevation: 5.0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Center(
                                    child: Text(
                                      'Search for some city',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _findLocation() {
    // The function which will access your location and push your live coordinates to next screen
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      Navigator.push(
        // Naigating to next screen with latitude and longitude as parameters
          context,
          MaterialPageRoute(
              builder: (_) => ResultScreen(
                    latitude: latitude,
                    longitude: longitude,
                  )));
    }).catchError((e) {
      // Error Handling in case when permission is not given
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Go to Setting of your phone and provide location permission to this app",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 15.0,
          ),
        ),
        backgroundColor: Colors.black38.withOpacity(0.3),
      ));
    });
  }
}


// City class to store objects of city containing name and its coordinates
class City {
  String lats, longs, name;
  City({@required this.name, @required this.lats, @required this.longs});
}

City selectedCity;
List<City> city;

// It will create new screen with search bar
class CitySearch extends SearchDelegate<String> {
  
  // Constructor for loading cities data from  csv file to Cities object
  CitySearch() {
    city = List<City>();
    loadCityData();
    // the function which do the loading
  }

  loadCityData() async {
    final data = await rootBundle.loadString('assets/cities.csv');
    List<String> rowList = LineSplitter().convert(data);
    for (var myRow in rowList) {
      List<String> row = myRow.split(',');
      city.add(City(
          name: row[0].toString().toLowerCase(), lats: row[1], longs: row[2]));
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).buttonColor,
        ),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        color: Theme.of(context).buttonColor,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // this Widget will build suggestion on eack keystroke
    List<City> suggestionList;    
    // this list will contain the suggestions
    if (query.isEmpty) {
      return ListView(
        children: <Widget>[
          ListTile(
            title: Center(
              child: Text("You haven't entered anything..."),
            ),
          ),
        ],
      );
    } else {
      suggestionList = city.where((p) => p.name.startsWith(query)).toList();
      // suggestionList containing list of cities starting with the input query

      return ListView.builder(
        // This Widget will build the List
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 0.5),
          child: Card(
            elevation: 5.0,
            color: Colors.black12.withOpacity(0.6),
            shadowColor: Colors.black87,
            shape: RoundedRectangleBorder(),
            child: ListTile(
              onTap: () {
                selectedCity = suggestionList[index];
                openResultScreen(context);
                // This function pushes the coordinates of selected city on next screen
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
              title: RichText(
                text: TextSpan(
                  text: suggestionList[index].name.substring(0, query.length),
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                        text: suggestionList[index].name.substring(query.length),
                        style: TextStyle(color: Theme.of(context).cursorColor)),
                  ],
                ),
              ),
              subtitle: Text(
                suggestionList[index].name,
                style: TextStyle(
                  color: Theme.of(context).backgroundColor,
                ),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.add_location,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: null),
            ),
          ),
        ),
        itemCount: suggestionList.length,
      );
    }
  }

  static openResultScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          latitude: selectedCity.lats,
          longitude: selectedCity.longs,
        ),
      ),
    );
  }
}
