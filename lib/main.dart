import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: unused_import
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import './screens/signin_screen.dart';
import './screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const MaterialApp(
      home: MainPage(),
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return SignInScreen();
        }
      },
    ));
  }
}

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int currentIndex = 0;
//   final screens = [
//     CurrentAuctions(),
//     FutureAuctions(),
//     PastAuctions(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("HomePageNEW"),
//       // ),
//       body: IndexedStack(index: currentIndex, children: screens),
//       floatingActionButton:
//           FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         selectedItemColor: Colors.blue,
//         selectedFontSize: 16.0,
//         onTap: (index) => {setState(() => currentIndex = index)},
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.add), label: "Current"),
//           BottomNavigationBarItem(icon: Icon(Icons.add), label: "Future"),
//           BottomNavigationBarItem(icon: Icon(Icons.add), label: "Past"),
//         ],
//       ),
//     );
//   }
// }

// class Home extends StatelessWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LoginWidget(),
//     );
//   }
// }

// class LoginWidget extends StatefulWidget {
//   const LoginWidget({Key? key}) : super(key: key);

//   @override
//   State<LoginWidget> createState() => _LoginWidgetState();
// }

// class _LoginWidgetState extends State<LoginWidget> {
//   final emailContoller = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   void dispose() {
//     emailContoller.dispose();
//     passwordController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 40),
//             TextField(
//               controller: emailContoller,
//               cursorColor: Colors.white,
//               textInputAction: TextInputAction.next,
//               decoration: InputDecoration(labelText: "Enter your e-mail"),
//             ),
//             SizedBox(height: 4),
//             TextField(
//               controller: passwordController,
//               textInputAction: TextInputAction.done,
//               decoration: InputDecoration(labelText: "Enter your password"),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
//               icon: Icon(Icons.lock_open, size: 32),
//               label: Text(
//                 'Sign In',
//                 style: TextStyle(fontSize: 24),
//               ),
//               onPressed: () {},
//             )
//           ],
//         ));
//   }
// }
