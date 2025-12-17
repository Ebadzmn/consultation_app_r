import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/pay_now_args.dart';
import 'pay_now_event.dart';
import 'pay_now_state.dart';

class PayNowBloc extends Bloc<PayNowEvent, PayNowState> {
  final DateTime _endAt;
  Timer? _timer;

  PayNowBloc({required PayNowArgs args})
      : _endAt = DateTime.now().add(args.payWithin),
        super(
          PayNowState(
            args: args,
            remaining: args.payWithin,
          ),
        ) {
    on<PayNowTicked>(_onTicked);
    on<PayNowPressed>(_onPayNowPressed);
    on<PayLaterPressed>(_onPayLaterPressed);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = _endAt.difference(DateTime.now());
      add(PayNowTicked(remaining.isNegative ? Duration.zero : remaining));
    });
  }

  void _onTicked(PayNowTicked event, Emitter<PayNowState> emit) {
    emit(state.copyWith(remaining: event.remaining));
  }

  Future<void> _onPayNowPressed(
    PayNowPressed event,
    Emitter<PayNowState> emit,
  ) async {
    emit(state.copyWith(status: PayNowStatus.paying));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(state.copyWith(status: PayNowStatus.paid));
  }

  void _onPayLaterPressed(PayLaterPressed event, Emitter<PayNowState> emit) {
    emit(state.copyWith(status: PayNowStatus.later));
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }
}
