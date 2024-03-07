import 'package:flutter/material.dart';

class CheckAuthStatusScreen extends StatelessWidget {
  const CheckAuthStatusScreen({super.key});
//class CheckAuthStatusScreen extends ConsumerWidget {
  //const CheckAuthStatusScreen({super.key});

  @override
  //Widget build(BuildContext context, WidgetRef ref) {
  Widget build(BuildContext context) {
    //ref.listen(authProvider, (previous, next) {
    //  next;
    //  context.go('/');
    //});
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
