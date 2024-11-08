import 'package:city_watch/bloc/auth_bloc/register_bloc/register_state.dart';
import 'package:city_watch/views/pages/auth_pages/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_bloc/register_bloc/register_bloc.dart';
import '../../../bloc/auth_bloc/register_bloc/register_event.dart';
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

  bool _nomeError = false;
  bool _emailError = false;
  bool _senhaError = false;

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

            Future.delayed(const Duration(seconds: 2));
            Navigator.of(context).pushReplacementNamed(HomePage.route);
          }

          if (state is RegisterNomeEhObrigatorioState) {
            setState(() {
              _nomeError = true;
            });
          }

          if (state is RegisterEmailEhObrigatorioState) {
            setState(() {
              _emailError = true;
            });
          }

          if (state is RegisterSenhaEhObrigatorioState) {
            setState(() {
              _senhaError = true;
            });
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
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
                        "Cadastre-se",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Olá, registre-se para começar a usar o app",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      TextFieldWidget(
                        labelText: "Email",
                        errorText: _emailError ? "Email é obrigatório" : null,
                        controller: _emailController,
                        onChanged: (value) {
                          setState(() {
                            _emailError = false;
                          });
                        },
                        decoration: _inputDecoration("Email", _emailError ? "Email é obrigatório" : null),
                      ),
                      const SizedBox(height: 20),
                      TextFieldWidget(
                        labelText: "Nome",
                        errorText: _nomeError ? "Nome é obrigatório" : null,
                        controller: _nameController,
                        onChanged: (value) {
                          setState(() {
                            _nomeError = false;
                          });
                        },
                        decoration: _inputDecoration("Nome", _nomeError ? "Nome é obrigatório" : null),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _senhaError = false;
                          });
                        },
                        controller: _passwordController,
                        decoration: _inputDecoration("Senha", _senhaError ? "Senha é obrigatório" : null).copyWith(
                          suffixIcon: _obscureText
                              ? IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: const Icon(Icons.visibility_off, color: Colors.white),
                          )
                              : IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: const Icon(Icons.visibility, color: Colors.white),
                          ),
                        ),
                        obscureText: _obscureText,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 30),
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
                                'CADASTRAR',
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
                          text: 'Já possui uma conta? ',
                          style: DefaultTextStyle.of(context).style.copyWith(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: 'Clique aqui ',
                              style: const TextStyle(
                                color: Colors.white,
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
