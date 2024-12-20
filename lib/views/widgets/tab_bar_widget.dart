import 'package:city_watch/bloc/problems_bloc/problems_bloc.dart';
import 'package:city_watch/bloc/profile_bloc/profile_bloc.dart';
import 'package:city_watch/views/pages/home_page.dart';
import 'package:city_watch/views/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_bloc/home_bloc.dart';
import '../pages/problems_page.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key});

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
        return BlocProvider<ProblemsBloc>(create: (context) => ProblemsBloc(), child: ProblemsScreen());
      case 2:
        return BlocProvider<ProfileBloc>(create: (context) => ProfileBloc(), child: ProfilePage());
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
            icon: Icon(Icons.report_problem),
            label: 'Meus Problemas',
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
