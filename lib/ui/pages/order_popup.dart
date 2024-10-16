import 'package:flutter/material.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:help_me_mitra_alpha_ver/ui/pages/home_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // State untuk data API
  String? imageUrl;
  String? distance;
  String? serviceType;
  String? serviceCategory;

  bool isLoading = false;

  //fetch data dari API
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.delayed(Duration(seconds: 2));

      // Simulasi data dari API (ganti dengan API call yang sebenarnya)
      setState(() {
        imageUrl = "../../../assets/images/ban-kempes.jpg";
        distance = "2.4 km";
        serviceType = "Kempes/Bocor";
        serviceCategory = "Ban tubeless";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      backgroundColor: AppColors.mitraGreen,
      appBar: AppBar(
        backgroundColor: AppColors.mitraGreen,
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 25.0),
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Orderan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 25.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Placeholder Image or Actual Image from API
              CircleAvatar(
                radius: 60,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : null,
                child: imageUrl == null
                    ? Icon(Icons.image, size: 60)
                    : null,
              ),
              SizedBox(height: 16),
              
              // Placeholder for Distance or Actual Distance
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, size: 20),
                  SizedBox(width: 4),
                  Text(
                    distance != null ? distance! : 'Jarak',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Service Type
              Text(
                serviceType != null ? serviceType! : 'Layanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Service Category
              Text(
                serviceCategory != null
                    ? serviceCategory!
                    : 'Kategori layanan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 32),

              //post data
              TextField(
                decoration: InputDecoration(
                  labelText: 'Berapa transportnya?',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Berapa harga per lubangnya?',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Perkiraan datang?',
                ),
              ),
              SizedBox(height: 32),

              isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      // Implementasi fungsi postData di sini
                    },
                    child: Text('Tawarkan'),
                  ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';
// import 'package:help_me_mitra_alpha_ver/ui/pages/home_page.dart';

// class OrderPop extends StatelessWidget {
//   const OrderPop({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: AppColors.mitraGreen, // Background green
//       appBar: AppBar(
//         backgroundColor: AppColors.mitraGreen, // Make the AppBar match the background
//         elevation: 0,
//         leading: IconButton(
//           padding: const EdgeInsets.only(left: 25.0),
//           icon: Icon(Icons.close, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           'Orderan',
//           style: GoogleFonts.poppins(
//             color: Colors.black,
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 25.0),
//             child: CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.white,
//               child: Icon(
//                 Icons.person,
//                 color: Colors.pink,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: 
//         SingleChildScrollView(
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height,
//             child: Stack(
//               children: [
//                 // Container(
//                 //   width: MediaQuery.of(context).size.width,
//                 //   height: MediaQuery.of(context).size.height,
//                 //   decoration: const BoxDecoration(
//                 //     color: AppColors.mitraGreen,
//                 //   ),
//                 //   padding: const EdgeInsets.only(top: 50, left: 30, right: 20, bottom: 770),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     crossAxisAlignment: CrossAxisAlignment.center,
//                 //     children: [
//                 //       IconButton(
//                 //         icon: const Icon(Icons.close),
//                 //         iconSize: 30,
//                 //         color: Colors.black,
//                 //         onPressed: () {
//                 //           Navigator.pop(context);
//                 //         },
//                 //       ),
//                 //       const Text(
//                 //         'Orderan',
//                 //         style: TextStyle(
//                 //           fontSize: 28,
//                 //           fontWeight: FontWeight.bold,
//                 //         ),
//                 //       ),
//                 //       IconButton(
//                 //         icon: const CircleAvatar(
//                 //           backgroundImage: AssetImage('assets/images/girl1.png'), // TODO: Ganti ke NetwordkImage buat ambil profile image dari api
//                 //           radius: 20,
//                 //         ),
//                 //         onPressed: () {
//                 //           Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//                 //         },
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 Container(
//                   margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 1.95),
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                 ),
//                 const Orderan(),
//               ],
//             ),
//           ),
//         ),
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
        
//           child: Column(
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             children: [  
//               // const SizedBox(height: 20),
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
//                 FormTawar(formKey: _formKey),                      
//                 const TawarkanBtn()
//               ],
//             ),
//         ),
//       ),
//     );
//   }
// }

// class FormTawar extends StatelessWidget {
//   final GlobalKey<FormState> formKey;
//   const FormTawar({required this.formKey, super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 60, left: 31, right: 31),
//       child: Column(
//        key: formKey, // Attach the key to the form
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Berapa transportnya?",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 3),
//           SizedBox(
//             height: 40,
//             width: double.infinity,
//             child: TextFormField(
//               style: const TextStyle(
//                 color: AppColors.black,
//               ),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(vertical: .0, horizontal: 12.0),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   borderSide: const BorderSide(
//                     color: AppColors.mitraGreen,
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   borderSide: const BorderSide(
//                     color: AppColors.mitraGreen,
//                     width: 1,
//                   ),
//                 ),
//               ),
//               // validator: (value) {
//               //   if (value == null || value.isEmpty) {
//               //     return 'Field ini wajib diisi';
//               //   }
//               //   return null;
//               // },
//             ),
//           ),
//           const SizedBox(height: 30),
//           const Text(
//             "Berapa harga per lubangnya?",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 3),
//           SizedBox(
//             height: 40,
//             width: 350,
//             child: TextField(
//               style: const TextStyle(
//                 color: AppColors.black,
//               ),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(vertical: .0, horizontal: 12.0),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   borderSide: const BorderSide(
//                     color: AppColors.mitraGreen,
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   borderSide: const BorderSide(
//                     color: AppColors.mitraGreen,
//                     width: 1,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//           const Text(
//             "Perkiraan datang?",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(
//             height: 40,
//             width: 350,
//             child: TextField(
//               style: const TextStyle(
//                 color: AppColors.black,
//               ),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(vertical: .0, horizontal: 12.0),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   borderSide: const BorderSide(
//                     color: AppColors.mitraGreen,
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   borderSide: const BorderSide(
//                     color: AppColors.mitraGreen,
//                     width: 1,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       );
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
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 title: const Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.question_mark_rounded,
//                       size: 50,
//                       color: AppColors.leavesGreen,
//                     ),
//                     SizedBox(height: 10),
//                     Text("Konfirmasi Tawaran",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 content: const Text("  Yakin dengan tawaran ini?",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     style: ButtonStyle(
//                       padding: WidgetStateProperty.all<EdgeInsets>(
//                         const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       ),
//                       backgroundColor: WidgetStateProperty.resolveWith<Color?>(
//                         (Set<WidgetState> states) {
//                           if (states.contains(WidgetState.pressed)) {
//                             return AppColors.leavesGreen.withOpacity(0.5);
//                           }
//                         },
//                       ),
//                       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                     child: const Text("Batal",
//                        style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   TextButton(
//                     style: ButtonStyle(
//                       padding: WidgetStateProperty.all<EdgeInsets>(
//                         const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                       ),
//                       backgroundColor: WidgetStateProperty.resolveWith<Color?>(
//                         (Set<WidgetState> states) {
//                           if (states.contains(WidgetState.pressed)) {
//                             return AppColors.leavesGreen;
//                           }
//                           return AppColors.mitraGreen;
//                         },
//                       ),
//                       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
                                      
//                     child: const Text("Tawarkan",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600
//                       ),
//                     ),
      
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           duration: const Duration(seconds: 2),
//                           content: const Text("Tawaran dikirim!"),
//                           backgroundColor: Colors.black,
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       );

//                       Future.delayed(const Duration(milliseconds: 100), () {
//                         Navigator.of(context).pushReplacement(
//                           MaterialPageRoute(builder: (context) => const HomePage()),
//                         );
//                       });
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
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
//           'Tawarkan',
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
