import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AuctionForm extends StatefulWidget {
  @override
  State<AuctionForm> createState() => _AuctionFormState();
}

class _AuctionFormState extends State<AuctionForm> {
  File? pickedImage;
  DateTime? pickedDate;
  TimeOfDay? pickedTimeOfDay;
  DateTime? pickedDateTime;
  String description = '';
  String title = '';

  final controller = TextEditingController();

  Future pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      final tempImg = File(pickedImage.path);
      setState(() => this.pickedImage = tempImg);
    } on Exception catch (e) {
      print('failed to create image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          pickedImage == null
              ? SizedBox(height: 10)
              : Image.file(
                  pickedImage!,
                  height: 100,
                  width: 200,
                ),
          const SizedBox(height: 10),
          buildButton(
              title: 'Pick Image',
              icon: Icons.image_outlined,
              onClick: () => pickImage()),
          const SizedBox(height: 10),
          TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Title',
              ),
              onChanged: (value) => setState(() => title = value)),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Description',
            ),
            onChanged: (value) => setState(() => description = value),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 7)));

              if (pickedDate != null) {
                pickedTimeOfDay = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (pickedTimeOfDay != null) {
                  setState(() {
                    pickedDateTime = DateTime(
                        pickedDate!.year,
                        pickedDate!.month,
                        pickedDate!.day,
                        pickedTimeOfDay!.hour,
                        pickedTimeOfDay!.minute);
                  });
                }
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.purple[900],
            ),
            child: const Text('Pick date & time for auction.'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                if (pickedImage != null) {
                  final bytes = pickedImage!.readAsBytesSync();
                  final headers = {
                    'Authorization': 'Client-ID 05833f5e5f16919'
                  };
                  final request = http.MultipartRequest(
                      'POST', Uri.parse('https://api.imgur.com/3/image'));
                  request.fields.addAll({
                    'image': base64Encode(bytes),
                  });

                  request.headers.addAll(headers);

                  http.StreamedResponse response = await request.send();

                  if (response.statusCode == 200) {
                    final resData = await response.stream.bytesToString();
                    print(resData);
                    final resBody = jsonDecode(resData);
                    print(resBody);

                    final imageURL = resBody["data"]["link"];

                    createItem(
                        description: description,
                        bidPrice: 0,
                        bidder: "",
                        imageURL: imageURL,
                        title: title,
                        seller: FirebaseAuth.instance.currentUser!.email!,
                        timestamp: Timestamp.fromDate(pickedDateTime!));

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Item added to auctions")));

                    Navigator.pop(context);
                  } else {
                    print(response.reasonPhrase);
                  }
                }
              },
              child: const Text('Submit'))
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: const Icon(Icons.add)),
    );
  }
}

Future createItem(
    {required String description,
    required int bidPrice,
    required String bidder,
    required String imageURL,
    required String title,
    required String seller,
    required Timestamp timestamp}) async {
  final docUser = FirebaseFirestore.instance.collection('auction_items').doc();

  final auctionItem = AuctionItem(
      id: docUser.id,
      description: description,
      bidPrice: bidPrice,
      bidder: bidder,
      imageURL: imageURL,
      title: title,
      seller: seller,
      timestamp: timestamp);

  final json = auctionItem.toJson();

  await docUser.set(json);
}

Widget buildButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) =>
    ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            primary: Colors.grey[200],
            onPrimary: Colors.grey[900]),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Text(title),
          ],
        ));

class AuctionItem {
  String id;
  final String description;
  final int bidPrice;
  final String bidder;
  final String imageURL;
  final String seller;
  final String title;
  final Timestamp timestamp;

  AuctionItem({
    this.id = '',
    required this.description,
    required this.bidPrice,
    required this.bidder,
    required this.imageURL,
    required this.title,
    required this.seller,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'bidPrice': bidPrice,
        'bidder': bidder,
        'imageURL': imageURL,
        'title': title,
        'seller': seller,
        'timestamp': timestamp
      };
}
