import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../resuable_widgets/list_item_widgets.dart';

class PastAuctions extends StatelessWidget {
  const PastAuctions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Auctions"),
      ),
      body: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 5)).asyncMap((event) async {
          QuerySnapshot toRtnSnapshot = await FirebaseFirestore.instance
              .collection('auction_items')
              .orderBy("timestamp", descending: false)
              .where("timestamp",
                  isLessThan: Timestamp.fromDate(
                      DateTime.now().subtract(const Duration(minutes: 30))))
              .get();
          return toRtnSnapshot;
        }),
        builder: (context, AsyncSnapshot snapshot) {
          List<Widget> currentAuctionItems = []; // for storing listview items
          if (snapshot.hasData) {
            snapshot.data!.docs.forEach((value) => {
                  currentAuctionItems.add(ListItemWidget(
                      id: value.id,
                      title: value["title"],
                      bidPrice: value["bidPrice"],
                      sellerEmail: value["seller"],
                      description: value["description"],
                      imageURL: value["imageURL"],
                      date: value["timestamp"].toDate().toLocal(),
                      bidderEmail: value["bidder"]))
                });
            return currentAuctionItems.isNotEmpty
                ? ListView(
                    children: currentAuctionItems,
                  )
                : const Center(
                    child: Text("No Items"),
                  );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
