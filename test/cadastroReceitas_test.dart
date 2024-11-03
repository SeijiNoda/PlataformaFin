import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/pages/cadastroReceitas.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  MockFirestore instance;
  MockDocumentSnapshot mockDocumentSnapshot;
  MockCollectionReference mockCollectionReference;
  MockDocumentReference mockDocumentReference;

  setUp(() {
    instance = MockFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
  });
  
  test('should return data when the call to remote source is successful.', () async {
    when(instance.collection(any)).thenReturn(mockCollectionReference);
	  when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
		when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
		when(mockDocumentSnapshot.data()).thenReturn(responseMap);
		//act
		final result = await remoteDataSource.getData('user_id');
		//assert
		expect(result, userModel); //userModel is a object that is defined. Replace with you own model class object.
  });
}