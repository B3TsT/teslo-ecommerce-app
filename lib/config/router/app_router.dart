import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider(
  (ref) {
    guardRoute(AuthStatus authStatus, String redirectPath) {
      if (authStatus == AuthStatus.notAuthenticated) {
        return redirectPath;
      }
      return null;
    }

    final goRouterNotifier = ref.read(goRouterNotifierProvider);

    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: goRouterNotifier,
      routes: [
        //* primera pantalla
        GoRoute(
          path: '/splash',
          builder: (context, state) => const CheckAuthStatusScreen(),
          redirect: (context, state) =>
              guardRoute(goRouterNotifier.authStatus, '/login'),
        ),

        ///* Auth Routes
        GoRoute(
            path: '/login',
            builder: (context, state) => const LoginScreen(),
            routes: [
              GoRoute(
                path: 'register',
                builder: (context, state) => const RegisterScreen(),
              ),
            ]),

        ///* Product Routes
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductsScreen(),
          redirect: (context, state) {
            return guardRoute(goRouterNotifier.authStatus, '/login');
          },
        ),
        GoRoute(
            path: '/products/:id',
            builder: (context, state) => ProductScreen(
                  productId: state.params['id'] ?? 'no-id',
                ),
            redirect: (context, state) =>
                guardRoute(goRouterNotifier.authStatus, '/login')),
      ],

      ///*  Bloquear si no se está autenticado de alguna manera
      redirect: (context, state) {
        final isGoingTo = state.subloc;
        final authStatus = goRouterNotifier.authStatus;

        if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
          return null; //*  <-- El splash seguira mostrandose si el estado aun no esta determinado
        }

        if (authStatus == AuthStatus.notAuthenticated) {
          if (isGoingTo == '/login' || isGoingTo == '/register') return null;
          // return '/login';
        }

        if (authStatus == AuthStatus.authenticated) {
          if (isGoingTo == '/login' ||
              isGoingTo == '/register' ||
              isGoingTo == '/splash') return '/';
        }

        return null;
      },
    );
  },
);

// final appRouter = GoRouter(
//   initialLocation: '/splash',
//   routes: [
//     //* primera pantalla
//     GoRoute(
//       path: '/splash',
//       builder: (context, state) => const CheckAuthStatusScreen(),
//     ),

//     ///* Auth Routes
//     GoRoute(
//       path: '/login',
//       builder: (context, state) => const LoginScreen(),
//     ),
//     GoRoute(
//       path: '/register',
//       builder: (context, state) => const RegisterScreen(),
//     ),

//     ///* Product Routes
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const ProductsScreen(),
//     ),
//   ],

//   ///! TODO: Bloquear si no se está autenticado de alguna manera
// );
