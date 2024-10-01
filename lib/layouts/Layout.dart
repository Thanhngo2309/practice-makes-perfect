// import 'package:flutter/material.dart';

// class Layout extends StatefulWidget {
//   final Widget child;
//   @override
//   State<LayoutState> createState() => LayoutState();
// }

// class LayoutState extends State<LayoutState> {

//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static List<Widget> _widgetOptions = <Widget>[
//     Page1(),
//     Page2()
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('BottomNavigationBar Sample'),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
// bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business),
//             label: 'Business',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.school),
//             label: 'School',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         onTap: _onItemTapped,
//       ),
//     );
//   } 
// }

// class Page1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Text("ahdoahd");
//   }
// }
// class Page2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Text("daohdaoh");
//   }
// }