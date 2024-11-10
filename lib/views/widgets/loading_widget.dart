import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? textoDoLoading;

  const LoadingWidget({super.key, this.textoDoLoading});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                textoDoLoading ?? "Carregando...",
              ),
            )
          ],
        ),
      ),
    );
  }
}
