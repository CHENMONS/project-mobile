import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'car_model.dart';
import 'car_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sewa Mobil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CarListScreen(),
    );
  }
}

class CarListScreen extends StatefulWidget {
  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  List<Car> cars = [];
  final CarService carService = CarService();

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  // Fungsi untuk mengambil data mobil
  Future<void> fetchCars() async {
    final fetchedCars = await carService.getCars();
    setState(() {
      cars = fetchedCars;
    });
  }

  // Menampilkan dialog untuk menambah mobil
  void _showAddCarDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Car'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Car Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price per Day'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newCar = Car(
                  id: 0,
                  name: nameController.text,
                  description: descriptionController.text,
                  pricePerDay: int.parse(priceController.text),
                  status: 'available',
                );
                carService.addCar(newCar);
                Navigator.of(context).pop();
                fetchCars();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan dialog untuk mengedit mobil
  void _showEditCarDialog(Car car) {
    final nameController = TextEditingController(text: car.name);
    final descriptionController = TextEditingController(text: car.description);
    final priceController = TextEditingController(text: car.pricePerDay.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Car'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Car Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price per Day'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedCar = Car(
                  id: car.id,
                  name: nameController.text,
                  description: descriptionController.text,
                  pricePerDay: int.parse(priceController.text),
                  status: car.status,
                );
                carService.updateCar(updatedCar);
                Navigator.of(context).pop();
                fetchCars();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan dialog konfirmasi untuk menghapus mobil
  void _showDeleteCarDialog(Car car) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Car'),
          content: Text('Are you sure you want to delete this car?'),
          actions: [
            TextButton(
              onPressed: () {
                carService.deleteCar(car.id);
                Navigator.of(context).pop();
                fetchCars();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sewa Mobil'),
      ),
      body: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final car = cars[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(car.name),
              subtitle: Text('Price: \$${car.pricePerDay} per day'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditCarDialog(car),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _showDeleteCarDialog(car),
                  ),
                ],
              ),
              onTap: () {
                _showEditCarDialog(car);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCarDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
