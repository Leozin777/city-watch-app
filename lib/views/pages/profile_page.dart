import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/profile_bloc/profile_state.dart';
import '../../bloc/profile_bloc/profile_event.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../data/models/dtos/profile_edit_dto.dart';
import '../../data/service/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      BlocProvider.of<ProfileBloc>(context).add(
          UpdateProfileImageEvent(_profileImage!));
    }
  }

  void _editField(BuildContext context, String fieldName,
      TextEditingController controller) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Editar $fieldName'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Digite o novo $fieldName'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<ProfileBloc>(context).add(EditFieldEvent(
                  fieldName: fieldName,
                  fieldValue: controller.text,
                ));
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }


  void _updateProfile() {
    final profileEditDto = ProfileEditDto(
      name: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );


    BlocProvider.of<ProfileBloc>(context).add(
        UpdateProfileEvent(profileEditDto));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
        title: Text('Editar Perfil'),
      ),
      body: BlocProvider(
        create: (_) => ProfileBloc(profileService: ProfileService()),
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileImageUpdatedState) {
              setState(() {
                _profileImage = state.profileImage;
              });
            } else if (state is ProfileFieldUpdatedState) {
              setState(() {
                if (state.fieldName == 'Nome completo') {
                  _fullNameController.text = state.fieldValue;
                } else if (state.fieldName == 'E-mail') {
                  _emailController.text = state.fieldValue;
                } else if (state.fieldName == 'Nome de usuário') {
                  _usernameController.text = state.fieldValue;
                } else if (state.fieldName == 'Senha') {
                  _passwordController.text = state.fieldValue;
                }
              });
              Navigator.pop(context);
            } else if (state is ProfileUpdateLoadingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Atualizando perfil...')));
            } else if (state is ProfileUpdateSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Perfil atualizado com sucesso!')));
            } else if (state is ProfileUpdateFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Falha ao atualizar o perfil')));
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green,
                        backgroundImage: _profileImage != null ? FileImage(
                            _profileImage!) : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, color: Colors.white, size: 40)
                            : null,
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _usernameController.text.isEmpty
                      ? 'Nome de usuário'
                      : _usernameController.text,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Meus problemas'),
                ),
                Divider(),
                ListTile(
                  title: Text('Nome completo'),
                  subtitle: Text(_fullNameController.text.isEmpty
                      ? 'Nome completo não informado'
                      : _fullNameController.text),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () =>
                      _editField(context, 'Nome completo', _fullNameController),
                ),
                ListTile(
                  title: Text('E-mail'),
                  subtitle: Text(_emailController.text.isEmpty
                      ? 'E-mail não informado'
                      : _emailController.text),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _editField(context, 'E-mail', _emailController),
                ),
                ListTile(
                  title: Text('Nome de usuário'),
                  subtitle: Text(_usernameController.text.isEmpty
                      ? 'Nome de usuário não informado'
                      : _usernameController.text),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () =>
                      _editField(
                          context, 'Nome de usuário', _usernameController),
                ),
                ListTile(
                  title: Text('Senha'),
                  subtitle: Text('Alterar senha'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () =>
                      _editField(context, 'Senha', _passwordController),
                ),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Salvar alterações'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
