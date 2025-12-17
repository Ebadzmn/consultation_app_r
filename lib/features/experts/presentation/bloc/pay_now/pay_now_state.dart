import 'package:equatable/equatable.dart';
import '../../models/pay_now_args.dart';

enum PayNowStatus { initial, paying, paid, later }

class PayNowState extends Equatable {
  final PayNowArgs args;
  final Duration remaining;
  final PayNowStatus status;

  const PayNowState({
    required this.args,
    required this.remaining,
    this.status = PayNowStatus.initial,
  });

  PayNowState copyWith({
    PayNowArgs? args,
    Duration? remaining,
    PayNowStatus? status,
  }) {
    return PayNowState(
      args: args ?? this.args,
      remaining: remaining ?? this.remaining,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [args, remaining, status];
}
