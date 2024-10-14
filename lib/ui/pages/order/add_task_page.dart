import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_me_client_alpha_ver/blocs/manage_order/manage_order_bloc.dart';
import 'package:help_me_client_alpha_ver/cubits/home_cubit/home_cubit.dart';
import 'package:image_picker/image_picker.dart';

import '../../../blocs/send_order/send_order_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../data/menu_items_data.dart';
import '../../../models/misc/menu_item_model.dart';
import '../../../services/location_service.dart';
import '../../../utils/logging.dart';
import '../../../utils/question_builder.dart';
import '../../../utils/show_dialog.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({
    super.key,
    required this.problemId,
    required this.problem,
  });

  final int? problemId;
  final String? problem;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late List<String?> questions;
  List<String> questionChoices = [];
  List<XFile?> problemPictures = [];
  String? selectedChoice;
  double? lat;
  double? long;
  final TextEditingController _serabutanInputController =
      TextEditingController();
  List<Widget> showedPicture = [];

  @override
  void initState() {
    super.initState();
    questionChoices.clear();
    problemPictures.clear();
    questions = questionsBuilder(widget.problem!, questionChoices);
    getLocation();
  }

  void getLocation() {
    setState(() {
      LocationService.fetchLocation(context);
      lat = LocationService.lat;
      long = LocationService.long;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final successLocationSnackBar = SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        'Berhasil membagikan lokasi!\nlat: $lat | long: $long',
        textAlign: TextAlign.center,
        style: textTheme.labelLarge?.copyWith(color: AppColors.lightTextColor),
      ),
      backgroundColor: AppColors.surface,
      margin: const EdgeInsets.only(
        bottom: 40,
        left: 20,
        right: 20,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.lightTextColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(context, textTheme),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              width: screenWidth,
              child: Container(
                height: screenHeight / 1 - (screenHeight / 3),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
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
                        if (questions.first != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            questions.first.toString(),
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.lightTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (questionChoices.isNotEmpty) ...[
                          _drowdownQuesitonChoices(context, textTheme)
                        ],
                        if (widget.problem!.toLowerCase().contains('serabutan'))
                          _serabutanInputField(textTheme),
                        if (!widget.problem!
                            .toLowerCase()
                            .contains('butuh pijet'))
                          ..._addPictureSection(textTheme),
                        const SizedBox(height: 20),
                        _shareLocationBtn(
                          context,
                          successLocationSnackBar,
                          textTheme,
                        ),
                        const SizedBox(height: 20),
                        _sendOrderBlocConsumer(textTheme),
                      ] else ...[
                        ShowDialog.showAlertDialog(
                          context,
                          'Terjadi kesalahan!',
                          'Ada masalah di aplikasinya\nkakak bisa coba buat kembali ke halaman sebelumnya\natau hubungin CS kami',
                          ElevatedButton.icon(
                            onPressed: () {
                              context.pop();
                              context.pop();
                            },
                            label: const Text('Kembali'),
                            icon: const Icon(Icons.arrow_forward_ios),
                            iconAlignment: IconAlignment.end,
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BlocConsumer<SendOrderBloc, SendOrderState> _sendOrderBlocConsumer(
      TextTheme textTheme) {
    return BlocConsumer<SendOrderBloc, SendOrderState>(
      listener: (context, state) {
        if (state is OrderError) {
          ShowDialog.showAlertDialog(
            context,
            'Error upload order',
            state.errorMessage,
            null,
          );
          context.read<SendOrderBloc>().add(OrderIsIdle());
        } else if (state is SendOrderError) {
          ShowDialog.showAlertDialog(
            context,
            'Gagal!',
            state.message,
            null,
          );
        } else if (state is OrderUploaded) {
          ShowDialog.showAlertDialog(
            context,
            'Success',
            state.message,
            null,
          );
          context.read<ManageOrderBloc>().haveActiveOrder = true;
          context.read<HomeCubit>().fetchHistory();
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return _requestHelpBtn(context, textTheme);
        }
      },
    );
  }

  SizedBox _requestHelpBtn(BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 71,
      child: TextButton(
        onPressed: () {
          context
              .read<SendOrderBloc>()
              .add(OrderSubmitted(widget.problem.toString()));
        },
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            AppColors.primary,
          ),
        ),
        child: Text(
          'Minta Bantuan',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  GestureDetector _shareLocationBtn(BuildContext context,
      SnackBar successLocationSnackBar, TextTheme textTheme) {
    return GestureDetector(
      onTap: () {
        getLocation();
        if (lat != null && long != null) {
          ScaffoldMessenger.of(context).showSnackBar(successLocationSnackBar);
          context
              .read<SendOrderBloc>()
              .add(ShareLocation(lat: lat!, long: long!));
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/assistant_navigation.svg',
            width: 28,
            height: 28,
          ),
          const SizedBox(width: 10),
          Text(
            'Bagikan Lokasi Saya',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.lightTextColor,
              fontSize: 21,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _addPictureSection(TextTheme textTheme) {
    return [
      const SizedBox(height: 20),
      Text(
        questions.last.toString(),
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      BlocBuilder<SendOrderBloc, SendOrderState>(
        builder: (context, state) {
          if (state is ImagePicked) {
            state.pickedImage != null && problemPictures.length < 2
                ? problemPictures.add(state.pickedImage)
                : null;
            showedPicture.clear();
            for (var i = 0; i < problemPictures.length; i++) {
              XFile? picture = problemPictures[i];
              showedPicture.add(
                _previewImage(
                  picture!.path,
                  picture.name,
                  i,
                ),
              );
            }
            context.read<SendOrderBloc>().add(OrderIsIdle());
          }
          if (state is ImageDeleted) {
            problemPictures.removeAt(state.imageIndex);
            showedPicture.clear();
            for (var i = 0; i < problemPictures.length; i++) {
              XFile? picture = problemPictures[i];
              showedPicture.add(
                _previewImage(
                  picture!.path,
                  picture.name,
                  i,
                ),
              );
            }
            context.read<SendOrderBloc>().add(OrderIsIdle());
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...showedPicture,
              if (problemPictures.length < 2) _addImage(context, state),
            ],
          );
        },
      ),
    ];
  }

  Widget _previewImage(String imagePath, String imageName, int imageIndex) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        'imageZoomPage',
        queryParameters: {
          'imagePath': imagePath,
          'imageName': imageName,
        },
      ),
      onLongPress: () => context
          .read<SendOrderBloc>()
          .add(DeleteImage(imageIndex: imageIndex)),
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SizedBox(
          width: 68,
          height: 68,
          child: Hero(
            tag: imageName,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: AppColors.lightTextColor,
                  ),
                  child: Image.file(
                    File(imagePath),
                    isAntiAlias: true,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _addImage(BuildContext context, SendOrderState state) {
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: AppColors.lightTextColor,
            ),
          ),
          _pickImageBtn(context, state),
        ],
      ),
    );
  }

  PopupMenuButton<MenuItemModel> _pickImageBtn(
    BuildContext context,
    SendOrderState state,
  ) {
    return PopupMenuButton<MenuItemModel>(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.lightTextColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.transparent,
      tooltip: 'Ambil gambar',
      position: PopupMenuPosition.under,
      icon: const Icon(
        Icons.add,
        color: AppColors.primary,
      ),
      onSelected: (value) => _pickImageMenuFunction(context, state, value),
      itemBuilder: (context) => [...MenuItems.pickImageItems.map(_buildItem)],
    );
  }

  PopupMenuItem<MenuItemModel> _buildItem(MenuItemModel item) =>
      PopupMenuItem<MenuItemModel>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon),
            const SizedBox(width: 10),
            Text(item.title),
          ],
        ),
      );

  void _pickImageMenuFunction(
      BuildContext context, SendOrderState state, MenuItemModel item) {
    switch (item) {
      case MenuItems.itemFromCamera:
        context.read<SendOrderBloc>().add(CameraCapture());
        break;
      case MenuItems.itemFromGallery:
        context.read<SendOrderBloc>().add(GalleryImagePicker());
        break;
      default:
        printError('What are you tapping? $item');
        break;
    }
  }

  TextFormField _serabutanInputField(TextTheme textTheme) {
    return TextFormField(
      controller: _serabutanInputController,
      onChanged: (value) {
        context
            .read<SendOrderBloc>()
            .add(SolutionSelected(_serabutanInputController.text.toString()));
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Butuh bantuan apa?',
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: AppColors.hintTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  DropdownMenu<String> _drowdownQuesitonChoices(
      BuildContext context, TextTheme textTheme) {
    return DropdownMenu<String>(
      expandedInsets: const EdgeInsets.all(0),
      textStyle: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.w500,
      ),
      menuStyle: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.surface),
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
        context
            .read<SendOrderBloc>()
            .add(SolutionSelected(selectedChoice.toString()));
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
      scrolledUnderElevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      // leading: BackButton(
      //   onPressed: () => context.goNamed('homePage'),
      // ),
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
}
