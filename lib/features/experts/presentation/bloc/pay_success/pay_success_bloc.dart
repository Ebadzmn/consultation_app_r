import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/pay_now_args.dart';
import 'pay_success_event.dart';
import 'pay_success_state.dart';

class PaySuccessBloc extends Bloc<PaySuccessEvent, PaySuccessState> {
  PaySuccessBloc({required PayNowArgs args})
      : super(PaySuccessState(args: args)) {
    on<PaySuccessMoveToProfilePressed>(_onMoveToProfilePressed);
  }

  void _onMoveToProfilePressed(
    PaySuccessMoveToProfilePressed event,
    Emitter<PaySuccessState> emit,
  ) {
    emit(state);
  }
}

