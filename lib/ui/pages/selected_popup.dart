import 'package:flutter/material.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/home_page.dart';

class SelectedPop extends StatelessWidget {
  const SelectedPop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mitraGreen, // Background warna hijau
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black), // Ikon close (X)
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: const Text(
          'Orderan',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black), // Ikon avatar
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(24, 31, 23, 16),
          margin: EdgeInsets.fromLTRB(30, 0, 29.64, 170),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 110, color: Colors.black),
              const SizedBox(height: 10),
              const Text(
                'Anda Terpilih!',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Uang transport sudah dibayar,\n'
                'tanya detail infonya lalu\n'
                'segera OTW ya!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Warna tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'OTW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
