import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contravention_routiere/aff_info_c.dart';

class InfoC extends StatefulWidget {
  final String numv;
  const InfoC({
    super.key,
    required this.numv,
  });

  @override
  _InfoCState createState() => _InfoCState();
}

class _InfoCState extends State<InfoC> {
  late String numconducteur;
  final _formKey = GlobalKey<FormState>();

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
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(170.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Informations de conducteur :",
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 58, 34, 238),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        onChanged: (value) {
                          numconducteur = value;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 9,
                        decoration: const InputDecoration(
                          labelText: 'Numéro de permis',
                          labelStyle: TextStyle(fontSize: 30.0),
                          prefixIcon: Icon(Icons.article),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le numéro de permis';
                          } else if (value.length != 9) {
                            return 'Le numéro de permis doit comporter 9 chiffres';
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 25.0),
                      ),
                      const SizedBox(height: 30.0),
                      MaterialButton(
                        height: 50,
                        minWidth: 600,
                        color: const Color.fromARGB(255, 58, 34, 238),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            infoconducteur();
                          }
                        },
                        child: const Text(
                          'Continuer',
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void infoconducteur() async {
    String? numc = numconducteur;
    var conducteurDoc = await FirebaseFirestore.instance
        .collection('conducteurs')
        .where('numéro de permis', isEqualTo: numc)
        .get();
    if (conducteurDoc.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Numéro de permis introuvable')),
      );
      return;
    }
    String conducteurid = conducteurDoc.docs.first.id;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AfficherInfoC(
          conducteurid: conducteurid,
          matricule: widget.numv,
        ),
      ),
    );
  }
}
