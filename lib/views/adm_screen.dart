import 'package:flutter/material.dart';
import 'package:project/models/userPoint.dart';
import 'package:project/models/usermodel.dart';
import 'package:provider/provider.dart';
import '../widgets/dotw_indicator.dart';
import '../widgets/header.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:project/models/adm_model.dart';

class AdmScreen extends StatefulWidget {
  AdmScreen({super.key});

  @override
  _AdmScreenState createState() => _AdmScreenState();
}

class _AdmScreenState extends State<AdmScreen> {
  @override
  Widget build(BuildContext context) {
    // final workingPattern = Provider.of<CompanyWorkingPatternModel>(context);
    final userModel = Provider.of<UserModel>(context);
    final admModel = Provider.of<AdmModel>(context);
    final userNames = admModel.getUserNames();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DayoftheweekIndicator(),

              const SizedBox(height: 20),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Employees in your company:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...userNames.map((name) => Text(
                          name,
                          style: TextStyle(fontSize: 14),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
