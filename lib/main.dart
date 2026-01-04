import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'beranda.dart';
import 'dashboard.dart'; // Pastikan file dashboard.dart (MainDashboard) sudah ada

// ==========================================
// 1. DATA MODEL & PROVIDER (State Management)
// ==========================================

class Task {
  String id;
  String title;
  String date;
  String description;
  String category; // Field Baru: Kategori
  bool isCompleted; // Field Baru: Status Selesai

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    this.category = 'Personal', // Default kategori
    this.isCompleted = false, // Default belum selesai
  });
}

class TaskProvider with ChangeNotifier {
  // Dummy Data Awal
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Meeting Client',
      date: '2023-10-24',
      description: 'Diskusi projek A di Cafe',
      category: 'Work',
    ),
    Task(
      id: '2',
      title: 'Beli Sayur',
      date: '2023-10-25',
      description: 'Wortel, Bayam, Tempe',
      category: 'Personal',
    ),
    Task(
      id: '3',
      title: 'Bayar Listrik',
      date: '2023-10-26',
      description: 'Sebelum tanggal 20!',
      category: 'Urgent',
      isCompleted: true, // Contoh yang sudah selesai
    ),
  ];

  List<Task> get tasks => _tasks;

  // Menambah Task Baru
  void addTask({
    required String title,
    required String description,
    required String date,
    required String category,
  }) {
    _tasks.add(
      Task(
        id: DateTime.now().toString(), // Generate ID unik sederhana
        title: title,
        date: date,
        description: description,
        category: category,
      ),
    );
    notifyListeners();
  }

  // Edit Task (Opsional, untuk pengembangan selanjutnya)
  void editTask(String id, Task newTask) {
    int index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = newTask;
      notifyListeners();
    }
  }

  // Toggle Status Selesai/Belum (Untuk Checkbox)
  void toggleTask(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
  }

  // Hapus Task (Untuk fitur Swipe-to-delete)
  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}

// ==========================================
// 2. MAIN APP CONFIGURATION
// ==========================================

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Memo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFF8D6E63), // Warna dasar cokelat
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

// ==========================================
// 3. LOGIN PAGE (UI Modern)
// ==========================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSignUp = false; // Toggle antara Login dan Sign Up

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- LOGO TYPOGRAPHY ---
              RichText(
                text: TextSpan(
                  style: GoogleFonts.fugazOne(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                  children: const [
                    TextSpan(
                      text: "YOUR ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "memo",
                      style: TextStyle(
                        color: Color(0xFFFFCA28), // Kuning Emas
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // --- GLASSMORPHISM CARD ---
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Efek kaca
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("USERNAME"),
                    _buildTextField(),
                    const SizedBox(height: 15),

                    _buildLabel("PASSWORD"),
                    _buildTextField(isObscure: true),
                    const SizedBox(height: 15),

                    // Field Tambahan jika Sign Up
                    if (isSignUp) ...[
                      _buildLabel("EMAIL"),
                      _buildTextField(),
                      const SizedBox(height: 15),
                    ],

                    // Toggle Login / Sign Up Text
                    Row(
                      children: [
                        Text(
                          isSignUp
                              ? "Sudah punya akun? "
                              : "Belum punya akun? ",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isSignUp = !isSignUp),
                          child: Text(
                            isSignUp ? "LOGIN" : "BUAT DISINI",
                            style: const TextStyle(
                              color: Color(0xFFFFCA28),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- ACTION BUTTON ---
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF5D4037,
                          ), // Cokelat Tua
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {
                          // Navigasi ke Dashboard Utama
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainDashboard(),
                            ),
                          );
                        },
                        child: Text(
                          isSignUp ? "SIGN UP" : "LOG IN",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 5),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          fontSize: 12,
        ),
      ),
    );
  }

  // Widget Helper untuk Input Field
  Widget _buildTextField({bool isObscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: TextField(
        obscureText: isObscure,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
    );
  }
}
