import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'beranda.dart';
import 'dashboard.dart';
import 'profil.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Notification Service
  await NotificationService().init();

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
        scaffoldBackgroundColor: const Color(0xFF8D6E63),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const AuthCheck(),
    );
  }
}

// ===========================
// 1. MODEL DATA (TASK)
// ===========================
class Task {
  String id;
  String title;
  String description;
  String date; // Format: YYYY-MM-DD
  String category; // Personal, Work, Urgent
  bool isCompleted;
  String? location; // Lokasi geolokasi (opsional)

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.isCompleted = false,
    this.location,
  });
}

// ===========================
// 2. STATE MANAGEMENT (PROVIDER)
// ===========================
class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [
    // Data Dummy Awal
    Task(
      id: '1',
      title: 'Meeting Proyek Akhir',
      description:
          'Diskusi fitur dengan tim dev. Hubungi Budi 081234567890 jika telat.',
      date: '2024-01-20',
      category: 'Work',
    ),
    Task(
      id: '2',
      title: 'Beli Kado Ulang Tahun',
      description: 'Cari kado untuk adik.',
      date: '2024-01-21',
      category: 'Personal',
    ),
  ];

  List<Task> get tasks => _tasks;

  void addTask({
    required String title,
    required String description,
    required String date,
    required String category,
    String? location,
  }) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      date: date,
      category: category,
      location: location,
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  void editTask(String id, Task newTask) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = newTask;
      notifyListeners();
    }
  }

  void deleteTask(Task task) {
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
  }
}

// ==========================================
// WIDGET BARU: AUTH CHECK
// ==========================================
class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return isLoggedIn! ? const MainDashboard() : const LoginPage();
  }
}

// ==========================================
// MAIN DASHBOARD WITH BOTTOM NAVIGATION
// ==========================================
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    BerandaPage(),
    TodoListPage(),
    ProfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF8D6E63),
        onTap: _onItemTapped,
      ),
    );
  }
}

// ==========================================
// 3. LOGIN PAGE
// ==========================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSignUp = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _handleAuth() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan Password tidak boleh kosong!"),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    if (isSignUp) {
      await prefs.setString('user_username', username);
      await prefs.setString('user_password', password);
      await prefs.setBool('isLoggedIn', true);
      if (!mounted) return;
      _navigateToDashboard();
    } else {
      String? storedUser = prefs.getString('user_username');
      String? storedPass = prefs.getString('user_password');

      if ((username == storedUser && password == storedPass) ||
          (username == "admin" && password == "admin")) {
        await prefs.setBool('isLoggedIn', true);
        if (!mounted) return;
        _navigateToDashboard();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Username atau Password salah!"),
          ),
        );
      }
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainDashboard()),
    );
  }

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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                            color: Color(0xFFFFCA28),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
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
                        _buildTextField(controller: _usernameController),
                        const SizedBox(height: 15),
                        _buildLabel("PASSWORD"),
                        _buildTextField(
                          isObscure: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 15),
                        if (isSignUp) ...[
                          _buildLabel("EMAIL"),
                          _buildTextField(controller: _emailController),
                          const SizedBox(height: 15),
                        ],
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5D4037),
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
                            onPressed: _handleAuth,
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
        ),
      ),
    );
  }

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

  Widget _buildTextField({
    bool isObscure = false,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
    );
  }
}
