import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_me_mitra_alpha_ver/configs/app_colors.dart';
import 'package:help_me_mitra_alpha_ver/ui/pages/sign_in_page.dart';
import '../../blocs/forgot_password_blocs/forgot_password_bloc.dart';
import '../../blocs/forgot_password_blocs/forgot_password_event.dart';
import '../../blocs/forgot_password_blocs/forgot_password_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace, color: Colors.white), // Ikon close (X)
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage()));
          },
        ),
        title: const Text(
          'HelpMe!',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Reset link sent to your phone!'),
                ));
              } else if (state is ForgotPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.error),
                ));
              }
            },
            builder: (context, state) {
              if (state is ForgotPasswordLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.mitraGreen,));
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    'Lupa Password',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Masukkan nomor telepon',
                      hintStyle:
                          textTheme.bodyLarge?.copyWith(color: AppColors.greyinput),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                    ),
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightTextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(AppColors.mitraGreen),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      final phoneNumber = _phoneController.text.trim();
                      if (phoneNumber.isNotEmpty) {
                        context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted(phoneNumber));
                      }
                    },
                    child: const Text(
                      'Send Reset Link',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../services/api/api_exception.dart';
// import '../../configs/app_colors.dart';
// import '../../blocs/auth_blocs/auth_bloc.dart';
// import '../../blocs/auth_blocs/auth_state.dart';
// import '../../utils/show_dialog.dart';

// class ForgotPasswordPage extends StatelessWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final appTheme = Theme.of(context);
//     final textTheme = appTheme.textTheme;

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: CustomScrollView(
//           slivers: <Widget>[
//             const SliverToBoxAdapter(child: SizedBox(height: 20)),
//             _authSliverAppBar(context),
//             const SliverToBoxAdapter(child: SizedBox(height: 20)),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 5),
//                     Text(
//                       "Lupa password?",
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     BlocBuilder<AuthBloc, AuthState>(
//                       builder: (context, state) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Masukan email akun anda',
//                               style: textTheme.titleMedium?.copyWith(
//                                 fontSize: 14,
//                                 color: AppColors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             _emailInputField(context, textTheme),
//                             const SizedBox(height: 20),
//                             if (state is EmailSentSuccess) ...[
//                               Text(
//                                 "Email anda telah dikirimkan",
//                                 style: TextStyle(color: const Color.fromARGB(255, 175, 76, 76)),
//                               ),
//                             ],
//                             if (state is AuthError) ...[
//                               _stateError(context, state),
//                             ],
//                             if (state is AuthLoading) ...[
//                               const Center(
//                                 child: CircularProgressIndicator(
//                                   color: AppColors.mitraGreen,
//                                 ),
//                               ),
//                             ] else ...[
//                               _sendButton(textTheme, context),
//                             ],
//                             const SizedBox(height: 20),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _stateLoaded(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.goNamed('signInPage');
//     });
//     return const SizedBox.shrink();
//   }

//   _stateError(BuildContext context, AuthError state) {
//     String errorMessage = ApiException.errorMessageBuilder(state.errorMessage);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ShowDialog.showAlertDialog(
//         context,
//         'Error!',
//         errorMessage,
//         null,
//       );
//       context.read<AuthBloc>().add(ResetAuthState());
//     });
//     return const SizedBox.shrink();
//   }

//   SizedBox _sendButton(
//       TextTheme textTheme, BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(
//             AppColors.mitraGreen,
//           ),
//           shape: MaterialStateProperty.all(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//         child: Text(
//           'Kirim',
//           style: textTheme.titleMedium?.copyWith(
//             fontSize: 16,
//             color: AppColors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         onPressed: () {
//           //Event untuk mengirim email, ganti sesuai event yang benar
//           context.read<AuthBloc>().add(SendResetPasswordEmail('usermitra1@example.com'));
          
//           //Lakukan polling untuk mengecek perubahan password
//           context.read<AuthBloc>().add(StartPasswordChangePolling());
//         },
//       ),
//     // );
//   }

//   TextFormField _emailInputField(BuildContext context, TextTheme textTheme) {
//     return TextFormField(
//       cursorColor: Colors.black,
//       onChanged: (email) =>
//           context.read<AuthBloc>().add(EmailChanged(email)),
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white,
//         hintText: 'Masukkan email',
//         hintStyle:
//             textTheme.bodyLarge?.copyWith(color: AppColors.greyinput),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
//       ),
//       style: textTheme.bodyLarge?.copyWith(
//         color: AppColors.lightTextColor,
//         fontWeight: FontWeight.normal,
//       ),
//     );
//   }

//   SliverAppBar _authSliverAppBar(BuildContext context) {
//     return const SliverAppBar(
//       centerTitle: true,
//       backgroundColor: Colors.black,
//       foregroundColor: AppColors.white,
//       title: Text(
//         'HelpMe!',
//         style: TextStyle(
//           fontFamily: "poppins",
//           color: Colors.white,
//           fontSize: 25.21,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
