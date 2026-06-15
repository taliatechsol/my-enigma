// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class dashboard extends StatelessWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome to My Enigma", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.local_shipping),
                label: const Text("Procurement Dashboard"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                onPressed: () {
                  Get.toNamed('/procurement');
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text("Salvage / Dynamic Routing"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                onPressed: () {
                  Get.toNamed('/salvage');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
