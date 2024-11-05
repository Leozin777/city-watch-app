import 'package:city_watch/views/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/home_bloc/home_bloc.dart';
import '../pages/profile_page.dart';
import '../pages/setting_page.dart';

class TabBarWidget extends StatefulWidget {
  TabBarWidget({super.key});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  int currentIndex = 0;

  Widget _paginaSelecionada() {
    switch (currentIndex) {
      case 0:
        return BlocProvider<HomeBloc>(create: (context) => HomeBloc(), child: HomePage());
      case 1:
        return SettingsScreen();
      case 2:
        return ProfileScreen();
      default:
        return Container(
          color: Colors.red,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _paginaSelecionada(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal[900],
        selectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        unselectedItemColor: Colors.white,
        onTap: (int index) => setState(() {
          currentIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
