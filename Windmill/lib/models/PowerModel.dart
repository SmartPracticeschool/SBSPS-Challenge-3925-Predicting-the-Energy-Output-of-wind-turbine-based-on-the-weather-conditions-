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