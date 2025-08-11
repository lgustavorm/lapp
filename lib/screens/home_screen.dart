import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lapp')),
      body: Column(
        children: [
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/session');
            },
            child: Text('Iniciar nova cronometragem'),
          ),
          SizedBox(height: 32),
          Text(
            'Histórico de cronometragens (em breve)',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
