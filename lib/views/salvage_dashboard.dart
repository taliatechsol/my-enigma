import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalvageDashboard extends StatefulWidget {
  const SalvageDashboard({Key? key}) : super(key: key);

  @override
  _SalvageDashboardState createState() => _SalvageDashboardState();
}

class _SalvageDashboardState extends State<SalvageDashboard> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _atRiskInventory = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMoreData(); // Initial load
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // Mock network delay
    await Future.delayed(const Duration(seconds: 1));

    // Append mock data
    setState(() {
      _atRiskInventory.addAll([
        {
          "name": "Lisinopril 10mg - Batch ${_atRiskInventory.length + 1}",
          "batch": "B-${49281 + _atRiskInventory.length}",
          "expiry": "2 Months",
          "currentProbability": "15%",
          "targetPharmacy": "Downtown Meds (4 miles)",
          "targetProbability": "88%",
          "savedRevenue": "\$320.00"
        },
        {
          "name": "Metformin 500mg - Batch ${_atRiskInventory.length + 2}",
          "batch": "M-${88321 + _atRiskInventory.length}",
          "expiry": "1 Month",
          "currentProbability": "5%",
          "targetPharmacy": "City Care Pharmacy (12 miles)",
          "targetProbability": "75%",
          "savedRevenue": "\$150.00"
        }
      ]);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _scrollController,
                itemCount: _atRiskInventory.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _atRiskInventory.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final item = _atRiskInventory[index];
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
