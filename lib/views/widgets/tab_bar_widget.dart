import 'package:city_watch/views/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_bloc/home_bloc.dart';
import '../../data/service/NotificationService.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  int currentIndex = 0;

  final NotificationService notificationService = NotificationService();

  Widget _paginaSelecionada() {
    switch (currentIndex) {
      case 0:
        return BlocProvider<HomeBloc>(create: (context) => HomeBloc(notificationService), child: HomePage());
      case 1:
        return Container(
          color: Colors.green,
        );
      case 2:
        return Container(
          color: Colors.blue,
        );
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
            icon: Icon(Icons.search),
            label: 'Pesquisar',
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
