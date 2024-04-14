import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ListStage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ListStage({required this.userData});

  @override
  _ListStageState createState() => _ListStageState();
}

class _ListStageState extends State<ListStage> {
  late Database _db;

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    _db = await _initializeDatabase();
  }

  Future<Database> _initializeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'Mydb.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

 Future<void> _createDatabase(Database db, int version) async {
  await db.execute('''
    CREATE TABLE Utilisateurs (
      id INTEGER PRIMARY KEY,
      Nom_Utilisateur TEXT,
      Prenom_Utilisateur TEXT,
      Email_Inst TEXT,
      password TEXT,
      Role TEXT,
      Date_Naissance TEXT
    )
  ''');

  // Inserting example data into Utilisateurs table
  await db.execute('''
    INSERT INTO Utilisateurs (Nom_Utilisateur, Prenom_Utilisateur, Email_Inst, password, Role, Date_Naissance)
    VALUES ('John', 'Doe', 'john@example.com', 'password123', 'Etudiant', '1990-01-01')
  ''');

  await db.execute('''
    INSERT INTO Utilisateurs (Nom_Utilisateur, Prenom_Utilisateur, Email_Inst, password, Role, Date_Naissance)
    VALUES ('Jane', 'Doe', 'jane@example.com', 'password456', 'Professeur', '1995-05-05')
  ''');

  await db.execute('''
    CREATE TABLE Stages (
      id INTEGER PRIMARY KEY,
      Sujet_Stage TEXT,
      Lieu_Stage TEXT,
      Type_Stage TEXT,
      id_Professeur INTEGER REFERENCES Utilisateurs(id),
      email_Etudiant TEXT REFERENCES Utilisateurs(Email_Inst)
    )
  ''');
}


  Future<void> _insertStage(String sujet, String lieu, String type, String emailEtudiant) async {
    await _db.rawInsert('''
      INSERT INTO Stages(Sujet_Stage, Lieu_Stage, Type_Stage, id_Professeur, email_Etudiant)
      VALUES(?, ?, ?, ?, ?)
    ''', [sujet, lieu, type, widget.userData['id'], emailEtudiant]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Stages'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchStages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final stages = snapshot.data!;
            return ListView.builder(
              itemCount: stages.length,
              itemBuilder: (context, index) {
                final stage = stages[index];
                return ListTile(
                  title: Text(stage['Sujet_Stage']),
                  subtitle: Text(stage['Lieu_Stage']),
                  // Add more details as needed
                );
              },
            );
          } else {
            return Text('No stages found');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the form as a modal bottom sheet
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Titre de stage'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Lieu de stage'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Sujet de stage'),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Type de stage'),
                        value: null,
                        onChanged: (String? newValue) {
                          // Handle dropdown value change
                        },
                        items: <String>[
                          'Stage Interne',
                          'Stage Externe',
                          'Stage à distance',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      FutureBuilder<List<String>>(
                        future: _fetchEtudiantEmails(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            final etudiantEmails = snapshot.data!;
                            return DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: "L'Etudiant"),
                              value: null,
                              onChanged: (String? newValue) {
                                // Handle dropdown value change
                              },
                              items: etudiantEmails.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            );
                          } else {
                            return Text('No etudiant emails found');
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Add form submission logic
                          // Get values from form fields
                          // Call _insertStage method with form values
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchStages() async {
    return await _db.rawQuery('SELECT * FROM Stages WHERE id_Professeur = ?', [widget.userData['id']]);
  }

  Future<List<String>> _fetchEtudiantEmails() async {
    final List<Map<String, dynamic>> etudiantUsers =
        await _db.rawQuery('SELECT Email_Inst FROM Utilisateurs WHERE Role = ?', ['Etudiant']);
    return etudiantUsers.map<String>((user) => user['Email_Inst'] as String).toList();
  }
}