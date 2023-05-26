import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckAuthStatusScreen extends StatelessWidget {
  const CheckAuthStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //* <--- Riverpod escuchar el provider de autenticación para mostrar el plash screen
    //*      mientras se verifica el estado de autenticación
    //*      y redirigir a la pantalla de login o a la pantalla de productos.
    //*      No es recomendable usar la pantalla para esta navegacion, sino el GoRouter para la proteccio de rutas
    // ref.listen(authProvider, (previous, next) {
    //   // print(next);
    //   context.go('/');
    // });
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    ));
  }
}
