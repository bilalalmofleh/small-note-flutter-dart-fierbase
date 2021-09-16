
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:small_note/provider/google_sign_in.dart';
import 'package:small_note/widget/background_painter.dart';
import 'package:small_note/widget/sign_up_widget.dart';
import 'package:provider/provider.dart';

import '../view_all_notes.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final provider = Provider.of<GoogleSignInProvider>(context);

          if (provider.isSigningIn) {
            return buildLoading();
          } else if (snapshot.hasData) {

            return View_all_notes();
          } else {
            return SignUpWidget();
          }
        },
      ),
    ),
  );

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      CustomPaint(painter: BackgroundPainter()),
      Center(child: CircularProgressIndicator()),
    ],
  );
}