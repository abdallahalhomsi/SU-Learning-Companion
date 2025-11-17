import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _suBlue = Color(0xFF155FA0);
  static const _suBlueDark = Color(0xFF0D3B66);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        backgroundColor: _suBlue,
        elevation: 0,
        centerTitle: true,

        title: const Text('Sabancı Üniversitesi'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F7ACF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              // overhere i will g oto add course screen
              onPressed: () {},
              child: const Text('+ ADD COURSE'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // “Due Tomorrow” card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading:
              const Icon(Icons.info_outline, color: Colors.redAccent),
              title: const Text('CS 303'),
              subtitle: const Text('Due Tomorrow'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(height: 16),

          // “Your Courses” panel
          Container(
            decoration: BoxDecoration(
              color: _suBlueDark,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR COURSES',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .6,
                  ),
                ),
                const SizedBox(height: 6),
                const Divider(color: Colors.white24, thickness: 1),
                const SizedBox(height: 8),
                ...['CS310', 'CS300', 'CS306', 'CS303', 'MATH 306'].map(
                      (code) => _CourseRow(
                    code: code,

                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),


      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _suBlueDark,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {

        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}

class _CourseRow extends StatelessWidget {
  final String code;
  final VoidCallback onTap;

  const _CourseRow({
    required this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.star_border, color: Colors.white),
      title: Text(
        code,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }
}
