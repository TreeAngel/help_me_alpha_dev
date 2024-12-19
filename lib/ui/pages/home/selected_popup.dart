// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../configs/app_colors.dart';
// import 'home_page.dart';

// class SelectedPop extends StatelessWidget {
//   const SelectedPop({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: AppColors.primary,
//         appBar: AppBar(
//           backgroundColor: AppColors.primary,
//           elevation: 0,
//           leading: IconButton(
//             padding: const EdgeInsets.only(left: 25.0),
//             icon: const Icon(Icons.close, color: Colors.black),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: Text(
//             'Orderan',
//             style: GoogleFonts.poppins(
//               color: Colors.black,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           centerTitle: true,
//           actions: const [
//             Padding(
//               padding: EdgeInsets.only(right: 25.0),
//               child: CircleAvatar(
//                 radius: 18,
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   Icons.person,
//                   color: Colors.pink,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(20, 120, 20, 10),
//             child: Column(
//               // mainAxisAlignment: MainAxisAlignment.center,

//               children: [
//                 // SizedBox(height: 100),
//                 Container(
//                   padding: const EdgeInsets.all(30),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Column(
//                     mainAxisSize:
//                         MainAxisSize.min, // Minimize the size to fit content
//                     children: [
//                       const Icon(
//                         Icons.check_circle_outline,
//                         size: 120,
//                         color: Colors.black,
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         'Anda Terpilih!',
//                         style: GoogleFonts.poppins(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Uang transport sudah dibayar,\ntanya detail infonya lalu\nsegera OTW ya!',
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black, // Button color
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         onPressed: () {
//                           // Navigate to Track Maps Page
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const HomePage()));
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 20.0, horizontal: 100.0),
//                           child: Text(
//                             'OTW',
//                             style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//     // return Scaffold(
//     //   backgroundColor: AppColors.mitraGreen,

//     //   // appBar: AppBar(
//     //   //   elevation: 0,
//     //   //   backgroundColor: Colors.transparent,
//     //   //   leading: IconButton(
//     //   //     icon: Icon(Icons.close, color: Colors.black),
//     //   //     onPressed: () {
//     //   //       // Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
//     //   //       Navigator.of(context).pop();
//     //   //     },
//     //   //   ),
//     //   //   title: const Text(
//     //   //     'Orderan',
//     //   //     style: TextStyle(
//     //   //       fontSize: 24,
//     //   //       color: Colors.black,
//     //   //       fontWeight: FontWeight.bold,
//     //   //     ),
//     //   //   ),
//     //   //   centerTitle: true,
//     //   //   actions: const [
//     //   //     Padding(
//     //   //       padding: EdgeInsets.all(10.0),
//     //   //       child: CircleAvatar(
//     //   //         backgroundColor: AppColors.white,
//     //   //         child: Icon(Icons.person, color: Colors.black), // Ikon avatar
//     //   //       ),
//     //   //     ),
//     //   //   ],
//     //   // ),
//     //   body: Center(
//     //     child: Container(
//     //       padding: const EdgeInsets.fromLTRB(20, 33, 20, 16),
//     //       margin: const EdgeInsets.fromLTRB(20, 0, 19.64, 160),
//     //       decoration: BoxDecoration(
//     //         color: AppColors.white,
//     //         borderRadius: BorderRadius.circular(28),
//     //       ),
//     //       child: Stack(
//     //         children: [
//     //           Container(
//     //             width: MediaQuery.of(context).size.width,
//     //               height: MediaQuery.of(context).size.height,
//     //               decoration: const BoxDecoration(
//     //                 color: AppColors.mitraGreen,
//     //               ),
//     //               padding: const EdgeInsets.only(top: 50, left: 30, right: 20, bottom: 770),
//     //               child: Row(
//     //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                 crossAxisAlignment: CrossAxisAlignment.center,
//     //                 children: [
//     //                   IconButton(
//     //                     icon: const Icon(Icons.close),
//     //                     iconSize: 30,
//     //                     color: Colors.black,
//     //                     onPressed: () {
//     //                       Navigator.of(context).pop();
//     //                     },
//     //                   ),
//     //                   const Text(
//     //                     'Orderan',
//     //                     style: TextStyle(
//     //                       fontSize: 28,
//     //                       fontWeight: FontWeight.bold,
//     //                     ),
//     //                   ),
//     //                   IconButton(
//     //                     icon: const CircleAvatar(
//     //                       backgroundImage: AssetImage('assets/images/girl1.png'), // TODO: Ganti ke NetwordkImage buat ambil profile image dari api
//     //                       radius: 20,
//     //                     ),
//     //                     onPressed: () {
//     //                       Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//     //                     },
//     //                   ),
//     //                 ],
//     //               ),
//     //           ),
//     //           Column(
//     //             mainAxisSize: MainAxisSize.min,
//     //             children: [
//     //               const Icon(Icons.check_circle_outline,
//     //                   size: 110, color: Colors.black),
//     //               const SizedBox(height: 10),
//     //               Text(
//     //                 'Anda Terpilih!',
//     //                 style: GoogleFonts.poppins(
//     //                   fontSize: 27,
//     //                   fontWeight: FontWeight.bold,
//     //                   color: Colors.black,
//     //                 ),
//     //               ),
//     //               const SizedBox(height: 20),
//     //               Text(
//     //                 'Uang transport sudah dibayar,\n'
//     //                 'tanya detail infonya lalu\n'
//     //                 'segera OTW ya!',
//     //                 textAlign: TextAlign.center,
//     //                 style: textTheme.titleMedium?.copyWith(
//     //                   fontSize: 16,
//     //                   color: Colors.black,
//     //                   fontWeight: FontWeight.bold,
//     //                   height:  1.2
//     //                 ),
//     //               ),
//     //               const SizedBox(height: 30),
//     //               SizedBox(
//     //                 width: double.infinity,
//     //                 height: 60,
//     //                 child: ElevatedButton(
//     //                   onPressed: () {
//     //                     Navigator.push(context, MaterialPageRoute(builder: (context) => const TrackMaps()));
//     //                   },
//     //                   style: ElevatedButton.styleFrom(
//     //                     backgroundColor: Colors.black, // Warna tombol
//     //                     shape: RoundedRectangleBorder(
//     //                       borderRadius: BorderRadius.circular(50),
//     //                     ),
//     //                   ),
//     //                   child: Text(
//     //                     'OTW',
//     //                     style: GoogleFonts.poppins(
//     //                       color: Colors.white,
//     //                       fontSize: 15,
//     //                       fontWeight: FontWeight.bold,
//     //                     ),
//     //                   ),
//     //                 ),
//     //               ),
//     //             ],
//     //           ),
//     //         ],
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
// }

// // class Profile extends StatelessWidget {
// //   const Profile({
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Positioned(
// //       top: 65,
// //       right: 30,
// //       child: GestureDetector(
// //         onTap: () {
// //           //aksi saat profil ditekan
// //           //misalnya, buka halaman profil
// //         },
// //         child: const CircleAvatar(
// //           backgroundColor: Colors.white,
// //           radius: 20,
// //           child: Icon(
// //             Icons.person,
// //             color: Colors.black,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class Exit extends StatelessWidget {
// //   const Exit({
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Positioned(
// //       top: 60,
// //       left: 30,
// //       child: IconButton(
// //         icon: Icon(Icons.close),
// //         color: Colors.white,
// //         iconSize: 24.0,
// //         onPressed: () {
// //           // Navigator.of(context).pushReplacementNamed('/home');
// //           MaterialPageRoute(builder: (context) => HomePage());
// //         },
// //         padding: EdgeInsets.all(0),
// //         constraints: BoxConstraints(),
// //         splashRadius: 24,
// //       ),
// //     );
// //   }
// // }

// // class Orderan extends StatefulWidget {
// //   const Orderan({super.key});

// //   @override
// //   _OrderanState createState() => _OrderanState();
// // }

// // class _OrderanState extends State<Orderan> {
// //   final _formKey = GlobalKey<FormState>(); //GlobalKey for the form

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //     child: Positioned(
// //       child: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.only(top: 40),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               const Text(
// //                 'Orderan',
// //                 style: TextStyle(
// //                   fontSize: 28,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               const CircleAvatar(
// //                 backgroundImage: AssetImage('assets/images/ban-kempes.jpg'),
// //                 radius: 75,
// //               ),
// //               const SizedBox(height: 10),
// //               const Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.location_on, size: 20),
// //                   Text(
// //                     '2.3 km',
// //                     style: TextStyle(
// //                       fontSize: 15,
// //                       fontWeight: FontWeight.bold
// //                       ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 10),
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //                 child: const Text('Kempes/Bocor',
// //                 style: TextStyle(
// //                   fontSize: 15,
// //                   fontWeight: FontWeight.bold
// //                 )),
// //               ),
// //               const SizedBox(height: 10),
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //                 child: const Text('Ban tubeless',
// //                 style: TextStyle(
// //                   fontSize: 15,
// //                   fontWeight: FontWeight.bold
// //                 )),
// //               ),
// //               const Padding(padding: EdgeInsets.only(bottom: 8)),
// //                 const TawarkanBtn()
// //               ],
// //             ),
// //         ),
// //       ),
// //     ),
// //     );
// //   }
// // }

// // class TawarkanBtn extends StatelessWidget {
// //   const TawarkanBtn({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 0, top: 30),
// //       child: ElevatedButton(
// //         onPressed: () {

// //         },

// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: Colors.black,
// //           padding: const EdgeInsets.symmetric(
// //             horizontal: 110, vertical: 20,
// //           ),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(40),
// //           ),
// //         ),
// //         child: const Text(
// //           'OTW',
// //           style: TextStyle(
// //             color: Colors.white,
// //             fontSize: 16,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
