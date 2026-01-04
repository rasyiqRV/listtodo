import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // --- STATE VARIABLES (Data User) ---
  String _name = "Rasyiq";
  String _role = "Mobile Developer";
  String _email = "rasyiq@email.com";
  String _phone = "+62 812 3456 7890";
  String _gender = "Male"; // Default gender

  @override
  Widget build(BuildContext context) {
    // 1. MENGAMBIL DATA TUGAS DARI PROVIDER
    final taskProvider = Provider.of<TaskProvider>(context);
    final allTasks = taskProvider.tasks;

    // 2. MENGHITUNG STATISTIK
    final int completedCount = allTasks.where((t) => t.isCompleted).length;
    final int pendingCount = allTasks.where((t) => !t.isCompleted).length;

    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // Background abu-abu muda bersih
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: const Color(0xFF8D6E63), // Warna Coklat Utama
        elevation: 0,
        automaticallyImplyLeading: false, // HILANGKAN TOMBOL BACK
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit_note_rounded,
              color: Colors.white,
              size: 28,
            ),
            onPressed: _showEditProfileSheet,
            tooltip: "Edit Info",
          ),
        ],
      ),

      // --- BODY UTAMA ---
      body: Stack(
        children: [
          // 1. BACKGROUND LENGKUNGAN (HEADER)
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(height: 200, color: const Color(0xFF8D6E63)),
          ),

          // 2. KONTEN SCROLLABLE
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // --- BAGIAN FOTO & NAMA ---
                Center(
                  child: Column(
                    children: [
                      // Avatar Container
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey[300],
                          // --- LOAD GAMBAR DARI ASSETS LOKAL ---
                          backgroundImage: const AssetImage(
                            'assets/rasyiq.png',
                          ),
                          // Jika gambar gagal dimuat, tampilkan icon orang
                          onBackgroundImageError: (_, __) {
                            debugPrint(
                              "Gambar assets/rasyiq.png tidak ditemukan, pastikan pubspec.yaml benar.",
                            );
                          },
                          child: null,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Nama User
                      Text(
                        _name,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      // Role User
                      Text(
                        _role,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- KARTU STATISTIK (COMPLETED / PENDING) ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        "Completed",
                        "$completedCount",
                        Colors.green,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey[200],
                      ), // Garis pemisah
                      _buildStatItem("Pending", "$pendingCount", Colors.orange),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- LIST DETAIL INFO ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        "My Details",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5D4037),
                        ),
                      ),
                    ),
                    _buildInfoCard(Icons.email_outlined, "Email", _email),
                    const SizedBox(height: 12),
                    _buildInfoCard(Icons.phone_outlined, "Phone", _phone),
                    const SizedBox(height: 12),
                    // Menampilkan Gender (Ikon berubah sesuai gender)
                    _buildInfoCard(
                      _gender == "Male" ? Icons.male : Icons.female,
                      "Gender",
                      _gender,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      Icons.calendar_today_outlined,
                      "Joined",
                      "Jan 2024",
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // --- TOMBOL LOGOUT ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _handleLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                      side: BorderSide(
                        color: Colors.redAccent.withOpacity(0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout_rounded),
                        const SizedBox(width: 8),
                        Text(
                          "Log Out",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Jarak aman bawah
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // WIDGET HELPER (Kecil-kecil)
  // ============================

  // Widget untuk angka statistik
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  // Widget untuk kartu info (Email, Phone, dll)
  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF8D6E63).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF8D6E63), size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // LOGIC & MODAL SHEET
  // ============================

  // Fungsi Logout
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Log Out",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to exit?",
          style: GoogleFonts.poppins(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              // Kembali ke halaman Login & hapus semua route sebelumnya
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: Text(
              "Log Out",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi Menampilkan Form Edit (Bottom Sheet)
  void _showEditProfileSheet() {
    // Inisialisasi controller dengan data saat ini
    final nameC = TextEditingController(text: _name);
    final roleC = TextEditingController(text: _role);
    final phoneC = TextEditingController(text: _phone);
    String tempGender = _gender; // Variabel sementara untuk radio button

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Agar keyboard tidak menutupi form
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        // StatefulBuilder digunakan agar Radio Button bisa direfresh tampilannya dalam modal
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(ctx).viewInsets.bottom +
                    20, // Padding keyboard
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Garis kecil di atas modal
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Edit Profile",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Form Fields
                  _buildEditField("Full Name", nameC),
                  const SizedBox(height: 15),
                  _buildEditField("Role / Job", roleC),
                  const SizedBox(height: 15),
                  _buildEditField("Phone Number", phoneC, isNumber: true),

                  const SizedBox(height: 15),

                  // --- PILIHAN GENDER (Radio) ---
                  Text(
                    "Gender",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: "Male",
                        groupValue: tempGender,
                        activeColor: const Color(0xFF8D6E63),
                        onChanged: (value) {
                          setModalState(
                            () => tempGender = value!,
                          ); // Update UI modal
                        },
                      ),
                      Text("Male", style: GoogleFonts.poppins()),
                      const SizedBox(width: 20),
                      Radio<String>(
                        value: "Female",
                        groupValue: tempGender,
                        activeColor: const Color(0xFF8D6E63),
                        onChanged: (value) {
                          setModalState(
                            () => tempGender = value!,
                          ); // Update UI modal
                        },
                      ),
                      Text("Female", style: GoogleFonts.poppins()),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8D6E63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Simpan data ke variabel utama halaman
                        setState(() {
                          _name = nameC.text;
                          _role = roleC.text;
                          _phone = phoneC.text;
                          _gender = tempGender;
                        });
                        Navigator.pop(ctx); // Tutup modal
                      },
                      child: Text(
                        "Save Changes",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper untuk membuat Text Field Edit
  Widget _buildEditField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}

// ============================
// CLIPPER (Bentuk Lengkungan Header)
// ============================
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40); // Garis kiri turun

    // Membuat lengkungan kurva di bawah
    path.quadraticBezierTo(
      size.width / 2, // Titik tengah kurva (horizontal)
      size.height + 20, // Titik bawah kurva (vertikal)
      size.width, // Titik kanan
      size.height - 40, // Titik kanan (vertikal)
    );

    path.lineTo(size.width, 0); // Garis kanan naik
    path.close(); // Tutup path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
