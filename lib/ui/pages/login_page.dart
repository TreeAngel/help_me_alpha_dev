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
              onPressed: () {
                Future.delayed(const Duration(seconds: 1), () {
                        Navigator.of(context).pushReplacementNamed('/orderan'); // Replace with your home route
                });
              },
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