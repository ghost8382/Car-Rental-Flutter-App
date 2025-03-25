import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kolekcja rezerwacji
  CollectionReference get reservations => _firestore.collection('reservations');

  // Zapisanie rezerwacji do bazy danych
  Future<void> saveReservationToDatabase(
      String userId,
      String carName,
      DateTime startDate,
      DateTime endDate,
      double price,
      double deposit,
      ) async {
    try {
      // Tworzenie dokumentu w kolekcji 'reservations'
      DocumentReference docRef = await reservations.add({
        'userId': userId, // Identyfikator użytkownika
        'carName': carName,
        'startDate': startDate,
        'endDate': endDate,
        'price': price,
        'deposit': deposit,
        'createdAt': Timestamp.now(),
      });

      // Dodanie reservationId do dokumentu
      await docRef.update({'reservationId': docRef.id});

      print('Reservation saved successfully!');
    } catch (e) {
      print('Error saving reservation: $e');
    }
  }

  // Pobieranie rezerwacji danego użytkownika
  Future<List<Map<String, dynamic>>> getReservationsByUser(String userId) async {
    try {
      QuerySnapshot snapshot = await reservations
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      List<Map<String, dynamic>> reservationsList = snapshot.docs.map((doc) {
        return {
          'reservationId': doc.id, // Dodanie reservationId
          'carName': doc['carName'],
          'startDate': (doc['startDate'] as Timestamp).toDate(),
          'endDate': (doc['endDate'] as Timestamp).toDate(),
          'price': doc['price'],
          'deposit': doc['deposit'],
        };
      }).toList();

      return reservationsList;
    } catch (e) {
      print('Error fetching reservations: $e');
      return [];
    }
  }

  // Anulowanie rezerwacji
  Future<void> cancelReservation(String reservationId) async {
    try {
      await reservations.doc(reservationId).delete();
      print('Reservation canceled successfully!');
    } catch (e) {
      print('Error canceling reservation: $e');
      throw e; // Rzucanie wyjątku, aby obsłużyć błąd w UI
    }
  }
}