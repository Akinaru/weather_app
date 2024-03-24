class Weather {
  Weather({
    required this.condition,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.wind,
  });

  final String condition;
  final String description;
  final String icon;
  final double temperature;
  final double wind;

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      condition: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      wind: (json['wind']['speed'] as num).toDouble(),
    );
  }
}
