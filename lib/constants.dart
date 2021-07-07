import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// is SignIn or SignUp ? StateProvider
final showPageStateProvider = StateProvider<bool>((ref) => true);

// username StateProvider
final myNameStateProvider = StateProvider<String?>((ref) => null);

// loading StateProvider
final loadingStateProvider = StateProvider<bool>((ref) => false);

// snapshot StateProvider in searchList
final searchSnapshotStateProvider = StateProvider<QuerySnapshot?>((ref) => null);

// roomId StateProvider
final roomIdStateProvider = StateProvider<String?>((_) => null);

// message snapshot StateProvider
