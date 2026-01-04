import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Pastikan import ini ada untuk akses Task & TaskProvider

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  // State untuk filter kategori
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ["All Tasks", "Urgent", "Work", "Personal"];

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari Provider
    var taskProvider = Provider.of<TaskProvider>(context);
    var allTasks = taskProvider.tasks;

    // --- LOGIKA FILTERING ---
    // Jika index 0 (All), tampilkan semua. Jika tidak, filter berdasarkan nama kategori.
    var displayedTasks = _selectedCategoryIndex == 0
        ? allTasks
        : allTasks
              .where(
                (task) => task.category == _categories[_selectedCategoryIndex],
              )
              .toList();

    // --- LOGIKA STATISTIK ---
    int totalTasks = allTasks.length;
    int doneTasks = allTasks.where((t) => t.isCompleted).length;
    int pendingTasks = totalTasks - doneTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Background abu muda
      body: Column(
        children: [
          // ==============================
          // 1. HEADER & SUMMARY CARD AREA
          // ==============================
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Gradient Header
              Container(
                height: 280,
                padding: const EdgeInsets.fromLTRB(25, 60, 25, 0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    // Top Bar: Greeting & Profile
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              "Rasyiq", // Ganti dengan nama user dinamis jika ada
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFFCA28),
                              width: 2,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF5D4037),
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Daily Quote Box
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb,
                            color: Color(0xFFFFCA28),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "\"Consistency is the key to success.\"",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Floating Summary Card (Statistik)
              Positioned(
                bottom: -40,
                left: 25,
                right: 25,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSummaryItem(
                        totalTasks.toString(),
                        "Tasks",
                        Colors.blueAccent,
                      ),
                      VerticalDivider(
                        color: Colors.grey[200],
                        indent: 20,
                        endIndent: 20,
                      ),
                      _buildSummaryItem(
                        pendingTasks.toString(),
                        "Pending",
                        Colors.orange,
                      ),
                      VerticalDivider(
                        color: Colors.grey[200],
                        indent: 20,
                        endIndent: 20,
                      ),
                      _buildSummaryItem(
                        doneTasks.toString(),
                        "Done",
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 55), // Spasi untuk Floating Card
          // ==============================
          // 2. CATEGORY SELECTOR (FILTER)
          // ==============================
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                bool isActive = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF5D4037) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? Colors.transparent
                            : Colors.grey.shade300,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: const Color(0xFF5D4037).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      _categories[index],
                      style: GoogleFonts.poppins(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ==============================
          // 3. TASK LIST AREA
          // ==============================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Tasks",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4E342E),
                ),
              ),
            ),
          ),

          Expanded(
            child: displayedTasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: displayedTasks.length,
                    itemBuilder: (context, index) {
                      final task = displayedTasks[index];

                      return Dismissible(
                        // Key harus unik berdasarkan objek task
                        key: ValueKey(task),
                        direction:
                            DismissDirection.endToStart, // Geser kanan ke kiri
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        onDismissed: (direction) {
                          // Hapus task via Provider
                          taskProvider.deleteTask(task);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Task '${task.title}' deleted"),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {},
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Checkbox Custom
                              GestureDetector(
                                onTap: () {
                                  // Cari index asli di list utama untuk di-toggle
                                  int originalIndex = allTasks.indexOf(task);
                                  if (originalIndex != -1) {
                                    taskProvider.toggleTask(originalIndex);
                                  }
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: task.isCompleted
                                        ? const Color(0xFF66BB6A)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: task.isCompleted
                                          ? const Color(0xFF66BB6A)
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                  child: task.isCompleted
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 15),

                              // Detail Task
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: task.isCompleted
                                            ? Colors.grey[400]
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Badge Kategori Kecil
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(
                                          task.category,
                                        ).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        task.category.toUpperCase(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: _getCategoryColor(
                                            task.category,
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- HELPER METHODS ---

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Urgent':
        return Colors.red;
      case 'Work':
        return Colors.blueAccent;
      case 'Personal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSummaryItem(String value, String label, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_turned_in_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 15),
          Text(
            "No tasks found",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          Text(
            "Try selecting another category or add new tasks.",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }
}
