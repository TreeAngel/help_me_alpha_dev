import 'package:flutter/material.dart';

import '../configs/app_colors.dart';

class ShowDialog {
  static showAlertDialog(
      BuildContext context, String title, String? content, Widget? action) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: [
          if (action != null) action,
        ],
      ),
    );
  }

  static confirmRegister(BuildContext context, TextTheme textTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi akun'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Kode OTP akan dikirim ke WhatsApp anda',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            const Text('Kode OTP'),
            TextFormField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Kode OTP ada di WhatsApp anda, jika sudah terdaftar',
                hintStyle: textTheme.bodyLarge
                    ?.copyWith(color: AppColors.hintTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.lightTextColor,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.primary,
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {},
                child: const Text('Konfirmasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
