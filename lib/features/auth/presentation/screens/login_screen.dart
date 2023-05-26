import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../../../../config/config.dart' as config;
import '../providers/auth_provider.dart';
import '../providers/providers.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Icon Banner
            const Icon(
              Icons.production_quantity_limits_rounded,
              color: Colors.white,
              size: 100,
            ),
            const SizedBox(height: 80),

            Container(
              height: size.height - 260, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _LoginForm(),
            )
          ],
        ),
      ))),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);
    ref.listen(authProvider, (previous, next) {
      //* <-- Riverpod escuchar el provider de autenticación para mostrar errores
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
      // if (previous.status == AuthStatus.loading &&
      //     next.status == AuthStatus.authenticated) {
      //   context.go('/home');
      // }
    });
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text(config.login, style: textStyles.titleLarge),
          const SizedBox(height: 90),
          CustomTextFormField(
            label: config.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: ref
                .read(loginFormProvider.notifier)
                .onEmailChanged, //* <-- Riverpod verificar el email
            errorMessage: loginForm.isFormPosted
                ? loginForm.email.errorMessage
                : null, //* <-- Mensaje de error del email
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: config.password,
            obscureText: true,
            onChanged: ref
                .read(loginFormProvider.notifier)
                .onPasswordChanged, //* <-- Riverpod verificar la contraseña
            onFieldSubmitted: (_) => ref
                .read(loginFormProvider.notifier)
                .onFormSubmit, //* <-- Riverpod verificar y ejecutar el formulario
            errorMessage: loginForm.isFormPosted
                ? loginForm.password.errorMessage
                : null, //* <-- Mensaje de error de la contraseña
          ),
          const SizedBox(height: 30),
          (loginForm.isPosting == true)
              ? const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const SizedBox.shrink(),
          (loginForm.isPosting == true)
              ? const SizedBox(height: 30)
              : const SizedBox.shrink(),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: config.enter,
                buttonColor: Colors.black,
                onPressed: loginForm.isPosting
                    ? null
                    : ref
                        .read(loginFormProvider.notifier)
                        .onFormSubmit, //* <-- Riverpod verificar y ejecutar el formulario
              )),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(config.accountNotFound),
              TextButton(
                  onPressed: () => context.push('/login/register'),
                  child: const Text(config.createAccount))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  void showSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }
}
