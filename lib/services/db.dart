import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';

/// All database services
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addLeaderboard(String type, int score) async {
    DocumentReference ref = _db.collection('Leaderboard').doc();
    dynamic name = await getUserName(_auth.currentUser?.uid);
    QuerySnapshot _query = await _db
        .collection('Leaderboard')
        .where('UserId', isEqualTo: _auth.currentUser?.uid)
        .where('Type', isEqualTo: type)
        .get();
    bool isFirst = await _query.docs.length == 0;
    if (isFirst) {
      await ref.set(<String, dynamic>{
        'Name': name,
        'Score': score,
        'Type': type,
        'UserId': _auth.currentUser?.uid,
      });
    } else {
      String docId = _query.docs[0].id;
      DocumentReference ref2 = await _db.collection('Leaderboard').doc(docId);
      DocumentSnapshot<Object?> _query2 = await ref2.get();
      dynamic oldScore = await _query2.get('Score');
      if (score < int.parse(oldScore.toString())) {
        await _db.collection('Leaderboard').doc(docId).update(<String, dynamic>{
          'Name': name,
          'Score': score,
          'Type': type,
          'UserId': _auth.currentUser?.uid,
        });
      }
    }
  }

  Future getUserName(String? userId) async {
    DocumentReference ref = _db.collection('Users').doc(userId);
    DocumentSnapshot<Object?> _query = await ref.get();
    return _query.get('Name');
  }

  Future signInAnon(BuildContext context, String name) async {
    try {
      UserCredential? result = await _auth.signInAnonymously();
      final user = result.user;
      await _addUser(user!.uid, name);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> _addUser(String userId, String name) async {
    DocumentReference ref = _db.collection('Users').doc(userId);
    await ref.set(<String, dynamic>{'Name': name, 'userId': userId});
  }
}

class ServerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> generateRandomKey() async {
    while (true) {
      String randomKey = randomAlphaNumeric(6).toUpperCase();
      QuerySnapshot _query = await _db.collection('Servers').where('server_key', isEqualTo: randomKey).get();
      if (_query.docs.length == 0) {
        return randomKey;
      } else {
        continue;
      }
    }
  }

  Future getUserName(String? userId) async {
    DocumentReference ref = _db.collection('Users').doc(userId);
    DocumentSnapshot<Object?> _query = await ref.get();
    return _query.get('Name');
  }

  Future<String> createLobby() async {
    DocumentReference ref = _db.collection('Servers').doc();
    var _randomKey = await generateRandomKey();
    dynamic _userName = await getUserName(_auth.currentUser!.uid);
    await ref.set({
      'id': ref.id,
      'key': _randomKey,
      'difficulty': 'medium',
      'hostId': _auth.currentUser!.uid,
      'hostName': _userName.toString(),
      'guestName': '',
      'host_puzzle': 0,
      'guest_puzzle': 0,
      'host_finnished': false,
      'guest_finnished': false,
      'host_moves': 0,
      'guest_moves': 0,
      'host_correct': 0,
      'guest_correct': 0,
      'started': false
    });
    return _randomKey;
  }

  Future<String> joinLobby(String serverKey, String username) async {
    QuerySnapshot _query = await _db.collection('Servers').where('key', isEqualTo: serverKey).get();
    if (_query.docs.length == 0) {
      return 'none';
    } else {
      if (_query.docs[0].get('guestName') != null) {
        return 'many';
      } else {
        addPlayerToServer(_query.docs[0].id, username);
        return _query.docs[0].id;
      }
    }
  }

  Future<void> addPlayerToServer(String id, String username) async {
    await _db.collection('Servers').doc(id).update({'guestName': username});
  }

  Future<void> startGame(String id) async {
    await _db.collection('Servers').doc(id).update({'started': true});
  }

  Future<void> changeParameter(String id, String change, dynamic value) async {
    await _db.collection('Servers').doc(id).update({change: value});
  }
}
