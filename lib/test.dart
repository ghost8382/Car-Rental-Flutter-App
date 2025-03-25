import 'package:cloud_firestore/cloud_firestore.dart';

void addCarsToDatabase() async {
  CollectionReference cars = FirebaseFirestore.instance.collection('upcoming_models');

  await cars.add({
    "name": "VW Golf R",
    "description": "Sporty performance with AWD",
    "image_url": "assets/golf_r.jpg"
  });

  await cars.add({
    "name": "Honda Civic Type R",
    "description": "Reliability and performance",
    "image_url": "assets/civic_type_r.jpg"
  });

  print("Cars added successfully!");
}
