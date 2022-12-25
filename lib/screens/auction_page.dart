import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuctionPage extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String imageURL;
  final String sellerEmail;
  final DateTime date;
  final String bidderEmail;
  final bidPrice;
  const AuctionPage(
      {Key? key,
      required this.id,
      required this.title,
      required this.sellerEmail,
      required this.description,
      required this.imageURL,
      required this.date,
      required this.bidderEmail,
      required this.bidPrice})
      : super(key: key);

  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool isVisible = true;

    final String id = widget.id;
    final String title = widget.title;
    final String description = widget.description;
    final String imageURL = widget.imageURL;
    final String sellerEmail = widget.sellerEmail;
    final DateTime date = widget.date;
    final String formattedDate = DateFormat.yMd().format(date);
    final String formattedTime = DateFormat.jm().format(date);

    final DateTime currentDateTime = DateTime.now();
    final String formattedCurrentDate =
        DateFormat.yMd().format(currentDateTime);
    final String formattedCurrentTime = DateFormat.jm().format(currentDateTime);

    final String bidderEmail = widget.bidderEmail;
    final bidPrice = widget.bidPrice;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auction Page'),
      ),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                padding: const EdgeInsets.all(20),
                // color: Colors.amberAccent,
                child: Text(
                  "Title: $title",
                  style: const TextStyle(fontSize: 20),
                )),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                padding: const EdgeInsets.all(20),
                // color: Colors.amberAccent,
                child: Text(
                  "Seller Email: $sellerEmail",
                  style: const TextStyle(fontSize: 20),
                )),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: screenHeight * 0.35,
              width: screenWidth * 0.95,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageURL),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Visibility(
                visible: currentDateTime.compareTo(date) >= 0 &&
                        currentDateTime
                                .subtract(const Duration(minutes: 30))
                                .compareTo(date) <=
                            0
                    ? true
                    : false,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    // color: Colors.amberAccent,
                    child: Text(
                      "Bidder Email: $bidderEmail",
                      style: const TextStyle(fontSize: 20),
                    ))),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Visibility(
                visible: currentDateTime.compareTo(date) >= 0 &&
                        currentDateTime
                                .subtract(const Duration(minutes: 30))
                                .compareTo(date) <=
                            0
                    ? true
                    : false,
                child: Container(
                    padding: const EdgeInsets.all(12),
                    // color: Colors.amberAccent,
                    child: Text(
                      "Current Bid Price: $bidPrice",
                      style: const TextStyle(fontSize: 20),
                    ))),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Visibility(
                visible: true,
                child: Container(
                    padding: const EdgeInsets.all(12),
                    // color: Colors.amberAccent,
                    child: Text(
                      "Auction Start Time: $formattedDate at $formattedTime",
                      style: const TextStyle(fontSize: 20),
                    ))),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Visibility(
                visible: currentDateTime
                            .subtract(const Duration(minutes: 30))
                            .compareTo(date) >
                        0
                    ? true
                    : false,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    // color: Colors.amberAccent,
                    child: Text(
                      "Bidder Email: $bidderEmail",
                      style: const TextStyle(fontSize: 20),
                    ))),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Visibility(
                visible: currentDateTime
                            .subtract(const Duration(minutes: 30))
                            .compareTo(date) >
                        0
                    ? true
                    : false,
                child: Container(
                    padding: const EdgeInsets.all(12),
                    // color: Colors.amberAccent,
                    child: Text(
                      "Bid Price: $bidPrice",
                      style: const TextStyle(fontSize: 20),
                    ))),
          ]),
          Visibility(
            visible: currentDateTime.compareTo(date) >= 0 &&
                    currentDateTime
                            .subtract(const Duration(minutes: 30))
                            .compareTo(date) <=
                        0
                ? true
                : false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: "btn1",
                    onPressed: () => placeBid(context, 100, bidPrice, id),
                    label: const Text(
                      " 100",
                      style: TextStyle(fontSize: 18),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  FloatingActionButton.extended(
                    heroTag: "btn2",
                    onPressed: () => placeBid(context, 500, bidPrice, id),
                    label: const Text(
                      " 500",
                      style:  TextStyle(fontSize: 18),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  FloatingActionButton.extended(
                    heroTag: "btn3",
                    onPressed: () => placeBid(context, 1000, bidPrice, id),
                    label: const Text(
                      " 1000",
                      style: TextStyle(fontSize: 18),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<int> placeBid(BuildContext context, int bidIncrement,
    int currentBidPrice, String itemId) async {
  final docRef =
      FirebaseFirestore.instance.collection("auction_items").doc(itemId);
  await FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot documentSnapshot = await transaction.get(docRef);
    if (documentSnapshot["bidPrice"] > currentBidPrice + bidIncrement) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: const Text("You missed the shot")));
      return 0;
    }
    await transaction.update(docRef, {
      "bidPrice": currentBidPrice + bidIncrement,
      "bidder": FirebaseAuth.instance.currentUser!.email
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: const Text("Successfully placed bid")));
    return 1;
  });
  return 0;
}
