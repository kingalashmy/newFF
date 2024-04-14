// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'ListStage.dart';


class LoggedPage extends StatelessWidget {
  final Map<String, dynamic> userData; // stock 
  

  const LoggedPage({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'User Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 120,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 30),
            UserInfoTile(label: 'Nom', value: userData['nom_utilisateur']),
            UserInfoTile(label: 'Prénom', value: userData['prenom_utilisateur']),
            UserInfoTile(label: 'Email', value: userData['email']),
            UserInfoTile(label: 'Rôle', value: userData['Role']),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'NYMLINK',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Acceuil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/page1');
              },
            ),

          ListTile(
  title: Text('Liste des Stages'),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListStage(userData: userData),
      ),
    );
  },
),


            ListTile(
              title: Text('Liste des Missions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/page3');
              },
            ),
            ListTile(
              title: Text('Liste des Objectifs '),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/page4');
              },
            ),
            ListTile(
              title: Text('Liste des Realisations'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/page5');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,

              ),
            ),
          ),
        ],
      ),
    );
  }
}