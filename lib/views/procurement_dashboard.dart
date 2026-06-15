import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProcurementDashboard extends StatelessWidget {
  const ProcurementDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock Data for UI
    final List<Map<String, dynamic>> recommendedOrders = [
      {
        "name": "Amoxicillin 500mg",
        "supplier": "Zennex Pharma Supplies",
        "price": "\$12.50 / unit",
        "quantity": "500 boxes",
        "reason": "AI Predicts Stockout in 5 Days"
      },
      {
        "name": "Insulin Glargine",
        "supplier": "Global Meds Co.",
        "price": "\$45.00 / unit",
        "quantity": "50 vials",
        "reason": "Cold Chain Resupply"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Procurement'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AI Recommended Orders",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: recommendedOrders.length,
                itemBuilder: (context, index) {
                  final order = recommendedOrders[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order["name"],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text("Supplier: ${order["supplier"]}"),
                          Text("Recommended Qty: ${order["quantity"]}"),
                          Text("Price: ${order["price"]}"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                order["reason"],
                                style: const TextStyle(
                                    color: Colors.blue, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  Get.snackbar('Action', 'Order Modified');
                                },
                                child: const Text("Edit"),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  Get.snackbar(
                                    'Procurement Successful',
                                    'PO sent to ${order["supplier"]}',
                                    backgroundColor: Colors.green.shade100,
                                  );
                                },
                                child: const Text("1-Click Procure"),
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
