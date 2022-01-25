import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final colRef = FirebaseFirestore.instance.collection('test');

  // 1. RUN ON ANDROID/IOS DEVICE
  _writeDB(colRef);

  // 2. COMMENT 1.

  // 3. UNCOMMENT below AND RUN ON WEB
  //_readDB(colRef);
}

Future<void> _writeDB(CollectionReference colRef) async {
  final date = DateTime.now();
  print('Date micro: ${date.microsecondsSinceEpoch}');
  print('Date milli: ${date.millisecondsSinceEpoch}');
  final data = {
    'dateMicro':
        Timestamp.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch),
    'dateMilli':
        Timestamp.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
  };

  await Future.wait([
    colRef.doc('01').set(data),
    colRef.doc('02').set(data),
    colRef.doc('03').set(data),
    colRef.doc('04').set(data),
    colRef.doc('05').set(data),
    colRef.doc('06').set(data),
  ]);

  final doc = await colRef.doc('01').get();
  final dateMicro = (doc.get('dateMicro') as Timestamp).toDate();
  final dateMilli = (doc.get('dateMilli') as Timestamp).toDate();
  print('dateMicro: ${dateMicro.microsecondsSinceEpoch}');
  print('dateMilli: ${dateMilli.millisecondsSinceEpoch}');
  print('compare: ${dateMicro.compareTo(dateMilli)}');

  print('End');
}

Future<void> _readDB(CollectionReference colRef) async {
  final query = colRef.orderBy('dateMicro', descending: false).limit(4);
  // print("query: ${query.parameters}");

  final snap = await query.get();
  print('First Query');
  for (var element in snap.docs) {
    print(element.id);
  }

  final lastDoc = snap.docs.last;
  final query2 = query.startAfterDocument(lastDoc);
  // print("query2: ${query2.parameters}");

  final snap2 = await query2.get();
  print('Second Query');
  for (var element in snap2.docs) {
    print(element.id);
  }

  print('End');
}
