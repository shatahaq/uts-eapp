import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'my_tickets_screen.dart';
import 'queue_screen.dart';
import 'profile_screen.dart';

/// Kerangka utama wisatawan: 4 tab di bawah.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: tabIndex,
      builder: (context, i, _) => Scaffold(
        body: IndexedStack(index: i, children: const [
          HomeScreen(),
          MyTicketsScreen(),
          QueueScreen(),
          ProfileScreen(),
        ]),
        bottomNavigationBar: DecoratedBox(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: C.divider))),
          child: NavigationBar(
            selectedIndex: i,
            onDestinationSelected: (v) => tabIndex.value = v,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore_rounded),
                  label: 'Jelajahi'),
              NavigationDestination(
                  icon: Icon(Icons.confirmation_number_outlined),
                  selectedIcon: Icon(Icons.confirmation_number_rounded),
                  label: 'Tiket Saya'),
              NavigationDestination(
                  icon: Icon(Icons.hourglass_empty_rounded),
                  selectedIcon: Icon(Icons.hourglass_full_rounded),
                  label: 'Antrean'),
              NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }
}
