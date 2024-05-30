import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contravention_routiere/home_p.dart';
import 'package:flutter/material.dart';

class ContraventionPage extends StatefulWidget {
  final String nomconducteur;
  final String numconducteur;
  final String numvehicule;
  const ContraventionPage(
      {super.key,
      required this.nomconducteur,
      required this.numconducteur,
      required this.numvehicule});

  @override
  _ContraventionPageState createState() => _ContraventionPageState();
}

class _ContraventionPageState extends State<ContraventionPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedRegle = "0";
  String regleid = '';

  TextEditingController montantController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController numeroContraventionController = TextEditingController();
  TextEditingController categorieController = TextEditingController();

  Future<void> selectionneraut(String regleId) async {
    if (regleId == "0") {
      montantController.clear();
      categorieController.clear();
    } else {
      DocumentSnapshot regleDoc = await FirebaseFirestore.instance
          .collection('regles')
          .doc(regleId)
          .get();

      if (regleDoc.exists) {
        setState(() {
          montantController.text = regleDoc.get('montant').toString();
          categorieController.text = regleDoc.get('catégorie');
        });
      } else {
        montantController.clear();
        categorieController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur: La règle n\'existe pas.')),
        );
      }
    }
  }

  Future<void> addContravention() async {
    try {
      if (numeroContraventionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Erreur: Veuillez saisir le numéro de contravention.')),
        );
        return;
      }

      if (lieuController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur: Veuillez saisir le lieu.')),
        );
        return;
      }

      if (selectedRegle == "0") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur: Veuillez choisir une règle.')),
        );
        return;
      }

      String? conducteurid = await infoconducteur();
      if (conducteurid == null) {
        throw Exception("Conducteur non trouvé.");
      }

      String? vehiculeId = await infovehicule();
      if (vehiculeId == null) {
        throw Exception("Véhicule non trouvé.");
      }

      String nomContravention = '';
      if (selectedRegle != "0") {
        DocumentSnapshot regleDoc = await FirebaseFirestore.instance
            .collection('regles')
            .doc(selectedRegle)
            .get();
        if (regleDoc.exists) {
          nomContravention = regleDoc['nomR'];
        }
      }

      await FirebaseFirestore.instance.collection('contraventions').add({
        'numéro contravention': numeroContraventionController.text,
        'catégorie': categorieController.text,
        'date': selectedDate,
        'lieu': lieuController.text,
        'montant': montantController.text,
        'payee': false,
        'conducteurRef': FirebaseFirestore.instance
            .collection('conducteurs')
            .doc(conducteurid),
        'regleRef':
            FirebaseFirestore.instance.collection('regles').doc(regleid),
        'véhiculeRef':
            FirebaseFirestore.instance.collection('véhicule').doc(vehiculeId),
        'contravention': nomContravention,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contravention enregistrée avec succès!')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeBackPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<String?> infoconducteur() async {
    String? numc = widget.numconducteur;
    var conducteurDoc = await FirebaseFirestore.instance
        .collection('conducteurs')
        .where('numéro de permis', isEqualTo: numc)
        .get();
    return conducteurDoc.docs.isNotEmpty ? conducteurDoc.docs.first.id : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 58, 34, 238),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              width: constraints.maxWidth * 0.8,
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "La contravention :",
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 58, 34, 238),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'Le conducteur:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                widget.nomconducteur,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Card(
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              title: const Text(
                                'Numéro de permis de conducteur:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                widget.numconducteur,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: numeroContraventionController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Numéro contravention',
                        labelStyle: TextStyle(fontSize: 25.0),
                        prefixIcon: Icon(Icons.article),
                      ),
                      style: const TextStyle(fontSize: 25.0),
                    ),
                    const SizedBox(height: 15.0),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('regles')
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<DropdownMenuItem<String>> regleItems = [];
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          final regles = snapshot.data?.docs;
                          regleItems.add(
                            const DropdownMenuItem(
                              value: "0",
                              child: Text(
                                'Choisir une régle',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          );
                          for (var regle in regles!) {
                            regleItems.add(
                              DropdownMenuItem(
                                value: regle.id,
                                child: Text(
                                  regle['nomR'],
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ),
                            );
                          }
                        }
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          margin: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: DropdownButton<String>(
                            items: regleItems,
                            onChanged: (regleValue) {
                              setState(() {
                                selectedRegle = regleValue!;
                                regleid = regleValue;
                              });
                              selectionneraut(regleValue!);
                            },
                            value: selectedRegle,
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: categorieController,
                      decoration: const InputDecoration(
                        labelText: 'Catégorie de contravention',
                        labelStyle: TextStyle(fontSize: 25.0),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      style: const TextStyle(fontSize: 25.0),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Text(
                          'Date de contravention :',
                          style: TextStyle(fontSize: 25.0),
                        ),
                        const SizedBox(width: 10.0),
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: const TextStyle(fontSize: 25.0),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        TextButton(
                          onPressed: () => _selectTime(context),
                          child: Text(
                            '${selectedTime.hour}:${selectedTime.minute}',
                            style: const TextStyle(fontSize: 25.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: lieuController,
                      decoration: const InputDecoration(
                        labelText: 'Lieu',
                        labelStyle: TextStyle(fontSize: 25.0),
                        prefixIcon: Icon(Icons.place),
                      ),
                      style: const TextStyle(fontSize: 25.0),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: montantController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Montant',
                        labelStyle: TextStyle(fontSize: 25.0),
                        prefixIcon: Icon(Icons.money),
                      ),
                      style: const TextStyle(fontSize: 25.0),
                    ),
                    const SizedBox(height: 10.0),
                    MaterialButton(
                      height: 50,
                      minWidth: 600,
                      color: const Color.fromARGB(255, 58, 34, 238),
                      onPressed: () async {
                        await addContravention();
                      },
                      child: const Text(
                        'Enregistrer',
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<String?> infovehicule() async {
    String? matv = widget.numvehicule;
    var vehiculeDoc = await FirebaseFirestore.instance
        .collection('véhicule')
        .where('matricule', isEqualTo: matv)
        .get();
    return vehiculeDoc.docs.isNotEmpty ? vehiculeDoc.docs.first.id : null;
  }
}
