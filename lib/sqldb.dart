import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class SqlDb{
  static Database? _db;
  Future<Database?> get db async{
    if(_db == null){
      _db = await intialDb();
      return _db;
    }
    else{
      return _db;
    }
  }

  intialDb() async{
    String databasepath = await getDatabasesPath();
    // ignore: await_only_futures
    String path = await join(databasepath , 'Mydb.db');
    Database mydb = await openDatabase(path , onCreate: _onCreate , version: 5 , onUpgrade: _onUpgrade);
    return mydb;
  }

  // if we wanna update something after the initalizing of our database, it cannot be possible until we delete it or making some wrong decision
  // then the best solution will be the onUpgrade function that will update our database with a new version

  _onUpgrade(Database db , int oldVersion , int newVersion){

    // ignore: avoid_print
    print("OnUpgrade------------");

  }


  _onCreate(Database db , int version) async{

    await db.execute('''

    CREATE TABLE "Utilisateurs" (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
      nom_utilisateur TEXT NOT NULL,
      prenom_utilisateur TEXT NOT NULL,
      email TEXT NOT NULL,
      Role TEXT NOT NULL,
      password TEXT
    )
    ''');
     await db.execute('''
    INSERT INTO Utilisateurs (Nom_Utilisateur, Prenom_Utilisateur, Email_Inst, password, Role, Date_Naissance)
    VALUES ('John', 'Doe', 'john@example.com', 'password123', 'Etudiant', '1990-01-01')
  ''');

  await db.execute('''
    INSERT INTO Utilisateurs (Nom_Utilisateur, Prenom_Utilisateur, Email_Inst, password, Role, Date_Naissance)
    VALUES ('Jane', 'Doe', 'jane@example.com', 'password456', 'Professeur', '1995-05-05')
  ''');
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

  await db.execute('''
    CREATE TABLE Stages (
      id INTEGER PRIMARY KEY,
      Sujet_Stage TEXT,
      Lieu_Stage TEXT,
      Type_Stage TEXT,
      id_Professeur INTEGER REFERENCES Utilisateurs(id)
      email_Etudiant INTEGER REFERENCES Utilisateurs(Email_Inst)
    )
  ''');

  //  table missions 
await db.execute('''

  CREATE TABLE Missions (
      id INTEGER PRIMARY KEY,
      Titre_Mission TEXT,
      Etat_Mission TEXT,
      Date_Debut_Mission TEXT,
      Date_Fin_Mission TEXT,
      id_Stage INTEGER REFERENCES Stages(id)
    )
  ''');


  //  table objectifs 

   await db.execute('''
    CREATE TABLE Objectifs (
      id INTEGER PRIMARY KEY,
      Text_Objectif TEXT,
      id_Stage INTEGER REFERENCES Stages(id)
    )
  ''');

  // table realisations 

  await db.execute('''
    CREATE TABLE Realisations (
      id INTEGER PRIMARY KEY,
      Date_Realisation TEXT,
      Remarque TEXT,
      id_Mission INTEGER REFERENCES Missions(id)
    )
  ''');

    // ignore: avoid_print
    print("DATABASE AND TABLE HAS BEEN CREATED!");

  }

  readData(String sql) async{
    Database? mydb = await db;
    // error possible : The method 'rawQuery' can't be unconditionally invoked because the receiver can be 'null'.
    // solution : mydb! : we assure you bro that's not gonna be null even if it can be  (Database? mydb)
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }
    insertData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }
    updateData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }
    deleteData(String sql) async{
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }


  // methode pour la login 

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
  Database? mydb = await db;

  // Exécuter une requête pour récupérer l'utilisateur avec l'e-mail donné
  List<Map<String, dynamic>> users = await mydb!.rawQuery(
    'SELECT * FROM Utilisateurs WHERE email = ? LIMIT 1', 
    [email]
  );

  // Vérifier s'il y a un utilisateur avec cet e-mail
  if (users.isNotEmpty) {
    // Récupérer le premier utilisateur trouvé (il ne devrait y en avoir qu'un en raison de LIMIT 1)
    Map<String, dynamic> user = users.first;

    // Vérifier si le mot de passe correspond
    if (user['password'] == password) {
      // Le mot de passe est correct, retourner les informations de l'utilisateur
      return user;
    }
  }

  // Aucun utilisateur trouvé avec cet e-mail ou mot de passe incorrect
  return null;
}




}