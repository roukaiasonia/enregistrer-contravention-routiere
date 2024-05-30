import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contravention_routiere/aff_info_v.dart';

class InfoV extends StatefulWidget {
  const InfoV({Key? key}) : super(key: key);

  @override
  _InfoVState createState() => _InfoVState();
}

class _InfoVState extends State<InfoV> {
  final _formKey = GlobalKey<FormState>();
  late String numvehicule;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 58, 34, 238),
        title: const Text(''),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(170.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Informations de véhicule :",
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 58, 34, 238),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          numvehicule = value;
                        },
                        maxLength: 11,
                        decoration: const InputDecoration(
                          labelText: 'Entrer le numéro de plaque',
                          labelStyle: TextStyle(fontSize: 30.0),
                          prefixIcon: Icon(Icons.directions_car),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le numéro de plaque';
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 25.0),
                      ),
                      const SizedBox(height: 30.0),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 500,
                          child: MaterialButton(
                            height: 50,
                            color: const Color.fromARGB(255, 58, 34, 238),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                infovehicule();
                              }
                            },
                            child: const Text(
                              'Continuer',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.0),
                            ),
                          ),
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

  void infovehicule() async {
    String? matve = numvehicule;
    var vehiculeDoc = await FirebaseFirestore.instance
        .collection('véhicule')
        .where('matricule', isEqualTo: matve)
        .get();
    if (vehiculeDoc.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Numéro de plaque introuvable')),
      );
      return;
    }
    String vehiculesid = vehiculeDoc.docs.first.id;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AfficherInfoV(vehiculesid: vehiculesid),
      ),
    );
  }
}
