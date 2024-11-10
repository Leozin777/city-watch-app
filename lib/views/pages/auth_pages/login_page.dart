import 'package:city_watch/views/pages/auth_pages/register_page.dart';
import 'package:city_watch/views/widgets/loading_widget.dart';
import 'package:city_watch/views/widgets/tab_bar_widget.dart';
import 'package:flutter/gestures.dart';
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

  final bool _obscureText = true;
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

  InputDecoration _inputDecoration(String labelText, String? errorText) {
    return InputDecoration(
      labelText: labelText,
      errorText: errorText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(color: Colors.white),
      ),
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => TabBarWidget()));
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
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF16423C),
                    const Color(0xFF6A9C89),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Olá, bem-vindo de volta!",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _emailError = false;
                          });
                        },
                        controller: _emailController,
                        decoration: _inputDecoration("Email", _emailError ? "Email é obrigatório" : null),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _senhaError = false;
                          });
                        },
                        controller: _senhaController,
                        decoration: _inputDecoration("Senha", _senhaError ? "Senha é obrigatória" : null),
                        obscureText: _obscureText,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 30),
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
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(const Color(0xFF6A9C89)),
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                              ),
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: "Não tem uma conta? ",
                          style: DefaultTextStyle.of(context).style.copyWith(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: "Cadastre-se",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushNamed(RegisterPage.route);
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
