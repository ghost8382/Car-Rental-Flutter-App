import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:licencjat/Components/Drawer.dart'; // Import Drawer

// Klasa do wyświetlania pojedynczej promocji
class PromotionCard extends StatelessWidget {
  final String title;
  final String description;

  const PromotionCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Klasa do sekcji promocji
class PromotionsSection extends StatelessWidget {
  final FirebaseFirestore firestore;

  const PromotionsSection({super.key, required this.firestore});

  Future<List<Map<String, dynamic>>> fetchPromotions() async {
    final snapshot = await firestore.collection('promotions').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchPromotions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final promotions = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: promotions.map((promotion) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PromotionCard(
                title: promotion['title'],
                description: promotion['description'],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// Klasa do wyświetlania nadchodzącego modelu samochodu
class UpcomingModelCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;

  const UpcomingModelCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Image.asset(imageUrl, height: 150, width: 200, fit: BoxFit.cover), // Stała szerokość dla zdjęć
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Klasa do sekcji nadchodzących modeli samochodów
class UpcomingModelsSection extends StatelessWidget {
  final FirebaseFirestore firestore;

  const UpcomingModelsSection({super.key, required this.firestore});

  Future<List<Map<String, dynamic>>> fetchUpcomingModels() async {
    final snapshot = await firestore.collection('upcoming_models').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchUpcomingModels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final models = snapshot.data!;
        return SizedBox(
          height: 250, // Stała wysokość dla sekcji
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Przewijanie w poziomie
            itemCount: models.length,
            itemBuilder: (context, index) {
              final model = models[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16), // Odstęp między kartami
                child: UpcomingModelCard(
                  name: model['name'],
                  description: model['description'],
                  imageUrl: model['image_url'],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Główna strona aplikacji
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        backgroundColor: isDarkMode ? Colors.red : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      drawer: myDrawer(), // Twój Drawer
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isDarkMode ? "assets/background2.jpg" : "assets/background3.jpg"),
            fit: BoxFit.cover,
            colorFilter: isDarkMode
                ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                : null,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to the Luxury Car Rental!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Check out the available luxury cars for rent!',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Current Promotions:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                PromotionsSection(firestore: firestore),
                const SizedBox(height: 30),
                Text(
                  'Coming Soon - Upcoming Models:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                UpcomingModelsSection(firestore: firestore), // Sekcja z poziomym przewijaniem
              ],
            ),
          ),
        ),
      ),
    );
  }
}
