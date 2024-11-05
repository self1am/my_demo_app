import 'dart:convert';
import 'package:http/http.dart' as http;

class Country {
  final String name;
  
  Country({required this.name});
  
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] as String,
    );
  }
}

class CountryService {
  static const String _baseUrl = 'https://restcountries.com/v3.1';

  Future<List<Country>> getCountries() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/all?fields=name'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final countries = data
            .map((json) => Country.fromJson(json))
            .toList()
            ..sort((a, b) => a.name.compareTo(b.name));
        return countries;
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      throw Exception('Failed to fetch countries: $e');
    }
  }
}