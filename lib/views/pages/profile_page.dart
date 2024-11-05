import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final _fullNameController = TextEditingController(); // Removido texto padrão
  final _emailController = TextEditingController(); // Removido texto padrão
  final _usernameController = TextEditingController(); // Removido texto padrão
  final _passwordController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _editField(TextEditingController controller, String fieldName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar $fieldName'),
          content: SingleChildScrollView(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Digite o novo $fieldName',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40), // Espaçamento acima da foto do usuário
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40,
                )
                    : null,
              ),
            ),
            SizedBox(height: 16),
            Text(
              _usernameController.text.isEmpty ? 'Nome de usuário' : _usernameController.text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Meus problemas'),
            ),
            Divider(),
            ListTile(
              title: Text('Nome completo'),
              subtitle: Text(_fullNameController.text.isEmpty ? 'Nome completo não informado' : _fullNameController.text),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _editField(_fullNameController, 'Nome completo'),
            ),
            ListTile(
              title: Text('E-mail'),
              subtitle: Text(_emailController.text.isEmpty ? 'E-mail não informado' : _emailController.text),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _editField(_emailController, 'E-mail'),
            ),
            ListTile(
              title: Text('Nome de usuário'),
              subtitle: Text(_usernameController.text.isEmpty ? 'Nome de usuário não informado' : _usernameController.text),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _editField(_usernameController, 'Nome de usuário'),
            ),
            ListTile(
              title: Text('Senha'),
              subtitle: Text('Alterar senha'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _editField(_passwordController, 'Senha'),
            ),
          ],
        ),
      ),
    );
  }
}
