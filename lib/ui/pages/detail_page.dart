import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help_me_client_alpha_ver/configs/app_route.dart';

import '../../blocs/order_blocs/order_bloc.dart';
import '../../configs/app_colors.dart';
import '../../models/problem_model.dart';
import '../../services/api/api_helper.dart';
import '../../utils/show_dialog.dart';

enum ProblemCategory { serabutan, kendaraan, rumah, elektronik }

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, this.categoryId, this.category});

  final int? categoryId;
  final String? category;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final colorScheme = appTheme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: _appBar(context, textTheme),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              width: screenWidth,
              height: screenHeight / 5,
              child: Container(
                color: Colors.black,
                child: _detailHeadline(textTheme),
              ),
            ),
            Positioned(
              bottom: 0,
              width: screenWidth,
              height: screenHeight - (screenHeight / 5),
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (contextBuilder, state) {
                  if (state is OrderInitial) {
                    if (categoryId != null &&
                        category?.toLowerCase() != 'serabutan') {
                      contextBuilder
                          .read<OrderBloc>()
                          .add(FetchProblems(id: categoryId!));
                    } else if (categoryId != null &&
                        category?.toLowerCase() == 'serabutan') {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ShowDialog.showAlertDialog(
                          contextBuilder,
                          'Fiture masih dikembangkan',
                          'Fitur masih dikembangkan ya ka\n Mohon tunggu',
                          ElevatedButton.icon(
                            onPressed: () => context.canPop()
                                ? context.pop()
                                : context.goNamed('homePage'),
                            icon: const Icon(Icons.arrow_forward_ios),
                            label: const Text('Kembali'),
                          ),
                        );
                      });
                      // context.pushReplacementNamed('/addTaskPage'); TODO: Enable this later
                    } else {
                      _categoryIdNotFound(contextBuilder);
                    }
                  } else if (state is OrderLoading) {
                    return const SizedBox.expand(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  } else if (state is ProblemsLoaded) {
                    List<ProblemModel> problems = state.problems;
                    ProblemModel selectedProblem = problems.first;
                    if (problems.isNotEmpty) {
                      return ListView.builder(
                        itemCount: problems.length,
                        itemBuilder: (BuildContext context, int index) {
                          ProblemModel data = problems[index];
                          return RadioListTile(
                            value: data.name,
                            groupValue: selectedProblem,
                            onChanged: (value) =>
                                selectedProblem = value as ProblemModel,
                          );
                        },
                      );
                    }
                  } else if (state is ProblemsError) {
                    _stateError(context, state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _stateError(BuildContext context, ProblemsError state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowDialog.showAlertDialog(
        context,
        'Error fetching problems',
        state.errorMessage,
        IconButton.outlined(
          onPressed: () {
            context.pop();
            context.read<OrderBloc>().add(FetchProblems(id: categoryId!));
          },
          icon: const Icon(Icons.refresh_outlined),
        ),
      );
    });
  }

  Widget _categoryIdNotFound(BuildContext context) {
    return ShowDialog.showAlertDialog(
      context,
      'Error',
      'Category tidak ada',
      ElevatedButton.icon(
        onPressed: () =>
            context.canPop() ? context.pop() : context.goNamed('homePage'),
        label: const Text('Kembali'),
        icon: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Padding _detailHeadline(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text.rich(
        softWrap: true,
        style: textTheme.headlineSmall?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
        category?.toLowerCase().contains('serabutan') == false
            ? _detailHeadlineText('hmm, Kenapa\n$category?')
            : _detailHeadlineText('hmm, Butuh \nbantuan apa kali ini?'),
      ),
    );
  }

  TextSpan _detailHeadlineText(String text) {
    return TextSpan(text: text);
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        'Help Me!',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
