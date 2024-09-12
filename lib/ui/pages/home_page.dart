import 'package:flutter/material.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.7, // Sedikit lebih pendek
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              padding: const EdgeInsets.only(top: 50,left: 30, bottom: 0), // Memberikan padding untuk teks
              // alignment: Alignment.bottomLeft, // Posisi teks di bawah
              child: RichText(
                text: const TextSpan(
                  text: "Hi, \n",
                  style: TextStyle(
                    fontSize: 22.15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Abang!",
                      style: TextStyle(
                        fontSize: 35.62,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.5),
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: const Text(""),
            ),
            Container(
              margin: const EdgeInsets.only(top: 120, left: 20.0, right: 20.0), // Menambah margin top
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4.2,
                    decoration: BoxDecoration(
                      color: AppColors.mitraGreen.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        const Positioned(
                          left: 20,
                          top: 15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Saldo",
                                style: TextStyle(
                                  fontSize: 22.15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "Abang",
                                style: TextStyle(
                                  fontSize: 22.15,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Rp0",
                                style: TextStyle(
                                  fontSize: 22.15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 28),
                              Text(
                                "08x-xxx-xxx-xxx",
                                style: TextStyle(
                                  fontSize: 22.15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Ikon Heksagonal di Kanan Atas
                        Positioned(
                        right: 10,
                        bottom: 10,
                        child: ClipPath(
                          // clipper: HexagonClipper(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: AppColors.mitraGreen,
                            ),
                          ),
                        ),
                      ),
                      ],
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
