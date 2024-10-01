import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/FirebaseFirestoreInst.dart';
import 'package:myapp/model/Attempt.dart';
import 'package:myapp/util/AttemptConverter.dart';

class AttemptData {
  static final AttemptData _instance = AttemptData._internal();

  final FirebaseFirestore db = FirestoreInst.getInstance();

  AttemptData._internal();

  static AttemptData getInstance() {
    return _instance;
  }

  void save(Attempt attempt) async {
    try{
      Map<String,dynamic> attemptMap = AttemptConverter.convert(attempt);
      await db.collection('attempts').add(attemptMap).then(
        (value) => print('Attempt save with ID : $value.id')
      );
    }catch(error){
      print('Fail to save attempt : $error');
    }
  }

  Future<List<Attempt>> getAttemptsByUserId(String userId) async {
    List<Attempt> attempts = [];

    try{
      QuerySnapshot snapshot = await db.collection('attempts').where('userId', isEqualTo: userId).get();
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Attempt attempt = AttemptConverter.convertFromJson(data);
        attempts.add(attempt);
      });
    } catch (error) {
      print('Failed to get attempts by user ID: $error');
    }
    return attempts;
  }

  
}
