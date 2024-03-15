import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    // expand que tome todo  o espaço disponível del padre
    return const SizedBox.expand(
      child: Center(
        // adaptive se adapata el dipositivo que este abriendo la aplicacion
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
