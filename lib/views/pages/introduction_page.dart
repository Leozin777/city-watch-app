import 'package:city_watch/data/models/interface/ilocal_storage_helper.dart';
import 'package:city_watch/helpers/staticos.dart';
import 'package:city_watch/main.dart';
import 'package:flutter/material.dart';
import 'auth_pages/login_page.dart';
import 'auth_pages/register_page.dart';

class IntroductionPage extends StatelessWidget {
  IntroductionPage({super.key});

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A9C89),
              Color(0xFFC4DAD2),
              Color(0xFFE9EFEC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onDoubleTap: () async {
                    final endereco = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Set endereço da api"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: controller,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, controller.text);
                              },
                              child: const Text("Salvar"),
                            ),
                          ],
                        ),
                      ),
                    );

                    if (endereco != null) {
                      final ILocalStorageHelper localStorageHelper = injecaoDeDepencia<ILocalStorageHelper>();
                      localStorageHelper.setStringSecureStorage("baseUrl", endereco);
                      Staticos.baseUrl = endereco;
                    }
                  },
                  child: Image.asset("assets/img/city_watch_logo.png"),
                ),
                const SizedBox(height: 20),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RegisterPage.route);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6A9C89),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          child: const Text("Cadastrar-se"),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.route);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF16423C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          child: const Text("Login"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
