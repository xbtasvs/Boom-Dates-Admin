import 'package:dating_app_dashboard/constants/constants.dart';
import 'package:dating_app_dashboard/dialogs/common_dialogs.dart';
import 'package:dating_app_dashboard/models/app_model.dart';
import 'package:dating_app_dashboard/widgets/default_card_border.dart';
import 'package:dating_app_dashboard/widgets/show_scaffold_msg.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class InAppPurchases extends StatefulWidget {
  @override
  _InAppPurchasesState createState() => _InAppPurchasesState();
}

class _InAppPurchasesState extends State<InAppPurchases> {
  // Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _subscriptionIdController = TextEditingController();

  /// Add/Update Subscription ID in database
  void _updateSubscriptionID(
      {required String action, String? subsID, int? index}) {
    // Get Subscription IDs
    final List<String> subscriptionIDs = AppModel().appInfo!.subscriptionIds;
    String text = "";

    // Check action
    if (action == 'remove') {
      // Add subscription id
      subscriptionIDs.remove(subscriptionIDs[index!]);
      text = "Removed";
    } else {
      // Add subscription id
      subscriptionIDs.add(subsID!);
      text = "Added";
    }
    // Save/Update subscription List
    AppModel().updateAppData(
        data: {STORE_SUBSCRIPTION_IDS: subscriptionIDs}).then((_) {
      // Show success message
      showScaffoldMessage(
          context: context,
          scaffoldkey: _scaffoldKey,
          message: "Subscription ID $text successfully!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("In-App Purchases")),
      body: ScopedModelDescendant<AppModel>(builder: (context, child, model) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("VIP Subscriptions",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Add Google Play / Apple Store Subscription IDs",
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            // Add product input
            _addProductInput(),
            // Show Subscription IDs
            _showVipSubscriptionIds()
          ],
        );
      }),
    );
  }

  Widget _addProductInput() {
    return Container(
      width: 380,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _subscriptionIdController,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.monetization_on),
              contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              hintText: "Add Subscription ID",
              suffixIcon: Padding(
                padding: const EdgeInsets.all(5),
                child: InkWell(
                  child: CircleAvatar(
                    child: Icon(Icons.add, color: Colors.white),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    /// Validate form
                    if (_formKey.currentState!.validate()) {
                      // Save subscription ID
                      _updateSubscriptionID(
                        action: 'add',
                        subsID: _subscriptionIdController.text.trim(),
                      );
                      // Clear input
                      _subscriptionIdController.clear();
                    }
                  },
                ),
              )),
          validator: (text) {
            // Basic validation
            if (text?.isEmpty ?? true) {
              return "Please enter subscription id";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _showVipSubscriptionIds() {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            elevation: 10.0,
            shape: defaultCardBorder(),
            child: AppModel().appInfo!.subscriptionIds.isEmpty
                ? Center(
                    child: Text("No Subscription ID found!",
                        style: TextStyle(fontSize: 18)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 15),
                    separatorBuilder: (context, index) => Divider(thickness: 1),
                    itemCount: AppModel().appInfo!.subscriptionIds.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          leading: Image.asset(
                              'assets/images/crow_badge_small.png',
                              width: 50,
                              height: 50),
                          title: Text(AppModel().appInfo!.subscriptionIds[index],
                              style: TextStyle(fontSize: 18)),
                          trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Confirm dialog
                                confirmDialog(context,
                                    message:
                                        'The subscription ID will be deleted!',
                                    negativeAction: () =>
                                        Navigator.of(context).pop(),
                                    positiveText: 'DELETE',
                                    positiveAction: () {
                                      // Delete subscription ID
                                      _updateSubscriptionID(
                                        action: 'remove',
                                        index: index,
                                      );
                                      // close dialog
                                      Navigator.of(context).pop();
                                    });
                              }));
                    }),
          ),
        ),
      ),
    );
  }
}
