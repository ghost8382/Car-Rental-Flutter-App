import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FleetPage extends StatefulWidget {
  const FleetPage({super.key});

  @override
  _FleetPageState createState() => _FleetPageState();
}

class _FleetPageState extends State<FleetPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = [
    'Premium',
    'Sport',
    'City',
    'Utility',
    'Classic',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Fleet'),
        backgroundColor: isDarkMode ? Colors.red : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: isDarkMode ? Colors.white : Colors.black,
          tabs: categories.map((category) {
            return Tab(
              child: Text(
                category,
                style: TextStyle(
                  color: _tabController.index == categories.indexOf(category)
                      ? (isDarkMode ? Colors.white : Colors.black) // Kolor aktywnej zakładki
                      : (isDarkMode ? Colors.white70 : Colors.black54), // Kolor nieaktywnej zakładki
                ),
              ),
            );
          }).toList(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isDarkMode
                ? "assets/background2.jpg"
                : "assets/background3.jpg"),
            fit: BoxFit.cover,
            colorFilter: isDarkMode
                ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                : null,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('cars').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final fleetData = snapshot.data?.docs.map((doc) {
              return {
                'name': doc['name'],
                'image': doc['image'] ?? '', // Zabezpieczenie przed null
                'description': doc['description'] ?? '', // Zabezpieczenie przed null
                'category': doc['category'] ?? '',
                'power': doc['power'] ?? '',
                'torque': doc['torque'] ?? '',
                'year': doc['year'] ?? '',
                'topSpeed': doc['topSpeed'] ?? '',
                // Rzutowanie pricePerDay na double, jeśli jest zapisane jako int
                'pricePerDay': (doc['pricePerDay'] is int) ? (doc['pricePerDay'] as int).toDouble() : doc['pricePerDay'],
              };
            }).toList() ?? [];

            return TabBarView(
              controller: _tabController,
              children: categories.map((category) {
                final filteredCars = fleetData
                    .where((car) => car['category'] == category)
                    .toList();

                return ListView.builder(
                  itemCount: filteredCars.length,
                  itemBuilder: (context, index) {
                    final car = filteredCars[index];
                    return _buildCarCard(context, car);
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, Map<String, dynamic> car) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarDetailsPage(car: car),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Car Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: Image.asset(
                car['image'], // Użycie lokalnego obrazu
                width: 150,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error); // Zabezpieczenie przed błędami ładowania obrazu
                },
              ),
            ),
            const SizedBox(width: 10),
            // Car Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car['name']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      car['description']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Price Per Day: \$${(car['pricePerDay'] as double).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarDetailsPage extends StatelessWidget {
  final Map<String, dynamic> car;

  const CarDetailsPage({required this.car, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(car['name']!),
        backgroundColor: isDarkMode ? Colors.red : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
      ),
      body: Stack(
        children: [
          // Tło
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isDarkMode
                    ? "assets/background2.jpg"
                    : "assets/background3.jpg"),
                fit: BoxFit.cover,
                colorFilter: isDarkMode
                    ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                    : null,
              ),
            ),
          ),
          // Zawartość strony
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Hero(
                    tag: car['name']!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          car['image'], // Użycie lokalnego obrazu
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: 500,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error); // Zabezpieczenie przed błędami ładowania obrazu
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    car['name']!,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    car['description']!,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(Icons.speed, 'Power: ${car['power']}'),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.engineering, 'Torque: ${car['torque']}'),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.calendar_today, 'Year: ${car['year']}'),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.speed, 'Top Speed: ${car['topSpeed']}'),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.attach_money, 'Price Per Day: \$${(car['pricePerDay'] as double).toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.red, size: 28),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
