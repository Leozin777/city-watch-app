import 'dart:convert';

import 'package:city_watch/bloc/profile_bloc/profile_bloc.dart';
import 'package:city_watch/bloc/profile_bloc/profile_state.dart';
import 'package:city_watch/data/models/dtos/user_profile_exibicao_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/profile_bloc/profile_event.dart';
import '../../data/models/dtos/user_profile_edit_dto.dart';
import '../widgets/tirar_foto_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfileExibicaoDto? userProfileExibicaoDto;
  String imgUser = '';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(ProfileBuscarDadosDoUsuario());
    super.initState();
  }

  tirarFoto() async {
    try {
      final foto = await showDialog(context: context, builder: (_) => const TirarFotoWidget());
      if (foto != null) {
        imgUser = foto;
      }
    } on Exception {
      return null;
    }
  }

  updateProfile() {
    final userProfileDto = UserProfileDto(
      nome: _nameController.text.isEmpty ? userProfileExibicaoDto!.nome : _nameController.text,
      email: _emailController.text.isEmpty ? userProfileExibicaoDto!.email : _emailController.text,
      foto: imgUser.isEmpty ? userProfileExibicaoDto!.foto : imgUser,
    );
    BlocProvider.of<ProfileBloc>(context).add(ProfileEditarDadosDoUsuario(userProfileDto));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileCarregadoSuccess) {
            setState(() {
              userProfileExibicaoDto = state.userProfileExibicaoDto;
              _nameController.text = userProfileExibicaoDto!.nome;
              _emailController.text = userProfileExibicaoDto!.email;
              imgUser = userProfileExibicaoDto!.foto;
            });
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ));
          } else if (state is ProfileEditadoSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Perfil editado com sucesso"),
              backgroundColor: Colors.green,
            ));

            BlocProvider.of<ProfileBloc>(context).add(ProfileBuscarDadosDoUsuario());
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text("Olá, ${userProfileExibicaoDto?.nome ?? ''}"),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: tirarFoto,
                    child: imgUser.isEmpty
                        ? CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person, size: 50),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(base64Decode(imgUser!)),
                          ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: updateProfile,
                    child: Text('Salvar alterações'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
