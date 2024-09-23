import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/problem_model.dart';
import '../../services/api/api_controller.dart';
import '../../services/api/api_helper.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiController apiController;

  late ProblemModel? selectedProblem;

  OrderBloc({required this.apiController}) : super(OrderInitial()) {
    on<FetchProblems>(_onFetchProblems);

    on<ProblemSelected>((event, emit) {
      selectedProblem = event.selectedProblem;
      // emit(state.copyWith(selectedProblem: event.selectedProblem));
    });

    on<ProblemsPop>((event, emit) {
      emit(OrderInitial());
    });
  }

  Future<void> _onFetchProblems(
    FetchProblems event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final response = await ApiHelper.getProblems(event.id);
      if (response is ApiErrorResponseModel) {
        emit(ProblemsError(errorMessage: response.error!.error.toString()));
      } else {
        emit(ProblemsLoaded(problems: response.data));
      }
    } catch (e) {
      emit(ProblemsError(errorMessage: e.toString()));
    }
  }
}
