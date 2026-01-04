import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'beranda.dart'; // Pastikan nama file sesuai
import 'todolist.dart'; // File yang sudah kita perbaiki sebelumnya
import 'profil.dart'; // Pastikan nama file sesuai

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const BerandaPage(), // Sesuaikan dengan nama class di file beranda.dart
    const TodoListPage(),
    const ProfilPage(), // Sesuaikan dengan nama class di file profil.dart
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF8D6E63), // Warna background navbar (Coklat)
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF8D6E63), // Samakan dengan container
          elevation: 0,
          selectedItemColor: const Color(
            0xFFFFCA28,
          ), // Warna icon aktif (Kuning)
          unselectedItemColor: Colors.white60, // Warna icon tidak aktif
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30),
              activeIcon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt, size: 30),
              activeIcon: Icon(Icons.list_alt, size: 30),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 30),
              activeIcon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
