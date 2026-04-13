import 'package:flutter/material.dart';
import '../../widgets/animations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mockNotifications = [
      {
        'title': 'New Collection Alert!',
        'body': 'Discover our Autumn Collection 2026 now.',
        'time': '2 hours ago'
      },
      {
        'title': 'Order Dispatched',
        'body': 'Your order #ORD12345 has been shipped.',
        'time': '1 day ago'
      },
      {
        'title': 'Flash Sale!',
        'body': 'Up to 50% off on all accessories for the next 24 hours.',
        'time': '3 days ago'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: mockNotifications.isEmpty
          ? const Center(child: Text('No notifications yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: mockNotifications.length,
              itemBuilder: (context, index) {
                final notif = mockNotifications[index];
                return StaggeredItem(
                  index: index,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notif['title']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              notif['time']!,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notif['body']!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
