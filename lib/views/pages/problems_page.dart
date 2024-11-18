import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/problems_bloc/problems_bloc.dart';
import '../../bloc/problems_bloc/problems_event.dart';
import '../../bloc/problems_bloc/problems_state.dart';

class ProblemsScreen extends StatelessWidget {
  const ProblemsScreen({Key? key}) : super(key: key);

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remover do histórico',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  // Lógica para remover do histórico
                  Navigator.pop(context); // Fecha o modal
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancelar'),
                onTap: () {
                  Navigator.pop(context); // Fecha o modal
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus problemas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    '1',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Contribuições',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Histórico',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.error_outline),
                    title: const Text('Problema relatado'),
                    subtitle: const Text('15 de nov. às 23:45pm'),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        context
                            .read<ProblemsBloc>()
                            .add(OpenModalEvent()); // Dispara evento para abrir modal
                      },
                    ),
                  ),
                ],
              ),
            ),
            BlocListener<ProblemsBloc, ProblemsState>(
              listener: (context, state) {
                if (state is ModalOpenState) {
                  _showBottomSheet(context);
                  context.read<ProblemsBloc>().add(CloseModalEvent());
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
