import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final String name;
  final String surname;

  const Dashboard({
    super.key,
    required this.name,
    required this.surname,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hoşgeldiniz, ${widget.name} ${widget.surname}!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bildirimler",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Checkbox(
                  value: _notificationsEnabled,
                  onChanged: (bool? value) {
                    setState(() {
                      _notificationsEnabled = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
