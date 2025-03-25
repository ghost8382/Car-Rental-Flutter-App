import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:licencjat/pages/HomePage.dart';
import 'package:licencjat/services/FireBaseData/firestore.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedCar;
  double? calculatedPrice;
  double? deposit;
  bool isTermsAccepted = false;
  List<Map<String, dynamic>> cars = [];
  List<DateTime> reservedDates = [];

  Future<void> fetchCars() async {
    try {
      final CollectionReference carsCollection = FirebaseFirestore.instance.collection('cars');
      final querySnapshot = await carsCollection.get();
      final carList = querySnapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'image': doc['image'],
          'pricePerDay': doc['pricePerDay'],
          'deposit': doc['deposit'],
        };
      }).toList();

      setState(() {
        cars = carList;
      });
    } catch (e) {
      print('Error fetching cars: $e');
    }
  }

  Future<List<DateTime>> fetchReservedDates(String carName) async {
    List<DateTime> reservedDates = [];
    try {
      final CollectionReference reservationsCollection = FirebaseFirestore.instance.collection('reservations');
      final querySnapshot = await reservationsCollection.where('carName', isEqualTo: carName).get();
      for (var doc in querySnapshot.docs) {
        DateTime start = (doc['startDate'] as Timestamp).toDate();
        DateTime end = (doc['endDate'] as Timestamp).toDate();
        for (DateTime date = start; date.isBefore(end.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
          reservedDates.add(DateTime(date.year, date.month, date.day)); // Strip time component
        }
      }
    } catch (e) {
      print('Error fetching reserved dates: $e');
    }
    return reservedDates;
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime initialDate, DateTime firstDate, List<DateTime> reservedDates) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      selectableDayPredicate: (DateTime date) {
        final dateWithoutTime = DateTime(date.year, date.month, date.day);
        return !reservedDates.any((reservedDate) =>
        reservedDate.year == dateWithoutTime.year &&
            reservedDate.month == dateWithoutTime.month &&
            reservedDate.day == dateWithoutTime.day
        );
      },
    );
  }

  void calculatePrice() {
    if (startDate != null && endDate != null && selectedCar != null) {
      final int days = endDate!.difference(startDate!).inDays + 1;
      final car = cars.firstWhere((car) => car['name'] == selectedCar);
      setState(() {
        calculatedPrice = (days * car['pricePerDay']).toDouble();
        deposit = car['deposit'].toDouble();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Reservation'),
        backgroundColor: isDarkMode ? Colors.red : Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white,
          image: DecorationImage(
            image: AssetImage(isDarkMode ? "assets/background2.jpg" : "assets/background3.jpg"),
            fit: BoxFit.cover,
            colorFilter: isDarkMode
                ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                : null,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'Select a Car:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCar,
                items: cars.map((car) {
                  return DropdownMenuItem<String>(
                    value: car['name'],
                    child: Text(car['name'], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                  );
                }).toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedCar = value;
                    startDate = null;
                    endDate = null;
                    calculatedPrice = null;
                    deposit = null;
                  });

                  if (value != null) {
                    reservedDates = await fetchReservedDates(value);

                    DateTime now = DateTime.now();
                    DateTime firstAvailable = DateTime(now.year, now.month, now.day); // Strip time component
                    while (reservedDates.any((reservedDate) =>
                    reservedDate.year == firstAvailable.year &&
                        reservedDate.month == firstAvailable.month &&
                        reservedDate.day == firstAvailable.day
                    )) {
                      firstAvailable = firstAvailable.add(Duration(days: 1));
                    }

                    setState(() {
                      startDate = firstAvailable;
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  hintText: 'Choose a car',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Start Date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await _selectDate(context, startDate ?? DateTime.now(), DateTime.now(), reservedDates);
                  if (pickedDate != null) {
                    setState(() {
                      startDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day); // Strip time component
                      calculatePrice();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.red : Colors.blueAccent,
                  foregroundColor: Colors.black,
                ),
                child: Text(
                  startDate != null
                      ? DateFormat('yyyy-MM-dd').format(startDate!)
                      : 'Select Start Date',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select End Date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await _selectDate(context, startDate ?? DateTime.now(), startDate ?? DateTime.now(), reservedDates);
                  if (pickedDate != null) {
                    setState(() {
                      endDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day); // Strip time component
                      calculatePrice();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.red : Colors.blueAccent,
                  foregroundColor: Colors.black,
                ),
                child: Text(
                  endDate != null
                      ? DateFormat('yyyy-MM-dd').format(endDate!)
                      : 'Select End Date',
                ),
              ),
              const SizedBox(height: 20),
              if (calculatedPrice != null)
                Text(
                  'Total Price: \$${calculatedPrice!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              const SizedBox(height: 10),
              if (deposit != null)
                Text(
                  'Deposit: \$${deposit!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Checkbox(
                    value: isTermsAccepted,
                    activeColor: Colors.blue,
                    onChanged: (bool? value) {
                      setState(() {
                        isTermsAccepted = value ?? false;
                      });
                    },
                  ),
                  Text(
                    'I accept the terms and conditions',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (selectedCar != null && startDate != null && endDate != null && isTermsAccepted) {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You need to log in first")));
                      return;
                    }
                    String userId = user.uid;
                    final firestoreService = FirestoreService();
                    await firestoreService.saveReservationToDatabase(
                      userId,
                      selectedCar!,
                      startDate!,
                      endDate!,
                      calculatedPrice!,
                      deposit!,
                    );

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage())
                    );

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Reservation saved!")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please complete the reservation form")));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.red : Colors.blueAccent,
                  foregroundColor: Colors.black,
                ),
                child: Text('Reserve Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
