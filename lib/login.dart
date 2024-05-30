import 'package:contravention_routiere/home_p.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const WelcomeBackPage(),
        ),
      );
    } catch (e) {
      print('Login failed: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Erreur de connexion',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 58, 34, 238),
            ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Nom d\'utilisateur ou mot de passe incorrect, ou les champs sont vides.',
            style: TextStyle(
              fontSize: 20.0,
              color: Color.fromARGB(255, 4, 4, 5),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 2, 2, 2),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color.fromARGB(255, 58, 34, 238),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(40.0),
            child: Card(
              elevation: 250,
              child: Padding(
                padding: const EdgeInsets.all(140.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Connexion :",
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 58, 34, 238),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Adresse Email',
                        labelStyle: TextStyle(fontSize: 30.0),
                        prefixIcon: Icon(Icons.email),
                      ),
                      style: const TextStyle(fontSize: 25.0),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        labelStyle: TextStyle(fontSize: 25.0),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      style: const TextStyle(fontSize: 25.0),
                    ),
                    const SizedBox(height: 40.0),
                    SizedBox(
                      width: 600,
                      child: MaterialButton(
                        onPressed: login,
                        height: 50,
                        color: const Color.fromARGB(255, 58, 34, 238),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
