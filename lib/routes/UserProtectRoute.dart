import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProtectRoute extends StatelessWidget {
  final Widget child; 

  const UserProtectRoute({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return child;
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, "/signin");
          });
          return Container(); 
        }
      },
    );
  }
}
