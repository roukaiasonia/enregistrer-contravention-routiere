import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contravention_routiere/contraventionpage.dart';
import 'package:intl/intl.dart';

class AfficherInfoC extends StatefulWidget {
  final String conducteurid;
  final String matricule;
  const AfficherInfoC({
    Key? key,
    required this.conducteurid,
    required this.matricule,
  }) : super(key: key);

  @override
  _AfficherInfoCState createState() => _AfficherInfoCState();
}

class _AfficherInfoCState extends State<AfficherInfoC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color.fromARGB(255, 58, 34, 238),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('conducteurs')
            .doc(widget.conducteurid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text("Erreur lors du chargement des données"));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: Text("Aucune information trouvée pour ce conducteur"));
          }

          var data = snapshot.data!;
          String nom = data['nom'];
          String numPermis = data['numéro de permis'];
          String typep = data['type de permis'];
          String numtel = data['numéro de téléphone'];
          Timestamp datecre = data['date de création de permis'];
          Timestamp datefin = data['date de fin de permis'];
          DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

          String formattedDatecre = dateFormat.format(datecre.toDate());
          String formattedDatefin = dateFormat.format(datefin.toDate());

          return Center(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: 15.0),
                    Card(
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        title: const Text(
                          'Nom du conducteur',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          nom,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        title: const Text(
                          'Numéro de permis',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          numPermis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        title: const Text(
                          'Type de permis',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          typep,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        title: const Text(
                          'Numéro de téléphone',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          numtel,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        title: const Text(
                          'Date de création de permis',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          formattedDatecre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        title: const Text(
                          'Date de fin de permis',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          formattedDatefin,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    MaterialButton(
                      height: 50,
                      minWidth: 600,
                      color: const Color.fromARGB(255, 58, 34, 238),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ContraventionPage(
                              nomconducteur: nom,
                              numconducteur: numPermis,
                              numvehicule: widget.matricule,
                            ),
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
            ),
          );
        },
      ),
    );
  }
}
