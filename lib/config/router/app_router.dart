import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';

//* Se hace de esta forma por que no va a a cambiar
final goRouterProvider = Provider((ref) {
  final goRoterNotifier = ref.read(goRuterNotifierProvider);
  return GoRouter(
    initialLocation: '/splash',
    // refreshListenable debemos poner algo que este pendiente del estado de la autenticacion
    // Cuando cambien el refreshListenable se da cuenta y evalua nuevamente el redirect
    refreshListenable: goRoterNotifier,
    routes: [
      //* Primer ruta que se va a mostrar
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
    ],

    //! TODO: Bloquear si no se está autenticado de alguna manera
    redirect: (context, state) {
      final isGoingTo = state.subloc;
      final authStatus = goRoterNotifier.authStatus;

      print('Gorouter $authStatus, $isGoingTo');

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }
      if (authStatus == AuthStatus.noAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;
        return '/login';
      }
      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') return '/';
      }

      return null;
    },
  );
});
