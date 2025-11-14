import 'package:flutter/material.dart';

class ViewRecourseScreen extends StatefulWidget {
  final Resource resource;
  final String courseName;

  const ViewRecourseScreen({
    Key? key,
    required this.resource,
    this.courseName = 'Course Name',
  }) : super(key: key);

  @override
  State<ViewRecourseScreen> createState() => _ViewRecourseScreenState();
}

class _ViewRecourseScreenState extends State<ViewRecourseScreen> {
  int _selectedIndex = 0;

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
   
  }
  // Future<void> _launchURL(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   try {
  //     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
  //       throw Exception('Could not launch $url');
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Could not open link: $e')),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Resource Details : ${widget.courseName}'),
        backgroundColor: const Color(0xFF004B87),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE8E8E8),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF004B87),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '"${widget.resource.title}"',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF004B87),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  widget.resource.description,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              // Removed onTap callback as _launchURL is not available
              // onTap: () => _launchURL(widget.resource.link),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF004B87),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.resource.link,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        backgroundColor: const Color(0xFF004B87),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
