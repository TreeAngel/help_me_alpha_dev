import 'package:flutter/material.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';

class OrderPop extends StatelessWidget {
  const OrderPop({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final colorScheme = appTheme.colorScheme;

    return Scaffold(
      body: 
        Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: AppColors.mitraGreen,
                ),
                padding: const EdgeInsets.only(top: 50, left: 30, bottom: 0),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )
                ),
              ),
              Positioned(
                top: 50,
                left: 30,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 24, color: Colors.black),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 30,
                child: GestureDetector(
                  onTap: () {
                    //aksi saat profil ditekan
                    //misalnya, buka halaman profil
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Supaya konten tersusun di tengah secara vertikal
              children: [
                const Text(
                  'Orderan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20), // Spasi antara teks dan konten lainnya
                const CircleAvatar(
                  // backgroundImage: AssetImage('assets/your_image.png'), // Ganti dengan gambar yang kamu gunakan
                  radius: 50,
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 20),
                    Text(
                      '2.3 km',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Kempes/Bocor', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Ban tubeless', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),
                // Form Input atau Field lainnya bisa ditambahkan di sini
                Padding(
                  padding: EdgeInsets.only(top: 110, left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Berapa transportnya?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Berapa harga per lubangnya?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Perkiraan datang?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi untuk tombol tawarkan
                    },
                    child: Text('Tawarkan'),
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.black, // Background button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Button melengkung
                      ),
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