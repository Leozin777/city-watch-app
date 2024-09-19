import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Row(
        children: [
          CircularProgressIndicator(),
          Text("Carregando..."),
        ],
      ),
    );
  }
}
