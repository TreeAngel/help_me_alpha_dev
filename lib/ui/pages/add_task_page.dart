import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../configs/app_colors.dart';
import '../../data/problem_questions_data.dart';
import '../../services/location_service.dart';
import '../../utils/show_dialog.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage(
      {super.key, required this.problemId, required this.problem});

  final int? problemId;
  final String? problem;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late List<String> questions;
  List<String> questionChoices = [];
  String? selectedChoice;
  double lat = LocationService.lat;
  double long = LocationService.long;

  @override
  void initState() {
    super.initState();
    questions = questionsBuilder(widget.problem!);
    LocationService.fetchLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(context, textTheme),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              width: screenWidth,
              child: Container(
                height: screenHeight / 1 - (screenHeight / 2.8),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 30,
                  right: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (questions.isNotEmpty) ...[
                      Text(
                        'Mencari bantuan \nuntuk ${widget.problem.toString()}',
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        thickness: 3,
                        color: AppColors.lightTextColor,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        questions.first,
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (questionChoices.isNotEmpty) ...[
                        _drowdownQuesitonChoices(textTheme),
                      ] else ...[
                        TextFormField()
                      ],
                    ] else ...[
                      ShowDialog.showAlertDialog(
                        context,
                        'Terjadi kesalahan!',
                        'Ada masalah di aplikasinya,\n kakak bisa coba buat kembali ke halaman sebelumnya atau hubungin CS kami',
                        ElevatedButton.icon(
                          onPressed: () => context.pop(),
                          label: const Text('Kembali'),
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenu<String> _drowdownQuesitonChoices(TextTheme textTheme) {
    return DropdownMenu<String>(
      expandedInsets: const EdgeInsets.all(0),
      textStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.w500,
      ),
      menuStyle: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        side: WidgetStatePropertyAll(
          BorderSide(color: Colors.black),
        ),
      ),
      initialSelection: questionChoices.first,
      onSelected: (String? value) {
        setState(() {
          selectedChoice = value;
        });
      },
      dropdownMenuEntries:
          questionChoices.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry(
          value: value,
          label: value,
        );
      }).toList(),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.lightTextColor,
      title: Text(
        'Form Bantuan',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<String> questionsBuilder(String problemName) {
    // Kendaraan
    // Motor
    if (problemName.toLowerCase().contains('ban motor')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.banMotor);
      return ['Jenis bannya apa?', 'Fotoin kendaraannya'];
    }
    if (problemName.toLowerCase().contains('motor mogok')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.motorMogok);
      return ['Kenapa mogoknya?', 'Fotoin kendaraannya'];
    }
    if (problemName.toLowerCase().contains('kunci motor')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.kunciMotor);
      return ['Jenis kuncinya apa?', 'Fotoin kendaraannya'];
    }
    if (problemName.toLowerCase().contains('motor perlu servis')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.motorServiceRingan);
      return ['Jenis servis', 'Fotoin kendaraannya'];
    }
    if (problemName.toLowerCase().contains('motor perlu dicuci')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.cuciMotor);
      return ['Pilihan cuci', 'Fotoin kendaraannya'];
    }
    // Mobil
    if (problemName.toLowerCase().contains('ban mobil')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.banMobil);
      return ['Jenis servis?', 'Fotoin kendaraannya'];
    }
    if (problemName.toLowerCase().contains('mobil mogok')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.mobilMogok);
      return ['Kenapa mogoknya?', 'Fotoin kendaraannya'];
    }
    if (problemName.toLowerCase().contains('kunci mobil')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.kunciMobil);
      return ['Jenis kuncinya apa?', 'Fotoin kendaraannya'];
    }
    if (problemName.toLowerCase().contains('mobil perlu servis')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.mobilServiceRingan);
      return ['Jenis servis', 'Fotoin kendaraannya'];
    }
    if (problemName.toLowerCase().contains('mobil perlu dicuci')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.cuciMobil);
      return ['Pilihan cuci', 'Fotoin kendaraannya'];
    }
    if (problemName.toLowerCase().contains('ac mobil')) {
      return [
        'Kasih liat foto AC mobilnya biar kami tau!',
        'Fotoin kendaraannya'
      ];
    }
    // Sepeda
    if (problemName.toLowerCase().contains('ban sepeda')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.banSepeda);
      return ['Jenis bannya apa?', 'Fotoin kendaraannya'];
    }
    if (problemName.toLowerCase().contains('setel sepeda')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.setelSepeda);
      return ['Pilih jenis servisnya', 'Fotoin kendaraannya'];
    }

    // Bantuan rumah
    if (problemName.toLowerCase().contains('masalah air')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.masalahAirledeng);
      return ['Masalahnya apa?', 'Fotoin masalahnya'];
    }
    if (problemName.toLowerCase().contains('septic tank penuh')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.septicTankPenuh);
      return ['Posisi sepric tanknya bagaimana?', 'Fotoin masalahnya'];
    }
    if (problemName.toLowerCase().contains('masalah listrik')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.masalahListrik);
      return ['Masalahnya apa?', 'Fotoin masalahnya'];
    }
    if (problemName.toLowerCase().contains('kunci rumah hilang')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.kunciRumah);
      return ['Jenis kuncinya apa?', 'Fotoin masalahnya'];
    }
    if (problemName.toLowerCase().contains('panggil tukang bangunan')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.tukangBangunan);
      return ['Masalahnya apa?', 'Fotoin masalahnya'];
    }

    // Bantuan elektronik
    if (problemName.toLowerCase().contains('masalah ac')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.masalahAC);
      return ['Kenapa AC nya?', 'Fotoin AC nya'];
    }
    if (problemName.toLowerCase().contains('masalah kulkas')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.masalahKulkas);
      return ['Kenapa kulkas nya?', 'Fotoin kulkas nya'];
    }
    if (problemName.toLowerCase().contains('masalah Mesin Cuci')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.masalahMesinCuci);
      return ['Kenapa Mesin Cuci nya?', 'Fotoin Mesin Cuci nya'];
    }
    if (problemName.toLowerCase().contains('masalah tv')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.masalahTV);
      return ['Kenapa TV nya?', 'Fotoin TV nya'];
    }
    if (problemName.toLowerCase().contains('masalah laptop')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.masalahLaptop);
      return ['Kenapa laptop nya?', 'Fotoin laptop nya'];
    }
    if (problemName.toLowerCase().contains('masalah hp')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.masalahHP);
      return ['Kenapa HP nya?', 'Fotoin HP nya'];
    }

    // Bantuan personal
    if (problemName.toLowerCase().contains('keseleo')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.keseleo);
      return ['Kategori usia', 'Fotoin masalahnya'];
    }
    if (problemName.toLowerCase().contains('butuh pijet')) {
      questionChoices.clear;
      questionChoices.addAll(ProblemQuestions.genderTerapis);
      return ['Gender terapis'];
    }

    // Serabutan
    if (problemName.toLowerCase().contains('serabutan')) {
      return ['Kasih tau kami apa masalahmu', 'Fotoin masalahnya\nOpsional'];
    }

    return [];
  }
}
