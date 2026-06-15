import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalvageDashboard extends StatelessWidget {
  const SalvageDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock Data for UI
    final List<Map<String, dynamic>> atRiskInventory = [
      {
        "name": "Lisinopril 10mg",
        "batch": "B-49281",
        "expiry": "2 Months",
        "currentProbability": "15%",
        "targetPharmacy": "Downtown Meds (4 miles)",
        "targetProbability": "88%",
        "savedRevenue": "\$320.00"
      },
      {
        "name": "Metformin 500mg",
        "batch": "M-88321",
        "expiry": "1 Month",
        "currentProbability": "5%",
        "targetPharmacy": "City Care Pharmacy (12 miles)",
        "targetProbability": "75%",
        "savedRevenue": "\$150.00"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Routing (Salvage)'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "At-Risk Inventory Transfers",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Items likely to expire before sale. Approve transfers to maximize revenue.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: atRiskInventory.length,
                itemBuilder: (context, index) {
                  final item = atRiskInventory[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item["name"],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Expires in ${item["expiry"]}",
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Batch: ${item["batch"]}"),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Current Location:"),
                                    Text("Sell Prob: ${item["currentProbability"]}", style: const TextStyle(color: Colors.red)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Icon(Icons.arrow_downward, color: Colors.grey, size: 16),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("To: ${item["targetPharmacy"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Sell Prob: ${item["targetProbability"]}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Potential Salvage: ${item["savedRevenue"]}",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                onPressed: () {
                                  Get.snackbar(
                                    'Transfer Initiated',
                                    'Logistics scheduled for ${item["targetPharmacy"]}',
                                    backgroundColor: Colors.orange.shade100,
                                  );
                                },
                                child: const Text("Approve Transfer"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
