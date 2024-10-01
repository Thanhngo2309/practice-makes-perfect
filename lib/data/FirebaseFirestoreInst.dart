import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreInst {
  static final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  static FirebaseFirestore getInstance() {
    return _firestoreInstance;
  }
}