import 'package:city_watch/views/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int selectedOption = -1;

  void navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: navigateToProfile,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuário',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: navigateToProfile,
                        child: Text(
                          'Ver perfil',
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            buildRadioButton(0, 'Receber todas as notificações'),
            buildRadioButton(1, 'Apenas notificações dos meus problemas'),
            buildRadioButton(2, 'Apenas dos problemas interagidos'),
            buildRadioButton(3, 'Desativar notificações'),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => exitApp(),
              child: Row(
                children: [
                  Icon(Icons.power_settings_new),
                  SizedBox(width: 10),
                  Text(
                    'Sair do aplicativo',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRadioButton(int value, String title) {
    return RadioListTile(
      value: value,
      groupValue: selectedOption,
      onChanged: (int? newValue) {
        setState(() {
          selectedOption = newValue!;
        });
      },
      title: Text(title),
    );
  }

  void exitApp() {
    SystemNavigator.pop();
  }
}
