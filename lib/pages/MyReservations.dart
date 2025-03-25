import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:licencjat/services/FireBaseData/firestore.dart';
import 'package:intl/intl.dart';

class MyReservationsPage extends StatefulWidget {
  @override
  _MyReservationsPageState createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> reservations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final List<Map<String, dynamic>> fetchedReservations =
        await _firestoreService.getReservationsByUser(user.uid);
        setState(() {
          reservations = fetchedReservations;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You need to log in to view your reservations.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching reservations: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _cancelReservation(String reservationId) async {
    try {
      await _firestoreService.cancelReservation(reservationId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reservation canceled successfully!")),
      );
      fetchReservations(); // Refresh the reservation list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error canceling reservation: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reservations'),
        backgroundColor: isDarkMode ? Colors.redAccent : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isDarkMode
                ? "assets/background2.jpg" // Dark background
                : "assets/background3.jpg"), // Light background
            fit: BoxFit.cover,
            colorFilter: isDarkMode
                ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                : null,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : reservations.isEmpty
            ? Center(
          child: Text(
            'You have no reservations yet.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        )
            : ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.car_rental,
                  size: 40,
                  color: isDarkMode ? Colors.white : Colors.blueAccent,
                ),
                title: Expanded( // Zastosowanie Expanded w tytule
                  child: Text(
                    reservation['carName'] ?? 'No car name available', // Domyślna wartość
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    softWrap: false, // Wymusza, by tekst nie zawijał się
                    overflow: TextOverflow.visible, // Zapewnia, że nie będzie kropek
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date: ${DateFormat('yyyy-MM-dd').format(reservation['startDate'])}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Text(
                      'End Date: ${DateFormat('yyyy-MM-dd').format(reservation['endDate'])}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Text(
                      'Price: \$${reservation['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Text(
                      'Deposit: \$${reservation['deposit'].toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min, // Minimalna szerokość
                  children: [
                    Text(
                      'Cancel Reservation',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5), // Odstęp między napisem a ikoną
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () => _cancelReservation(reservation['reservationId']),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
