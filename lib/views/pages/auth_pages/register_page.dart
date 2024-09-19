import 'package:city_watch/bloc/auth_bloc/register_bloc/register_bloc.dart';
import 'package:city_watch/bloc/auth_bloc/register_bloc/register_event.dart';
import 'package:city_watch/bloc/auth_bloc/register_bloc/register_state.dart';
import 'package:city_watch/views/pages/auth_pages/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_widget.dart';
import '../../widgets/text_field_widget.dart';
import '../home_page.dart';

class RegisterPage extends StatefulWidget {
  static String route = '/register';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  bool _obscureText = true;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterOpenLoadingState) {
            showDialog(context: (context), builder: (_) => const LoadingWidget());
          }

          if (state is RegisterCloseLoadingState) {
            Navigator.of(context).pop();
          }

          if (state is RegisterFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is RegisterSuccessState) {
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            );
            Navigator.of(context).pushReplacementNamed(HomePage.route);
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    "Ola, registre-se para começar a usar o app",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFieldWidget(
                    labelText: "Email",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  TextFieldWidget(
                    labelText: "Nome",
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Senha",
                      border: OutlineInputBorder(),
                      suffixIcon: _obscureText
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: const Icon(Icons.visibility_off),
                            )
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: const Icon(Icons.visibility),
                            ),
                    ),
                    obscureText: _obscureText,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: FilledButton(
                        onPressed: () {
                          BlocProvider.of<RegisterBloc>(context).add(
                            RegisterButtonPressedEvent(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        },
                        child: Text('Registrar-se'),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: 'Ja possui uma conta? ',
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: 'Clique aqui ',
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushNamed(LoginPage.route);
                            },
                        ),
                      ],
                    ),
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
