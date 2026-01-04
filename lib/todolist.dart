import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Import wajib untuk akses Class Task & TaskProvider

// ==========================================
// 1. HALAMAN UTAMA (TODO LIST PAGE)
// ==========================================

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari Provider
    var taskProvider = Provider.of<TaskProvider>(context);
    var allTasks = taskProvider.tasks;

    // Logika Filter Search
    var filteredTasks = allTasks.where((task) {
      return task.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    int pendingCount = allTasks.where((t) => !t.isCompleted).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8), // Background modern
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF8D6E63), // Warna Coklat
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Tasks",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            Text(
              "$pendingCount tasks pending",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8D6E63),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          "New Task",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const MakeListScreen()),
        ),
      ),
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Stack(
            children: [
              Container(height: 40, color: const Color(0xFF8D6E63)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Search tasks...",
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: Color(0xFF8D6E63)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = "");
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // --- LIST VIEW ---
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "No tasks found.",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return TaskItemWidget(task: filteredTasks[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. WIDGET ITEM (DENGAN SWIPE DELETE)
// ==========================================

class TaskItemWidget extends StatelessWidget {
  final Task task;
  const TaskItemWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    Color accentColor = _getCategoryColor(task.category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Slidable(
        key: ValueKey(task.id),
        // Geser Kanan -> Edit
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => MakeListScreen(taskToEdit: task),
                  ),
                );
              },
              backgroundColor: const Color(0xFF42A5F5),
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'Edit',
              borderRadius: BorderRadius.circular(15),
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
          ],
        ),
        // Geser Kiri -> Hapus
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => _showDeleteDialog(context),
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
              borderRadius: BorderRadius.circular(15),
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
          ],
        ),

        // Konten Kartu
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Warna Indikator Kiri
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Checkbox
                            GestureDetector(
                              onTap: () {
                                final provider = Provider.of<TaskProvider>(
                                  context,
                                  listen: false,
                                );
                                int index = provider.tasks.indexOf(task);
                                if (index != -1) provider.toggleTask(index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: task.isCompleted
                                      ? accentColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: task.isCompleted
                                        ? accentColor
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
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
                            const SizedBox(width: 12),
                            // Judul
                            Expanded(
                              child: Text(
                                task.title,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isCompleted
                                      ? Colors.grey
                                      : const Color(0xFF2D3436),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 12),
                        // Footer (Tanggal & Kategori)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  task.date,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                task.category,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Urgent':
        return const Color(0xFFE57373);
      case 'Work':
        return const Color(0xFF64B5F6);
      case 'Personal':
        return const Color(0xFF81C784);
      default:
        return const Color(0xFFFFB74D);
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Hapus Tugas",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Yakin ingin menghapus '${task.title}'?",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Batal",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Provider.of<TaskProvider>(
                context,
                listen: false,
              ).deleteTask(task);
              Navigator.pop(ctx);
            },
            child: Text(
              "Hapus",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. HALAMAN TAMBAH/EDIT (DENGAN TOMBOL DELETE)
// ==========================================

class MakeListScreen extends StatefulWidget {
  final Task? taskToEdit;
  const MakeListScreen({super.key, this.taskToEdit});

  @override
  State<MakeListScreen> createState() => _MakeListScreenState();
}

class _MakeListScreenState extends State<MakeListScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Personal';
  final List<String> _categories = ['Personal', 'Work', 'Urgent'];

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descController.text = widget.taskToEdit!.description;
      _selectedCategory = widget.taskToEdit!.category;
      try {
        _selectedDate = DateTime.parse(widget.taskToEdit!.date);
      } catch (e) {
        _selectedDate = DateTime.now();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.taskToEdit != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Task" : "Create New Task",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        // --- TOMBOL DELETE DI APPBAR (KHUSUS MODE EDIT) ---
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
              ),
              onPressed: _confirmDeleteInEdit,
              tooltip: "Delete Task",
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Task Details"),
            const SizedBox(height: 15),

            // Judul
            _buildInputContainer(
              child: TextField(
                controller: _titleController,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "What needs to be done?",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  border: InputBorder.none,
                  icon: const Icon(Icons.task_alt, color: Color(0xFF8D6E63)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kategori
            _buildInputContainer(
              child: Row(
                children: [
                  const Icon(Icons.category_outlined, color: Color(0xFF8D6E63)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        items: _categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: GoogleFonts.poppins()),
                          );
                        }).toList(),
                        onChanged: (newValue) =>
                            setState(() => _selectedCategory = newValue!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tanggal
            GestureDetector(
              onTap: _pickDate,
              child: _buildInputContainer(
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF8D6E63),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(_selectedDate),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Change",
                      style: GoogleFonts.poppins(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            _buildSectionHeader("Additional Notes"),
            const SizedBox(height: 15),

            // Deskripsi
            _buildInputContainer(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextField(
                controller: _descController,
                maxLines: 5,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  hintText: "Add details...",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D6E63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                onPressed: _saveTask,
                child: Text(
                  "Save Task",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey[600],
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildInputContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: child,
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF8D6E63),
            colorScheme: const ColorScheme.light(primary: Color(0xFF8D6E63)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _confirmDeleteInEdit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Task?"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Hapus dan kembali ke halaman list
              Provider.of<TaskProvider>(
                context,
                listen: false,
              ).deleteTask(widget.taskToEdit!);
              Navigator.pop(ctx); // Tutup Dialog
              Navigator.pop(context); // Tutup Halaman Edit
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a title")));
      return;
    }

    final provider = Provider.of<TaskProvider>(context, listen: false);
    final newTask = Task(
      id: widget.taskToEdit?.id ?? DateTime.now().toString(),
      title: _titleController.text,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      description: _descController.text,
      category: _selectedCategory,
      isCompleted: widget.taskToEdit?.isCompleted ?? false,
    );

    if (widget.taskToEdit != null) {
      provider.editTask(widget.taskToEdit!.id, newTask);
    } else {
      provider.addTask(
        title: newTask.title,
        description: newTask.description,
        date: newTask.date,
        category: newTask.category,
      );
    }
    Navigator.pop(context);
  }
}
