import 'package:flutter/material.dart';
import 'package:pharmacy/services/realtime.service.dart';
import 'package:get/get.dart';
import 'dart:async';

class ProcurementDashboard extends StatefulWidget {
  const ProcurementDashboard({Key? key}) : super(key: key);

  @override
  _ProcurementDashboardState createState() => _ProcurementDashboardState();
}

class _ProcurementDashboardState extends State<ProcurementDashboard> {
  final ScrollController _scrollController = ScrollController();
  final RealtimeService _realtimeService = Get.find<RealtimeService>();
  final List<dynamic> _recommendedOrders = [];
  bool _isLoading = false;
  late StreamSubscription _realtimeSub;

  @override
  void initState() {
    super.initState();
    _loadMoreData(); // Initial load
    _realtimeSub = _realtimeService.activeProcurements.listen((data) {
      if(mounted) {
        setState(() {
          // Merge real-time items ensuring no duplicates
          for(var newOrder in data) {
            final index = _recommendedOrders.indexWhere((o) => o['name'] == newOrder['name']);
            if(index >= 0) {
              _recommendedOrders[index] = newOrder;
            } else {
              _recommendedOrders.insert(0, newOrder);
            }
          }
        });
      }
    });
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
      _recommendedOrders.addAll([
        {
          "name": "Amoxicillin 500mg - Batch ${_recommendedOrders.length + 1}",
          "supplier": "Zennex Pharma Supplies",
          "price": "\$12.50 / unit",
          "quantity": "500 boxes",
          "reason": "AI Predicts Stockout in 5 Days"
        },
        {
          "name": "Insulin Glargine - Batch ${_recommendedOrders.length + 2}",
          "supplier": "Global Meds Co.",
          "price": "\$45.00 / unit",
          "quantity": "50 vials",
          "reason": "Cold Chain Resupply"
        }
      ]);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _realtimeSub.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _scrollController,
                itemCount: _recommendedOrders.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _recommendedOrders.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final order = _recommendedOrders[index];
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
