import 'package:city_watch/data/models/enums/e_tipo_problema.dart';
import 'package:city_watch/views/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/problems_bloc/problems_bloc.dart';
import '../../bloc/problems_bloc/problems_event.dart';
import '../../bloc/problems_bloc/problems_state.dart';
import '../../data/models/dtos/qtd_problema_dto.dart';

class ProblemsScreen extends StatefulWidget {
  const ProblemsScreen({Key? key}) : super(key: key);

  @override
  State<ProblemsScreen> createState() => _ProblemsScreenState();
}

class _ProblemsScreenState extends State<ProblemsScreen> {
  QtdProblemaDto? _qtdProblemaDto;
  @override
  void initState() {
    BlocProvider.of<ProblemsBloc>(context).add(BuscarDadosEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus problemas'),
        centerTitle: true,
      ),
      body: BlocListener<ProblemsBloc, ProblemsState>(
        listener: (context, state){
          if(state is OpenLoading){
            showDialog(context: context, builder: (_) => LoadingWidget());
          }else if(state is CloseLoading){
            Navigator.of(context).pop();
          }else if(state is OpenError){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mensagem)));
          }else if(state is BuscarDadosSucess){
            setState(() {
              _qtdProblemaDto = state.qtdProblemaDto;
            });
          }
        },
        child: BlocBuilder<ProblemsBloc, ProblemsState>(
          builder: (context, state) =>
              Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        _qtdProblemaDto?.size.toString() ?? "0",
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
                if(_qtdProblemaDto != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: _qtdProblemaDto!.data.length,
                      itemBuilder: (context, index){
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.error_outline,
                                  color: Colors.lightGreen,
                                  size: 36,
                                ),
                                title: Text(
                                  _qtdProblemaDto!.data[index].nome,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    _qtdProblemaDto!.data[index].endereco,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                tileColor: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
