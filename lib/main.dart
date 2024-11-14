import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:project/firebaseoptions.dart';
import 'package:project/models/adm_model.dart';
import 'package:project/models/companyWorkingPattern.dart';
import 'package:project/models/userPoint.dart';
import 'package:project/models/usermodel.dart';
import 'package:project/views/app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CompanyWorkingPatternModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserPointModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdmModel(),
        ),
      ],
      child: ChronosPointApp(),
    ),
  );
}
