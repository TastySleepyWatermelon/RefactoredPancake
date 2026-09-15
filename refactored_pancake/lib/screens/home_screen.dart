import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, Sarah'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Overview',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          // Caring for card
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Caring for',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        Text(
                          'Robert Johnson',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Current caretaker card
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.volunteer_activism,
                      color:
                          Theme.of(context).colorScheme.onTertiaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Currently taking care',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        Text(
                          'Mike Johnson',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Activity history header
          Text(
            'Activity',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          ..._buildActivityItems(context),
        ],
      ),
    );
  }

  List<Widget> _buildActivityItems(BuildContext context) {
    final activities = [
      _Activity(
        title: 'Morning Medication',
        subtitle: 'Lisinopril 10mg, Metformin 500mg taken with water',
        time: '7:30 AM',
        icon: Icons.medication,
      ),
      _Activity(
        title: 'Blood Pressure Check',
        subtitle: '128/82 mmHg — within normal range',
        time: '7:45 AM',
        icon: Icons.monitor_heart,
      ),
      _Activity(
        title: 'Breakfast',
        subtitle: 'Oatmeal with blueberries, scrambled eggs, decaf tea',
        time: '8:15 AM',
        icon: Icons.restaurant,
      ),
      _Activity(
        title: 'Lunch',
        subtitle: 'Grilled chicken salad, whole wheat bread, apple juice',
        time: '12:30 PM',
        icon: Icons.lunch_dining,
      ),
      _Activity(
        title: 'Afternoon Nap',
        subtitle: 'Rested for 45 minutes in the living room',
        time: '1:30 PM',
        icon: Icons.bed,
      ),
      _Activity(
        title: 'Afternoon Walk',
        subtitle: '20-minute walk around the garden with Mike',
        time: '3:00 PM',
        icon: Icons.directions_walk,
      ),
      _Activity(
        title: 'Blood Sugar Reading',
        subtitle: '110 mg/dL — post-meal, within target',
        time: '3:30 PM',
        icon: Icons.bloodtype,
      ),
      _Activity(
        title: 'Evening Medication',
        subtitle: 'Atorvastatin 20mg taken before dinner',
        time: '5:45 PM',
        icon: Icons.medication_liquid,
      ),
    ];

    return activities.map((activity) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    activity.icon,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        activity.subtitle,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                      ),
                    ],
                  ),
                ),
                Text(
                  activity.time,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _Activity {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;

  const _Activity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
  });
}
