import 'package:flutter/material.dart';

class MiniCard extends StatelessWidget {
  const MiniCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
          child: Row(
            children: [
              Image.network(
                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Flutter Card',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'This is a simple card layout in Flutter.',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}