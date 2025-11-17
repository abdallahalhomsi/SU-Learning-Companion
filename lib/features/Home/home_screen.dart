import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _suBlue = Color(0xFF155FA0);
  static const _suBlueDark = Color(0xFF0D3B66);

  @override
  Widget build(BuildContext context) {
    // scrollable reminders list
    final List<Map<String, String>> reminders = [
      {'course': 'CS303', 'detail': 'Due Tomorrow'},
      {'course': 'CS300', 'detail': 'Due Today'},
      {'course': 'CS306', 'detail': 'Due Next Week'},
      {'course': 'CS310', 'detail': 'Due Friday'},
    ];

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

              onPressed: () {
                context.go('/courses/add');
              },
              child: const Text('+ ADD COURSE'),

            ),
          ),
        ],
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 170, // fixed height for the box
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.info_outline,
                          color: Colors.redAccent,
                        ),
                        title: Text(reminder['course']!),
                        subtitle: Text(reminder['detail']!),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                ),
              ),

              const SizedBox(height: 20),

              // ur courses
              Container(
                decoration: BoxDecoration(
                  color: _suBlueDark,
                  borderRadius: BorderRadius.circular(16),
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
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 8),

                    ...['CS310', 'CS300', 'CS306', 'CS303', 'MATH 306'].map(
                          (code) => _CourseRow(
                        code: code,
                        onTap: () {

                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // nav bar which goes to calender home profile
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // 0 = home
        backgroundColor: _suBlueDark,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:

              break;
            case 1:

              context.go('/calendar');
              break;
            case 2:
            // go to profile screen
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
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
