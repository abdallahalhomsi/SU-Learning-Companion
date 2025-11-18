import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const String studentName = 'John Doe';
    const String studentId = '11111';
    const String email = 'johndoe@sabanciuniv.edu';
    const String major = 'Computer Science';
    const String minor = 'Business Analytics';
    const String department = 'FENS';

    //  same blue as app
    const Color primaryBlue = Color(0xFF003366);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'PROFILE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Student Information',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _InfoLine(
                        label: 'Name',
                        value: studentName,
                        highlightColor: primaryBlue,
                      ),
                      _InfoLine(
                        label: 'Student ID',
                        value: studentId,
                        highlightColor: primaryBlue,
                      ),
                      _InfoLine(
                        label: 'Email',
                        value: email,
                        highlightColor: primaryBlue,
                      ),
                      _InfoLine(
                        label: 'Major',
                        value: major,
                        highlightColor: primaryBlue,
                      ),
                      _InfoLine(
                        label: 'Minor',
                        value: minor,
                        highlightColor: primaryBlue,
                      ),
                      _InfoLine(
                        label: 'Department',
                        value: department,
                        highlightColor: primaryBlue,
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: SizedBox(
                          width: 180,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Log Out'),
                                    content: const Text(
                                      'Are you sure you want to log out?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Close the dialog first
                                          Navigator.of(context).pop();
                                          // Navigate back to the Sign In page
                                          context.go('/login');
                                        },
                                        child: const Text('Log Out'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE74C3C),
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Log out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // 0 = home, 1 = calendar, 2 = profile
        backgroundColor: primaryBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 2) return;

          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/calendar');
              break;
            case 2:
              context.go('/profile');
              break;
          }
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

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final Color highlightColor;

  const _InfoLine({
    required this.label,
    required this.value,
    required this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.4,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: highlightColor,
              ),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    );
  }
}