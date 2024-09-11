import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HelpMe!', style: TextStyle(
          fontFamily: "poppins",
          color: Colors.white,
          fontSize: 25.21,
          fontWeight: FontWeight.bold,
        ),)
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const SizedBox(height: 25),
            Text(
              "Masuk",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Username",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              style: const TextStyle(color: Colors.black ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Masukkan username',
                hintStyle: GoogleFonts.poppins(color: AppColors.greyinput),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
             Text(
              "Kata Sandi",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
              TextField(
              style: const TextStyle(color: Colors.black ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Masukkan Kata Sandi',
                hintStyle: GoogleFonts.poppins(color: AppColors.greyinput),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
              "Lupa Kata Sandi?",
              style: GoogleFonts.poppins(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mitraGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 158, vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              child: const Text(
                'Masuk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
              text: const TextSpan(
                text: 'Belum memiliki akun? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Daftar',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.mitraGreen,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';

// class LoginPageView extends StatefulWidget {
//   const LoginPageView({super.key});

//   @override
//   State<LoginPageView> createState() => _LoginPageViewState();
// }

// class _LoginPageViewState extends State<LoginPageView> {
//   // Controllers untuk menangani inputan user
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 90),
//             const SubHeaderText(),
//             const SizedBox(height: 10),
//             const FooterText(),
//             // Label untuk Username
//             Text(
//               "Username",
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Input untuk Username
//             TextField(
//               controller: _usernameController,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white,
//                 hintText: 'Masukkan username',
//                 hintStyle: GoogleFonts.poppins(color: AppColors.grey),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Label untuk Password
//             Text(
//               "Password",
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,

//               ),
//             ),
//             const SizedBox(height: 8),
//             // Input untuk Password
//             TextField(
//               controller: _passwordController,
//               obscureText: true, // Agar input menjadi titik-titik
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white,
//                 hintText: 'Masukkan password',
//                 hintStyle: GoogleFonts.poppins(color: AppColors.grey),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//             // Tombol Login
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Aksi yang dilakukan saat login
//                   String username = _usernameController.text;
//                   String password = _passwordController.text;
//                   print('Username: $username, Password: $password');
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.mitraGreen,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 153, vertical: 18,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   "Masuk",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }

// // Komponen untuk Subheader
// class SubHeaderText extends StatelessWidget {
//   const SubHeaderText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         "Masuk",
//         style: TextStyle(
//           fontFamily: "poppins",
//           color: Colors.white,
//           fontSize: 30,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

// //Komponen untuk teks di bagian footer "Belum memiliki akun? Daftar"
// class FooterText extends StatelessWidget {
//   const FooterText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           RichText(
//             text: TextSpan(
//               text: "Belum memiliki akun? ",
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 19,
//               ),
//               children: [
//                 TextSpan(
//                   text: "Daftar",
//                   style: GoogleFonts.poppins(
//                     color: AppColors.mitraGreen,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';
// import 'package:google_fonts/google_fonts.dart';

// class LoginPageView extends StatefulWidget {
//   const LoginPageView({super.key});

//   @override
//   State<LoginPageView> createState() => _LoginPageViewState();
// }

// class _LoginPageViewState extends State<LoginPageView> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           HeaderText(),          // Komponen untuk header HelpMe!
//           SubHeaderText(),       // Komponen untuk subheader
//           Spacer(),
//           FooterText(),          // Komponen untuk teks di footer
//         ],
//       ),
//     );
//   }
// }

// // Komponen untuk header text "HelpMe!"
// class HeaderText extends StatelessWidget {
//   const HeaderText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.only(top: 42.52),
//       child: Center(
//         child: Text(
//           "HelpMe!",
//           style: TextStyle(
//             fontFamily: "poppins",
//             color: Colors.white,
//             fontSize: 25.21,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Komponen untuk subheader text "Masukkan email dan kata sandi Anda"
// class SubHeaderText extends StatelessWidget {
//   const SubHeaderText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.only(top: 20.0, left: 20.0),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           "Masuk",
//           style: TextStyle(
//             fontFamily: "poppins",
//             color: Colors.white,
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }



// // Komponen untuk teks di bagian footer "Belum memiliki akun? Daftar"
// class FooterText extends StatelessWidget {
//   const FooterText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           RichText(
//             text: TextSpan(
//               text: "Belum memiliki akun? ",
//               style: GoogleFonts.poppins(
//                 color: Colors.white,
//                 fontSize: 19,
//               ),
//               children: [
//                 TextSpan(
//                   text: "Daftar",
//                   style: GoogleFonts.poppins(
//                     color: AppColors.mitraGreen,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
