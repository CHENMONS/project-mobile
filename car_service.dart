import 'dart:convert';
import 'package:http/http.dart' as http;
import 'car_model.dart';

class CarService {
  static const String baseUrl = 'http://192.168.56.1/API/sewa.php'; // Ganti dengan URL API Anda

  // Fungsi untuk mengambil semua mobil
  Future<List<Car>> getCars() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Car> cars = [];
      for (var item in data['data']) {
        cars.add(Car.fromJson(item));
      }
      return cars;
    } else {
      throw Exception('Failed to load cars');
    }
  }

  // Fungsi untuk menambah mobil
  Future<void> addCar(Car car) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(car.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add car');
    }
  }

  // Fungsi untuk memperbarui mobil
  Future<void> updateCar(Car car) async {
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(car.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update car');
    }
  }

  // Fungsi untuk menghapus mobil
  Future<void> deleteCar(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl?id=$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete car');
    }
  }
}
