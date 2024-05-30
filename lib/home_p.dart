import 'package:contravention_routiere/info_v.dart';
import 'package:contravention_routiere/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeBackPage extends StatelessWidget {
  const WelcomeBackPage({Key? key}) : super(key: key);

  void signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: const Icon(Icons.logout),
            color: Colors.white,
            iconSize: 45.0,
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 58, 34, 238),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/police.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 50.0),
              const Text(
                " C'est un plaisir de vous accueillir à nouveau !",
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              const Text(
                " Pour établir la contravention, il vous suffit de cliquer sur",
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              const Text(
                " le bouton ci-dessous.",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const InfoV()),
                  );
                },
                color: const Color.fromARGB(255, 58, 34, 238),
                textColor: Colors.white,
                height: 50,
                minWidth: 600,
                child: const Text(
                  'Écrire',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
