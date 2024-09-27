import 'package:flutter/material.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';

class SelectedPop extends StatelessWidget {
  const SelectedPop({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: 
        SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: AppColors.mitraGreen,
                  ),
                  padding: const EdgeInsets.only(top: 10, left: 10, bottom: 0),
                ),
                 Center(
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.fromLTRB(30, 194, 29.64, 303.56),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(30, 41, 30, 16),
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              text: 'Anda Terpilih! \n',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: 'Uang Transport sudah dibayar, tanya detail infonya lalu segera OTW ya !',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                )
                              ]
                            ),
                          ),
                          // TextButton(
                          //   child: Text('data'),
                          //   onPressed: (){},
                          // ),
                        // SizedBox(
                        //   width: 100,
                        //   height: 56,
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       // Aksi ketika tombol ditekan
                        //     },
                        //     child: Text(
                        //       'OTW',
                        //       style: TextStyle(
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold,
                        //         color: AppColors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),

                          
                        ],
                      ),
                    ),
                  ),
                ),
                
                // const Exit(),
                // const Profile(),
                // const Orderan(),
              ],
            ),
          ),
        ),
    );
  }
}

// class Profile extends StatelessWidget {
//   const Profile({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 65,
//       right: 30,
//       child: GestureDetector(
//         onTap: () {
//           //aksi saat profil ditekan
//           //misalnya, buka halaman profil
//         },
//         child: const CircleAvatar(
//           backgroundColor: Colors.white,
//           radius: 20,
//           child: Icon(
//             Icons.person,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Exit extends StatelessWidget {
//   const Exit({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 60,
//       left: 30,
//       child: IconButton(
//         icon: Icon(Icons.close),
//         color: Colors.white,
//         iconSize: 24.0,
//         onPressed: () {
//           // Navigator.of(context).pushReplacementNamed('/home');
//           MaterialPageRoute(builder: (context) => HomePage());
//         },
//         padding: EdgeInsets.all(0),
//         constraints: BoxConstraints(),
//         splashRadius: 24,
//       ),
//     );
//   }
// }

// class Orderan extends StatefulWidget {
//   const Orderan({super.key});

//   @override
//   _OrderanState createState() => _OrderanState();
// }

// class _OrderanState extends State<Orderan> {
//   final _formKey = GlobalKey<FormState>(); //GlobalKey for the form

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//     child: Positioned(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 40),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 'Orderan',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const CircleAvatar(
//                 backgroundImage: AssetImage('assets/images/ban-kempes.jpg'),
//                 radius: 75,
//               ), 
//               const SizedBox(height: 10),
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.location_on, size: 20),
//                   Text(
//                     '2.3 km',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold
//                       ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text('Kempes/Bocor',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold
//                 )),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text('Ban tubeless',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold
//                 )),
//               ),
//               const Padding(padding: EdgeInsets.only(bottom: 8)),                    
//                 const TawarkanBtn()
//               ],
//             ),
//         ),
//       ),
//     ),
//     );
//   }
// }

// class TawarkanBtn extends StatelessWidget {
//   const TawarkanBtn({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0, top: 30),
//       child: ElevatedButton(
//         onPressed: () {
          
//         },
        
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.black,
//           padding: const EdgeInsets.symmetric(
//             horizontal: 110, vertical: 20,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(40),
//           ),
//         ),
//         child: const Text(
//           'OTW',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
