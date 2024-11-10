import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart'; // Para fechar o app
import '../../bloc/setting_bloc/setting_state.dart';
import '../../bloc/setting_bloc/setting_event.dart';
import '../../bloc/setting_bloc/setting_bloc.dart';
import 'package:city_watch/views/pages/profile_page.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(),
      child: BlocListener<SettingsBloc, SettingState>(
        listener: (context, state) {
          if (state is SettingsExitAppState) {
            // Fecha o aplicativo quando o estado SettingsExitAppState for emitido
            FlutterExitApp.exitApp(); // Ou você pode tentar SystemNavigator.pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Redireciona para a página de perfil ao clicar na imagem do usuário
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
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
                            onTap: () {
                              // Redireciona para a página de perfil ao clicar em "Ver perfil"
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfileScreen()),
                              );
                            },
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
                buildRadioButton(context, 0, 'Receber todas as notificações'),
                buildRadioButton(context, 1, 'Apenas notificações dos meus problemas'),
                buildRadioButton(context, 2, 'Apenas dos problemas interagidos'),
                buildRadioButton(context, 3, 'Desativar notificações'),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => context.read<SettingsBloc>().add(ExitAppEvent()), // Dispara o evento para sair do app
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
        ),
      ),
    );
  }

  Widget buildRadioButton(BuildContext context, int value, String title) {
    return BlocBuilder<SettingsBloc, SettingState>(
      builder: (context, state) {
        int selectedOption = state is NotificationOptionSelectedState ? state.selectedOption : -1;

        return RadioListTile(
          value: value,
          groupValue: selectedOption,
          onChanged: (int? newValue) {
            if (newValue != null) {
              context.read<SettingsBloc>().add(SelectNotificationOptionEvent(newValue));
            }
          },
          title: Text(title),
        );
      },
    );
  }
}
