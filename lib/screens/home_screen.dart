import 'package:auction/screens/auction_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'current_auctions.dart';
import 'future_auctions.dart';
import 'past_auctions.dart';
import 'auction_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final screens = [
    CurrentAuctions(),
    FutureAuctions(),
    PastAuctions(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("HomeScreenPageNEW"),
      // ),
      body: IndexedStack(index: currentIndex, children: screens)
      // Column(
      //     // children: [
      //     //   IndexedStack(index: currentIndex, children: screens),
      //     //   SizedBox(height: 40),
      //     //   ElevatedButton.icon(
      //     //       style: ElevatedButton.styleFrom(
      //     //         minimumSize: Size.fromHeight(40),
      //     //       ),
      //     //       onPressed: () => FirebaseAuth.instance.signOut(),
      //     //       icon: Icon(Icons.arrow_back, size: 32),
      //     //       label: Text('Sign Out', style: TextStyle(fontSize: 24)))
      //     // ],
      //     ),
      ,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AuctionForm()));
          },
          child: Icon(Icons.add)),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Color.fromARGB(255, 98, 98, 98),
        selectedFontSize: 16.0,
        onTap: (index) => {setState(() => currentIndex = index)},
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Current"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Future"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Past"),
          BottomNavigationBarItem(
              icon: IconButton(
                  // style: ElevatedButton.styleFrom(
                  //   minimumSize: Size.fromHeight(40),
                  // ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  icon: Icon(Icons.arrow_back),
                  tooltip: 'Sign Out'),
              label: "SignOut")
        ],
      ),
    );
  }
}
