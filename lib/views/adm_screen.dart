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
  late Future<void> _fetchUsersFuture;

  @override
  void initState() {
    super.initState();
    final userModel = Provider.of<UserModel>(context, listen: false);
    final admModel = Provider.of<AdmModel>(context, listen: false);

    // Assign fetchUsersByCompanyId to a future that will be used in FutureBuilder
    _fetchUsersFuture = admModel.fetchUsersByCompanyId(userModel.companyId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final admModel = Provider.of<AdmModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(false),
      body: FutureBuilder<void>(
        future: _fetchUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading users.'));
          } else {
            final userNames = admModel.getUserNames();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DayoftheweekIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      "Employees in your company:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...userNames.map((name) {
                      return GestureDetector(
                        onTap: () {
                          print("Tapped on $name");
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.more_vert, color: Colors.grey[600]),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
