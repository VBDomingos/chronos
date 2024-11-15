import 'package:flutter/material.dart';
import 'package:project/models/userPoint.dart';
import 'package:project/views/history.dart';
import '../widgets/circular_progress_painter.dart';
import '../widgets/dotw_indicator.dart';
import '../widgets/header.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:project/models/adm_model.dart';
import 'package:project/models/usermodel.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  Map<String, bool> _expanded = {};
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  @override
  void initState() {
    super.initState();
    _initializeData(); // Chama a função assíncrona
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<void> _initializeData() async {
    final admModel = Provider.of<AdmModel>(context, listen: false);

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _onEyeIconPressed(Map<String, dynamic> user) {
    final userModel = UserModel.fromMap(user);

    Provider.of<UserPointModel>(context, listen: false).userFilter = userModel;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(),
        settings: const RouteSettings(name: 'HistoryScreen'),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admModel = Provider.of<AdmModel>(context);
    final userNames = admModel.getUserNames();
    final companyUsers = admModel.companyUsers;

    final filteredUserNames = userNames
        .where(
            (name) => name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DayoftheweekIndicator(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomCircularProgress(
                    workingCount: admModel.workingCount ?? 0,
                    totalEmployees: admModel.companyUsers.length,
                  ),
                  const SizedBox(width: 30.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBox('Trabalhando', Colors.green),
                      SizedBox(height: 9),
                      _buildStatusBox('Em Falta', Colors.red),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryBox(
                      'Trabalhando', Colors.green, '${admModel.workingCount}'),
                  _buildSummaryBox(
                      'Em Falta', Colors.red, '${admModel.lateCount}'),
                ],
              ),
              const SizedBox(height: 24.0),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Buscar Funcionário',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Column(
                children: [
                  ...filteredUserNames.map((name) {
                    final user = companyUsers.firstWhere(
                      (user) => user['name'] == name,
                      orElse: () => {},
                    );

                    bool isExpanded = _expanded[name] ?? false;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _expanded[name] = !isExpanded;
                        });
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          height: isExpanded ? 120 : 55,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    user['isWorking'] == true
                                        ? 'Trabalhando'
                                        : 'Em Falta',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: user['isWorking'] == true
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              if (isExpanded) ...[
                                const Divider(
                                  color: Colors.grey,
                                  height: 20,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Email: ${user['email'] ?? 'Unknown'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700]),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          _onEyeIconPressed(user);
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.grey[700],
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _buildStatusBox(String label, Color color) {
    return Container(
      width: 100,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color, width: 2.0),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSummaryBox(String label, Color color, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SummaryBox(color: color, value: value),
      ],
    );
  }
}

class SummaryBox extends StatelessWidget {
  final Color color;
  final String value;

  const SummaryBox({super.key, required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color, width: 2.0),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
