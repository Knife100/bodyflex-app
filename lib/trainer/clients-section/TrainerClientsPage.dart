import 'package:flutter/material.dart';
import 'package:flutter_application_gym/clients-section/ClientsPage.dart';

class TrainerClientsPage extends StatelessWidget {
  const TrainerClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClientsPage(userType: "trainer");
  }
}
