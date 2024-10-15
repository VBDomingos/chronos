

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:project/firebaseoptions.dart';
import 'package:project/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChronosPointApp());
}