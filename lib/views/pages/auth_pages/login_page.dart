import 'package:city_watch/views/pages/home_page.dart';
import 'package:city_watch/views/widgets/loading_widget.dart';
import 'package:city_watch/views/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth_bloc/login_bloc/login_bloc.dart';
import '../../../bloc/auth_bloc/login_bloc/login_event.dart';
import '../../../bloc/auth_bloc/login_bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  static String route = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _senhaController;

  bool _obscureText = true;
  bool _emailError = false;
  bool _senhaError = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _senhaController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginOpenLoadingState) {
              showDialog(context: context, builder: (_) => const LoadingWidget());
            }

            if (state is LoginCloseLoadingState) {
              Navigator.of(context).pop();
            }

            if (state is LoginFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }

            if (state is LoginSuccessState) {
              Navigator.of(context).pushReplacementNamed(HomePage.route);
            }

            if (state is LoginEmailEhObrigatorioState) {
              setState(() {
                _emailError = true;
              });
            }

            if (state is LoginSenhaEhObrigatorioState) {
              setState(() {
                _senhaError = true;
              });
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        "Ola, bem vindo de volta!",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      TextFieldWidget(
                          labelText: "Email",
                          onChanged: (value) {
                            setState(() {
                              _emailError = false;
                            });
                          },
                          errorText: _emailError ? "Email é obrigatório" : null,
                          controller: _emailController),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _senhaError = false;
                          });
                        },
                        controller: _senhaController,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          errorText: _senhaError ? "Senha é obrigatório" : null,
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
                              BlocProvider.of<LoginBloc>(context).add(
                                LoginButtonPressedEvent(
                                  email: _emailController.text,
                                  senha: _senhaController.text,
                                ),
                              );
                            },
                            child: Text('Login'),
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
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
