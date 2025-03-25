import 'package:flutter/material.dart';
import 'package:licencjat/Components/DrawerTile.dart';
import 'package:licencjat/pages/ContactPage.dart';
import 'package:licencjat/pages/MyReservations.dart';
import 'package:licencjat/services/authenthication/LoginOrRegister.dart';
import 'package:licencjat/pages/OurFleet.dart';

import 'package:licencjat/pages/Reservation.dart';
import 'package:licencjat/pages/Settings.dart';
import 'package:licencjat/pages/loginpage.dart';
import 'package:licencjat/services/authenthication/autoryzacja.dart';

class myDrawer extends StatelessWidget {
  const myDrawer({super.key});

  void logout(){
    final authorize = Authorize();
    authorize.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Ikona samochodu (car_rental) na górze
          Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.car_rental,
              size: 40,
              color: Theme.of(context).colorScheme.onSurface, // Kolor ikony zmienia się zgodnie z motywem
            ),
          ),
          // Separator
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary, // Kolor separatora
            ),
          ),
          // Lista pozycji w Drawer
          Mydrawertile(
            text: "News",
            icon: Icons.person,
            onTap: () => Navigator.pop(context),
          ),
          Mydrawertile(
            text: "Our fleet & Pricing",
            icon: Icons.car_rental_outlined,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FleetPage()),
              );},
          ),

          Mydrawertile(
            text: "Make a reservation",
            icon: Icons.calendar_month,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservationPage()),
              );
            },
          ),
          Mydrawertile(
            text: "My reservations",
            icon: Icons.calendar_today,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyReservationsPage()),
              );
              // Remove `onTap` here if it's not required
            },
          ),

          Mydrawertile(
            text: "Contact us",
            icon: Icons.contact_mail,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUsScreen()),
              );},
          ),
          Mydrawertile(
            text: "Settings",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          const Spacer(),
          Mydrawertile(
            text: "Logout",
            icon: Icons.logout,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginorSignUp()), // Remove `onTap` here if it's not required
              );
            },
          ),

        ],
      ),
    );
  }
}
