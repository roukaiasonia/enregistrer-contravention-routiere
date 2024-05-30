import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:contravention_routiere/info_c.dart';

class AfficherInfoV extends StatefulWidget {
  final String vehiculesid;

  const AfficherInfoV({Key? key, required this.vehiculesid}) : super(key: key);

  @override
  _AfficherInfoVState createState() => _AfficherInfoVState();
}

class _AfficherInfoVState extends State<AfficherInfoV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color.fromARGB(255, 58, 34, 238),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('véhicule')
                .doc(widget.vehiculesid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("Erreur lors du chargement des données");
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text(
                    "Aucune information trouvée pour ce véhicule");
              }

              var data = snapshot.data!;
              String marque = data['marque'];
              String modele = data['modèle'];
              String categorie = data['catégorie'];
              String sachet = data['numéro de sachet'];
              String prop = data['le propriétaire'];
              String matv = data['matricule'];
              Timestamp datecass = data['date de création de l\'assurance'];
              Timestamp datefass = data['date fin de l\'assurance'];
              Timestamp datecsc = data['la date de scanner de véhicule'];
              Timestamp datefsc = data['la date fin de scanner de véhicule'];
              DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
              String formattedDatecass = dateFormat.format(datecass.toDate());
              String formattedDatefass = dateFormat.format(datefass.toDate());
              String formattedDatecsc = dateFormat.format(datecsc.toDate());
              String formattedDatefsc = dateFormat.format(datefsc.toDate());

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Informations du véhicule :",
                        style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 58, 34, 238)),
                      ),
                      const SizedBox(height: 20),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'Le propriétaire de véhicule',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                prop,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'Marque du véhicule',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                marque,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'Modèle du véhicule',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                modele,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'Catégorie du véhicule',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                categorie,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'Matricule du véhicule',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                matv,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'Le numéro de sachet ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                sachet,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'La date de création de l\'assurance',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                formattedDatecass,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'La date fin de l\'assurance',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                formattedDatefass,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'La date de création de scanner ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                formattedDatecsc,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'La date fin de scanner',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                formattedDatefsc,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        height: 50,
                        minWidth: 600,
                        color: const Color.fromARGB(255, 58, 34, 238),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoC(numv: matv),
                            ),
                          );
                        },
                        child: const Text(
                          'Continuer',
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
